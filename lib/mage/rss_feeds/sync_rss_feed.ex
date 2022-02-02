defmodule Mage.RssFeeds.SyncRssFeed do
  alias Mage.Repo
  alias Mage.RssFeeds
  alias Mage.RssFeeds.RssFeed
  alias Mage.ContextHelpers

  def sync_rss_feed(:from_remote, feed_url) do
    case HTTPoison.get(feed_url, [], follow_redirect: true, timeout: 5500, recv_timeout: 5500) do
      {:ok, %HTTPoison.Response{status_code: status_code, body: xml_string}} ->
        if status_code < 300 and status_code >= 200 do
          case ElixirFeedParser.parse(xml_string |> String.replace("Invalid Date", "")) do
            {:ok, feed} ->
              updated_site_attrs = %{
                first_entity_title: retrieve_first_entity(:title, feed),
                first_entity_url: retrieve_first_entity(:url, feed),
                first_entity_published_at: retrieve_first_entity(:published_at, feed),
                first_entity_summary: retrieve_first_entity(:summary, feed),
                last_error: nil,
                last_synced_at: DateTime.utc_now()
              }

              {:ok, updated_site_attrs}

            _ ->
              {:error, %{message: "XML 解析失败"}}
          end
        else
          {:error, %{message: "链接解析失败"}}
        end

      {:error, %HTTPoison.Error{reason: :timeout}} ->
        {:error, %{message: "链接请求超时"}}

      _ ->
        {:error, %{message: "链接请求失败"}}
    end
    |> case do
      {:ok, updated_site_attrs} ->
        RssFeeds.update_or_create_rss_feed(%{feed_url: feed_url}, updated_site_attrs)

      {:error, error} ->
        RssFeeds.update_or_create_rss_feed(%{feed_url: feed_url}, %{
          last_error: :erlang.term_to_binary(error),
          last_synced_at: DateTime.utc_now()
        })

        {:ok, nil}
    end
  end

  def sync_rss_feed(link_url, link_body_html) do
    with {:ok, document} <- Floki.parse_document(link_body_html),
         feed_urls <- parse_feed_url(link_url, document) do
      case feed_urls do
        [feed_url | _tail] ->
          rss_feed = Repo.get_by(RssFeed, %{feed_url: feed_url})

          case should_sync?(rss_feed) do
            true ->
              sync_rss_feed(:from_remote, feed_url)

            false ->
              {:ok, rss_feed}
          end

        _ ->
          nil
      end
    end
  end

  @seconds_per_day 3600 * 24

  defp should_sync?(nil), do: true
  defp should_sync?(%RssFeed{last_synced_at: nil}), do: true

  defp should_sync?(rss_feed) do
    now = DateTime.utc_now()

    if DateTime.diff(now, rss_feed.last_synced_at) < @seconds_per_day do
      false
    else
      true
    end
  end

  defp retrieve_first_entity(:title, %{entries: [%{title: title} | _tail]})
       when is_binary(title) do
    title
  end

  defp retrieve_first_entity(:url, %{entries: [%{url: url} | _tail]}) when is_binary(url) do
    url
  end

  defp retrieve_first_entity(:summary, %{entries: [%{description: description} | _tail]})
       when is_binary(description) do
    description
  end

  defp retrieve_first_entity(:summary, %{entries: [%{content: content} | _tail]})
       when is_binary(content) do
    HtmlSanitizeEx.strip_tags(content)
    |> String.slice(0, 400)
  end

  defp retrieve_first_entity(:published_at, %{
         entries: [%{"rss2:pubDate": %DateTime{} = datetime}]
       }) do
    datetime
  end

  defp retrieve_first_entity(:published_at, _), do: nil
  defp retrieve_first_entity(_type, _), do: ""

  defp filter_feeds(nodes) do
    nodes
    |> Enum.filter(fn node ->
      Floki.attribute(node, "type")
      |> case do
        ["application/rss+xml"] -> true
        _ -> false
      end
    end)
  end

  defp parse_feed_url(link_url, document) do
    Floki.find(document, "link[rel]")
    |> filter_feeds()
    |> List.wrap()
    |> aggregate_feed_urls(link_url)
    |> Enum.map(&build_feed_url(&1, link_url))
    |> Enum.filter(&(!is_nil(&1)))
  end

  defp build_feed_url(nil, _link_url), do: nil

  defp build_feed_url("/" <> relative_url, link_url) do
    case URI.parse(link_url) do
      %URI{host: host, scheme: scheme} ->
        site_url = URI.to_string(%URI{host: host, scheme: scheme})

        site_url <> "/" <> relative_url

      _ ->
        nil
    end
  end

  defp build_feed_url(url, _link_url), do: url

  defp aggregate_feed_urls(nodes, _link_url) when is_list(nodes) do
    nodes
    |> Enum.map(fn node ->
      with [href] <- Floki.attribute(node, "href") do
        href
      else
        _ -> nil
      end
    end)
  end
end
