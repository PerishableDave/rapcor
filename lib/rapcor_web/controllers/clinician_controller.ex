defmodule RapcorWeb.ClinicianController do
  use RapcorWeb, :controller

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.Authorization.ClinicianAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ClinicianAuthPlug when action in [:show, :update, :delete, :current]

  def index(conn, _params) do
    clinicians = ClinicianAccounts.list_clinicians()
    render(conn, "index.json", clinicians: clinicians)
  end

  def create(conn, %{"clinician" => clinician_params}) do
    with {:ok, %Clinician{} = clinician} <- ClinicianAccounts.create_clinician(clinician_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", clinician_path(conn, :show, clinician))
      |> render("show.json", clinician: clinician)
    end
  end

  def show(conn, %{"id" => id}) do
    clinician = current_clinician(conn)
    if String.to_integer(id) == clinician.id do
      render(conn, "show.json", clinician: clinician)
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def current(conn, _params) do
    clinician = current_clinician(conn)
    render(conn, "show.json", clinician: clinician)
  end

  def update(conn, %{"id" => id, "clinician" => clinician_params}) do
    clinician = current_clinician(conn)
    if String.to_integer(id) == clinician.id do
      with {:ok, %Clinician{} = clinician} <- ClinicianAccounts.update_clinician(clinician, clinician_params) do
        render(conn, "show.json", clinician: clinician)
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    clinician = current_clinician(conn)
    if String.to_integer(id) == clinician.id do
      with {:ok, %Clinician{}} <- ClinicianAccounts.delete_clinician(clinician) do
        send_resp(conn, :no_content, "")
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end
end
