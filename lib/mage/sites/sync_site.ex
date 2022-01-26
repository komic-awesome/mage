defmodule Mage.Sites.SyncSite do
  alias Mage.Sites
  alias Mage.ContextHelpers

  def sync_site(link_url, link_body_html) do
    case URI.parse(link_url) do
      %{host: host, scheme: scheme} ->
        site_url = URI.to_string(%URI{host: host, scheme: scheme})

        updated_site_attrs =
          case get_favicon(site_url, link_body_html) do
            {:ok, current_icon} ->
              %{
                icon: current_icon
              }

            _ ->
              %{
                icon: nil
              }
          end

        Sites.update_or_create_site(%{host: host}, updated_site_attrs)

      _ ->
        {:ok, nil}
    end
  end

  defp get_favicon(site_url, body_html) do
    get_favicon_from_html(site_url, body_html)
  end

  defp get_favicon_from_html(site_url, body_html) do
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
          {:not_found}
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
        ["icon"] -> true
        ["apple-touch-icon"] -> true
        _ -> false
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
