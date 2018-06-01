defmodule Rapcor.PhotoStorage do
  alias ExAws.S3

  @bucket Application.get_env(:rapcor, __MODULE__) |> Keyword.get(:bucket)

  def upload_file(filepath) do
    ext = Path.extname(filepath)
    uuid = UUID.uuid4(:hex)
    filename = uuid <> "." <> ext

    filepath
    |> S3.Upload.stream_file
    |> S3.upload(@bucket, filename)
    |> ExAws.request
  end
end
