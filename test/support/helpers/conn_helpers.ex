defmodule RapcorWeb.Helpers.ConnHelpers do
  import Plug.Conn

  alias Plug.Conn
  alias Rapcor.ClinicianAccounts.ClinicianToken

  def put_auth(%Conn{} = conn, %ClinicianToken{} = token) do
    put_req_header(conn, "authorization", "Bearer " <> token.id)
  end
end
