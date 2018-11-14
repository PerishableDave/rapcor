defmodule RapcorWeb.LocationView do
  use RapcorWeb, :view
  alias RapcorWeb.LocationView

  def render("index.json", %{locations: locations}) do
    %{locations: render_many(locations, LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{location: render_one(location, LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      name: location.name}
  end
end
