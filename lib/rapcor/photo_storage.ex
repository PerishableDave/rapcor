defmodule Rapcor.PhotoStorage do
  import SweetXml
  alias ExAws.S3

  @bucket Application.get_env(:rapcor, __MODULE__) |> Keyword.get(:bucket)

  def upload_file(filepath) do
    ext = Path.extname(filepath)
    uuid = UUID.uuid4(:hex)
    filename = uuid <> ext

    request = filepath
    |> S3.Upload.stream_file
    |> S3.upload(@bucket, filename)

    with {:ok, %{body: body, status_code: 200}} <- ExAws.request(request),
         location <- to_string(xpath(body, ~x"//Location/text()")),
    do: {:ok, location}
  end
end
