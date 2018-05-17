defmodule RapcorWeb.ClinicianExperienceView do
  use RapcorWeb, :view
  alias RapcorWeb.ClinicianExperienceView

  def render("index.json", %{clinician_experiences: clinician_experiences}) do
    %{clinician_experiences: render_many(clinician_experiences, ClinicianExperienceView, "clinician_experience.json")}
  end

  def render("show.json", %{clinician_experience: clinician_experience}) do
    %{clinician_experience: render_one(clinician_experience, ClinicianExperienceView, "clinician_experience.json")}
  end

  def render("clinician_experience.json", %{clinician_experience: clinician_experience}) do
    %{clinician_id: clinician_experience.clinician_id,
      experience_id: clinician_experience.experience_id,
      years: clinician_experience.years}
  end
end

