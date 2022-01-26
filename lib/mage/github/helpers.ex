defmodule Mage.Github.Helpers do
  defp valid_url?(url) do
    uri = URI.parse(url)
    uri.scheme != nil && uri.host =~ "."
  end

  def link(nil) do
    nil
  end

  def link(url) do
    url = url |> String.downcase() |> String.trim() |> String.replace(~r/\/$/, "")

    if valid_url?(url) and String.starts_with?(url, ["http://", "https://"]) do
      url
    else
      url = "https://#{url}"

      if valid_url?(url) do
        url
      else
        nil
      end
    end
  end
end
