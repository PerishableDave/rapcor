defmodule RapcorWeb.ClinicianTokenController do
  use RapcorWeb, :controller

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.ClinicianToken

  action_fallback RapcorWeb.FallbackController

  def create(conn, %{"email" => email, "password" => password}) do
    with {:ok, %ClinicianToken{} = clinician_token} <- ClinicianAccounts.create_clinician_token(email, password) do
      conn
      |> put_status(:created)
      |> render("show.json", clinician_token: clinician_token)
    end
  end

  def create(conn, _params) do
    conn
    |> send_resp(:bad_request, "")
  end

  def delete(conn, %{"id" => id}) do
    clinician_token = ClinicianAccounts.get_clinician_token!(id)
    with {:ok, %ClinicianToken{}} <- ClinicianAccounts.delete_clinician_token(clinician_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
