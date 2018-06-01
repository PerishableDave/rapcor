defmodule Rapcor.Authorization.ClinicianAuthPlug do
  import Plug.Conn

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Clinician

  def init(_opts) do
  end

  def call(conn, _opts) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
         %Clinician{} = clinician <- ClinicianAccounts.get_clinician_by_token(token)
    do
      assign(conn, :current_clinician, clinician)
    else
      _ ->
        conn
        |> send_resp(:unauthorized, "Unauthorized")
        |> halt
    end
  end
end
