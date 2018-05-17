defmodule RapcorWeb.ClinicianExperienceController do
  use RapcorWeb, :controller

  alias Rapcor.Authorization.ClinicianAuthPlug
  alias Rapcor.ClinicianAccounts.ClinicianExperience
  alias Rapcor.ClinicianAccounts

  action_fallback RapcorWeb.FallbackController

  plug ClinicianAuthPlug when action in [:index, :create]

  def index(conn, _params) do
    clinician = current_clinician(conn)
    clinician_experiences = ClinicianAccounts.list_clinician_experiences(clinician)
    render(conn, "index.json", clinician_experiences: clinician_experiences)
  end

  def create(conn, %{"clinician_experience" => clinician_experience_params}) do
    clinician = current_clinician(conn)
    clinician_experience_params = Map.put(clinician_experience_params, "clinician_id", clinician.id)

    with {:ok, %ClinicianExperience{} = clinician_experience} <- ClinicianAccounts.create_clinician_experience(clinician_experience_params) do
      conn
      |> put_status(:created)
      |> render("show.json", clinician_experience: clinician_experience)
    end
  end

  def create(conn, %{"clinician_experiences" => clinician_experience_params}) do
    clinician_id = current_clinician(conn).id

    clinician_experiences = clinician_experience_params
                            |> Enum.map(&filter_batch_params/1)
                            |> Enum.map(fn params -> Map.put(params, :clinician_id, clinician_id) end)
    ClinicianAccounts.create_or_update_clinician_experiences(clinician_experiences)
    send_resp(conn, :accepted, "")
  end

  def filter_batch_params(%{"experience_id" => experience_id, "years" => years}) do
    %{experience_id: experience_id, years: years}
  end
end
