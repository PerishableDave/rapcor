defmodule RapcorWeb.ProviderTokenView do
  use RapcorWeb, :view
  alias RapcorWeb.ProviderTokenView

  def render("index.json", %{provider_tokens: provider_tokens}) do
    %{data: render_many(provider_tokens, ProviderTokenView, "provider_token.json")}
  end

  def render("show.json", %{provider_token: provider_token}) do
    %{data: render_one(provider_token, ProviderTokenView, "provider_token.json")}
  end

  def render("provider_token.json", %{provider_token: provider_token}) do
    %{id: provider_token.id,
      source: provider_token.source}
  end
end
