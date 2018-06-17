defmodule RapcorWeb.ProviderView do
  use RapcorWeb, :view
  alias RapcorWeb.ProviderView

  def render("index.json", %{providers: providers}) do
    %{data: render_many(providers, ProviderView, "provider.json")}
  end

  def render("show.json", %{provider: provider}) do
    %{data: render_one(provider, ProviderView, "provider.json")}
  end

  def render("provider.json", %{provider: provider}) do
    %{id: provider.id,
      name: provider.name,
      contact_email: provider.contact_email,
      contact_number: provider.contact_number,
      country: provider.country,
      administrative_area: provider.administrative_area,
      locality: provider.locality,
      postal_code: provider.postal_code,
      premise: provider.premise,
      sub_administrative_area: provider.sub_administrative_area,
      thoroughfare: provider.thoroughfare,
      password_hash: provider.password_hash}
  end
end
