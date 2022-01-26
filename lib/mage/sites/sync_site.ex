defmodule Mage.Sites.SyncSite do
  alias Mage.Repo
  alias Mage.Sites
  alias Mage.Sites.Site
  alias Mage.ContextHelpers

  def sync_site(link_url, link_body_html) do
    case URI.parse(link_url) do
      %{host: host, scheme: scheme} ->
        site = Repo.get_by(Site, %{host: host})

        case should_sync?(site) do
          true ->
            sync_site(:from_remote, link_url, link_body_html)

          false ->
            {:ok, site}
        end

      _ ->
        {:ok, nil}
    end
  end

  @seconds_per_week 3600 * 24 * 7

  defp should_sync?(nil), do: true
  defp should_sync?(%Site{last_synced_at: nil}), do: true

  defp should_sync?(site) do
    now = DateTime.utc_now()

    if DateTime.diff(now, site.last_synced_at) < @seconds_per_week do
      false
    else
      true
    end
  end

  defp sync_site(:from_remote, link_url, link_body_html) do
    case URI.parse(link_url) do
      %{host: host, scheme: scheme} ->
        updated_site_attrs =
          case get_favicon(%{host: host, scheme: scheme}, link_body_html) do
            {:ok, current_icon} ->
              %{
                icon: current_icon
              }

            _ ->
              %{
                icon: nil
              }
          end

        updated_site_attrs = Map.put_new(updated_site_attrs, :last_synced_at, DateTime.utc_now())
        Sites.update_or_create_site(%{host: host}, updated_site_attrs)

      _ ->
        {:ok, nil}
    end
  end

  defp get_favicon(%{host: host, scheme: scheme}, body_html) do
    get_favicon_from_html(%{host: host, scheme: scheme}, body_html)
  end

  defp get_favicon_from_html(%{host: host, scheme: scheme}, body_html) do
    site_url = URI.to_string(%URI{host: host, scheme: scheme})

    with {:ok, document} <- Floki.parse_document(body_html),
         icons <- parse_icons(site_url, document) do
      case icons do
        [icon | _tail] ->
          icon
          |> case do
            %{url: url} ->
              download_icon(url)

            _ ->
              {:not_found}
          end
          |> case do
            {:ok, current_icon} -> {:ok, current_icon}
            _ -> {:not_found}
          end

        _ ->
          download_site_url =
            case host do
              "weibo.com" -> URI.to_string(%URI{host: host, scheme: "https"})
              _ -> URI.to_string(%URI{host: host, scheme: scheme})
            end

          case download_icon(download_site_url <> "/favicon.ico") do
            {:ok, current_icon} -> {:ok, current_icon}
            _ -> {:not_found}
          end
      end
    else
      _any -> {:not_found}
    end
  end

  defp parse_icons(site_url, document) do
    Floki.find(document, "link[rel]")
    |> List.wrap()
    |> filter_icons()
    |> aggregate_icons(site_url)
    |> Enum.filter(&is_map/1)
  end

  defp aggregate_icons(nodes, site_url) when is_list(nodes) do
    nodes
    |> Enum.map(fn node ->
      with [href] <- Floki.attribute(node, "href") do
        build_icon(ensure_absolute_url(href, site_url), Floki.attribute(node, "sizes"))
      else
        _ -> nil
      end
    end)
  end

  @spec build_icon(binary(), list()) :: map()
  def build_icon(href, sizes) do
    case sizes do
      [] ->
        %{type: "icon", url: href}

      [sizes] ->
        case String.split(sizes, ["x", "X"]) do
          [w, h] ->
            %{type: "icon", width: w, height: h, url: href}

          _ ->
            %{type: "icon", url: href}
        end
    end
  end

  defp filter_icons(nodes) do
    nodes
    |> Enum.filter(fn node ->
      Floki.attribute(node, "rel")
      |> case do
        ["alternate icon"] -> true
        ["shortcut icon"] -> true
        ["shortcur icon"] -> true
        ["shorticon icon"] -> true
        ["icon"] -> true
        ["apple-touch-icon"] -> true
        _ -> false
      end
    end)
    |> Enum.filter(fn node ->
      Floki.attribute(node, "href")
      |> case do
        ["data:" <> _tail] -> false
        _ -> true
      end
    end)
  end

  defp ensure_absolute_url(url, site_url) when is_binary(url) do
    url
    |> URI.parse()
    |> Map.get(:scheme)
    |> case do
      nil -> make_absolute_url(url, site_url)
      _url -> url
    end
  end

  defp ensure_absolute_url(url, _), do: url

  defp make_absolute_url(url, site_url) do
    site_url = URI.parse(site_url)
    parsed_url = URI.parse(url)

    parsed_url
    |> Map.put(:authority, site_url.authority)
    |> Map.put(:host, site_url.host)
    |> Map.put(:scheme, site_url.scheme)
    |> Map.put(:port, site_url.port)
    |> Map.put(:path, prefix_with_slash(parsed_url.path))
    |> URI.to_string()
  end

  defp prefix_with_slash(<<"/", _rest::binary>> = string) do
    string
  end

  defp prefix_with_slash(string) do
    "/" <> string
  end

  defp download_icon(url) do
    ContextHelpers.download_file(url, "icons")
  end
end
