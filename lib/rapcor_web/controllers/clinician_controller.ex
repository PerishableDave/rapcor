defmodule RapcorWeb.ClinicianController do
  use RapcorWeb, :controller

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Clinician

  action_fallback RapcorWeb.FallbackController

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
    clinician = ClinicianAccounts.get_clinician!(id)
    render(conn, "show.json", clinician: clinician)
  end

  def update(conn, %{"id" => id, "clinician" => clinician_params}) do
    clinician = ClinicianAccounts.get_clinician!(id)

    with {:ok, %Clinician{} = clinician} <- ClinicianAccounts.update_clinician(clinician, clinician_params) do
      render(conn, "show.json", clinician: clinician)
    end
  end

  def delete(conn, %{"id" => id}) do
    clinician = ClinicianAccounts.get_clinician!(id)
    with {:ok, %Clinician{}} <- ClinicianAccounts.delete_clinician(clinician) do
      send_resp(conn, :no_content, "")
    end
  end
end
