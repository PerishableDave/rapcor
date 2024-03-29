defmodule RapcorWeb.Helpers.ConnHelpers do
  import Plug.Conn

  alias Plug.Conn

  def put_auth(%Conn{} = conn, token) do
    put_req_header(conn, "authorization", "Bearer " <> token.id)
  end
end
