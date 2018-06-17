defmodule RapcorWeb.ProviderController do
  use RapcorWeb, :controller

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider

  action_fallback RapcorWeb.FallbackController

  def index(conn, _params) do
    providers = ProviderAccounts.list_providers()
    render(conn, "index.json", providers: providers)
  end

  def create(conn, %{"provider" => provider_params}) do
    with {:ok, %Provider{} = provider} <- ProviderAccounts.create_provider(provider_params) do
      conn
      |> put_status(:created)
      |> render("show.json", provider: provider)
    end
  end

  def show(conn, %{"id" => id}) do
    provider = ProviderAccounts.get_provider!(id)
    render(conn, "show.json", provider: provider)
  end

  def update(conn, %{"id" => id, "provider" => provider_params}) do
    provider = ProviderAccounts.get_provider!(id)

    with {:ok, %Provider{} = provider} <- ProviderAccounts.update_provider(provider, provider_params) do
      render(conn, "show.json", provider: provider)
    end
  end

  def delete(conn, %{"id" => id}) do
    provider = ProviderAccounts.get_provider!(id)
    with {:ok, %Provider{}} <- ProviderAccounts.delete_provider(provider) do
      send_resp(conn, :no_content, "")
    end
  end
end
