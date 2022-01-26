defmodule Mage.ContextHelpers do
  def download_file(url, prefix) do
    with workspace_path <- Path.join(Path.expand("./uploads"), prefix),
         :ok <- File.mkdir_p(workspace_path),
         {:ok, %HTTPoison.Response{body: body}} <-
           HTTPoison.get(url, [], timeout: 60_000, recv_timeout: 60_000),
         {mime_type, width, height, _} <- ExImageInfo.info(body),
         [format | _tail] <- MIME.extensions(mime_type),
         key <- "#{upload_filename(url, format)}",
         :ok <- File.write("#{workspace_path}/#{key}", body) do
      {:ok,
       %{
         width: width,
         height: height,
         format: format,
         key: key
       }}
    else
      result ->
        {:error, result}
    end
  end

  defp upload_filename(url, format) do
    urlhash = Base.encode16(:erlang.md5(url), case: :lower)

    case format do
      "" -> urlhash
      nil -> urlhash
      format -> "#{urlhash}.#{format}"
    end
  end
end
