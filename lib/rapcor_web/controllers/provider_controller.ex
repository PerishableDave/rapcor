defmodule RapcorWeb.ProviderController do
  use RapcorWeb, :controller

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.Authorization.ProviderAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ProviderAuthPlug when action in [:show, :update, :delete]

  def create(conn, %{"provider" => provider_params}) do
    with {:ok, %Provider{} = provider} <- ProviderAccounts.create_provider(provider_params) do
      conn
      |> put_status(:created)
      |> render("show.json", provider: provider)
    end
  end

  def show(conn) do
    provider = current_provider(conn)
    render(conn, "show.json", provider: provider)
  end

  def update(conn, %{"provider" => provider_params}) do
    provider = current_provider(conn)

    with {:ok, %Provider{} = provider} <- ProviderAccounts.update_provider(provider, provider_params) do
      render(conn, "show.json", provider: provider)
    end
  end

  def delete(conn, %{"id" => id}) do
    provider = current_provider(conn)
    if String.to_integer(id) == provider.id do
      with {:ok, %Provider{}} <- ProviderAccounts.delete_provider(provider) do
        send_resp(conn, :no_content, "")
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end
end
