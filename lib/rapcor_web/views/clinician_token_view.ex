defmodule RapcorWeb.ClinicianTokenView do
  use RapcorWeb, :view
  alias RapcorWeb.ClinicianTokenView

  def render("index.json", %{clinician_tokens: clinician_tokens}) do
    %{tokens: render_many(clinician_tokens, ClinicianTokenView, "clinician_token.json")}
  end

  def render("show.json", %{clinician_token: clinician_token}) do
    %{token: render_one(clinician_token, ClinicianTokenView, "clinician_token.json")}
  end

  def render("clinician_token.json", %{clinician_token: clinician_token}) do
    %{id: clinician_token.id}
  end
end
