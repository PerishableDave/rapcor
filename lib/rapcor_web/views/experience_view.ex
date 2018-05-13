defmodule RapcorWeb.ExperienceView do
  use RapcorWeb, :view
  alias RapcorWeb.ExperienceView

  def render("index.json", %{experiences: experiences}) do
    %{experiences: render_many(experiences, ExperienceView, "experience.json")}
  end

  def render("show.json", %{experience: experience}) do
    %{experience: render_one(experience, ExperienceView, "experience.json")}
  end

  def render("experience.json", %{experience: experience}) do
    %{id: experience.id,
      description: experience.description}
  end
end
