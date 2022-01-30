defmodule Mage.Links.SyncLink do
  alias Mage.Repo
  alias Mage.Links
  alias Mage.Links.Link
  alias Mage.Sites
  alias Mage.RssFeeds
  alias Mage.RssFeeds.RssFeed
  alias Mage.Sites.Site

  def sync_link(link_url) do
    link = Repo.get_by(Link, %{url: link_url})

    case should_sync?(link) do
      true ->
        sync_link(:from_remote, link_url)

      false ->
        {:ok, link}
    end
  end

  @seconds_per_week 3600 * 24 * 7
  @seconds_per_hour 3600

  defp should_sync?(nil), do: true
  defp should_sync?(%Link{last_synced_at: nil}), do: true

  defp should_sync?(link) do
    now = DateTime.utc_now()

    cond do
      link.status_code == 200 && DateTime.diff(now, link.last_synced_at) > @seconds_per_week ->
        true

      link.status_code != 200 && DateTime.diff(now, link.last_synced_at) > @seconds_per_hour ->
        true

      true ->
        false
    end
  end

  def sync_link(:from_remote, link_url) do
    with {:ok, %HTTPoison.Response{body: body_html, status_code: status_code} = resp} <-
           HTTPoison.get(link_url, [], follow_redirect: true, timeout: 1000, recv_timeout: 2000) do
      updated_attrs = process_updated_attrs(link_url, status_code, body_html)
      updated_attrs = Map.put_new(updated_attrs, :last_synced_at, DateTime.utc_now())

      updated_attrs =
        case Sites.sync_site(link_url, body_html) do
          {:ok, %Site{} = site} ->
            Map.put_new(updated_attrs, :site_id, site.id)

          _ ->
            updated_attrs
        end

      updated_attrs =
        case RssFeeds.sync_rss_feed(link_url, body_html) do
          {:ok, %RssFeed{} = rss_feed} ->
            Map.put_new(updated_attrs, :rss_feed_id, rss_feed.id)

          _ ->
            updated_attrs
        end

      Links.update_or_create_link(%{url: link_url}, updated_attrs)
    else
      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} ->
        Links.update_or_create_link(%{url: link_url}, %{
          status_code: 408,
          last_synced_at: DateTime.utc_now()
        })

      error ->
        error
    end
  end

  defp process_updated_attrs(link_url, 200, body_html) do
    %{
      status_code: 200,
      title: process_link_title(body_html)
    }
  end

  defp process_updated_attrs(link_url, status_code, body_html) do
    %{
      status_code: status_code
    }
  end

  defp process_link_title(body_html) do
    with {:ok, html} <- Floki.parse_document(body_html),
         title when is_binary(title) <-
           html
           |> Floki.find("title")
           |> Floki.text()
           |> String.trim()
           |> String.slice(0..254) do
      title
    else
      _any ->
        "无法解析标题"
    end
  end
end
