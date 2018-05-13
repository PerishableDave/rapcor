defmodule RapcorWeb.ExperienceController do
  use RapcorWeb, :controller

  alias Rapcor.ClinicianAccounts

  action_fallback RapcorWeb.FallbackController

  def index(conn, _params) do
    experiences = ClinicianAccounts.list_experiences()
    render(conn, "index.json", experiences: experiences)
  end
end
