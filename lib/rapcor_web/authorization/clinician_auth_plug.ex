defmodule Rapcor.Authorization.ClinicianAuthPlug do
  import Plug.Conn

  alias Rapcor.ClinicianAccounts

  def init(_opts) do
  end

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        clinician = ClinicianAccounts.get_clinician_by_token(token)
        unless clinician == nil do
          assign(conn, :current_clinician, clinician)
        end
      _ ->
        conn
        |> send_resp(:unauthorized, "Unauthorized")
        |> halt
    end
  end
end
