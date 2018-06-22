defmodule RapcorWeb.ProviderTokenController do
  use RapcorWeb, :controller

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.ProviderToken

  action_fallback RapcorWeb.FallbackController

  def create(conn, %{"contact_email" => email, "password" => password}) do
    with {:ok, %ProviderToken{} = provider_token} <- ProviderAccounts.create_provider_token(email, password) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", provider_token_path(conn, :show, provider_token))
      |> render("show.json", provider_token: provider_token)
    end
  end

  def create(conn, _params) do
    conn
    |> send_resp(:bad_request, "")
  end

  def delete(conn, %{"id" => id}) do
    provider_token = ProviderAccounts.get_provider_token!(id)
    with {:ok, %ProviderToken{}} <- ProviderAccounts.delete_provider_token(provider_token) do
      send_resp(conn, :no_content, "")
    end
  end
end
