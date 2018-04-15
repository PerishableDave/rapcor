defmodule RapcorWeb.ClinicianView do
  use RapcorWeb, :view
  alias RapcorWeb.ClinicianView

  def render("index.json", %{clinicians: clinicians}) do
    %{data: render_many(clinicians, ClinicianView, "clinician.json")}
  end

  def render("show.json", %{clinician: clinician}) do
    %{data: render_one(clinician, ClinicianView, "clinician.json")}
  end

  def render("clinician.json", %{clinician: clinician}) do
    %{id: clinician.id,
      first_name: clinician.first_name,
      last_name: clinician.last_name,
      middle_name: clinician.middle_name,
      email: clinician.email,
      phone_number: clinician.phone_number,
      country: clinician.country,
      administrative_area: clinician.administrative_area,
      locality: clinician.locality,
      postal_code: clinician.postal_code,
      premise: clinician.premise,
      sub_administrative_area: clinician.sub_administrative_area,
      thoroughfare: clinician.thoroughfare}
  end
end
