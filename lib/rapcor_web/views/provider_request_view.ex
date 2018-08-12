defmodule RapcorWeb.ProviderRequestView do
  use RapcorWeb, :view
  alias RapcorWeb.ProviderRequestView

  def render("index.json", %{requests: requests}) do
    %{requests: render_many(requests, ProviderRequestView, "provider_request.json")}
  end

  def render("show.json", %{request: request}) do
    %{request: render_one(request, ProviderRequestView, "provider_request.json")}
  end

  def render("provider_request.json", %{provider_request: request}) do
    %{id: request.id,
      start_date: request.start_date,
      end_date: request.end_date,
      contact_email: request.contact_email,
      contact_phone: request.contact_phone,
      notes: request.notes,
      required_experiences: Enum.map(request.required_experiences, fn required_experience ->
        %{experience_id: required_experience.experience_id,
          minimum_years: required_experience.minimum_years}
      end)}
  end
end
