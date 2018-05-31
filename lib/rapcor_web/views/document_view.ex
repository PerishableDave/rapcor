defmodule RapcorWeb.DocumentView do
  use RapcorWeb, :view
  alias RapcorWeb.DocumentView

  def render("index.json", %{documents: documents}) do
    %{data: render_many(documents, DocumentView, "document.json")}
  end

  def render("show.json", %{document: document}) do
    %{data: render_one(document, DocumentView, "document.json")}
  end

  def render("document.json", %{document: document}) do
    %{id: document.id,
      slug: document.slug,
      number: document.number,
      expiration: document.expiration,
      state: document.state,
      front_photo: document.front_photo,
      back_photo: document.back_photo}
  end
end
