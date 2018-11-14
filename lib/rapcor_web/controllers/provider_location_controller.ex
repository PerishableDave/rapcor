defmodule RapcorWeb.ProviderLocationController do
  use RapcorWeb, :controller

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Location
  alias Rapcor.Authorization.ProviderAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ProviderAuthPlug

  def index(conn, _params) do
    provider = current_provider(conn)
    locations = ProviderAccounts.list_provider_locations(provider)
    render(conn, "index.json", locations: locations)
  end

  def create(conn, %{"location" => location_params}) do
    provider = current_provider(conn)

    location_params = Map.put(location_params, "provider_id", provider.id)

    with {:ok, %Location{} = location} <- ProviderAccounts.create_location(location_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", location_path(conn, :show, location))
      |> render("show.json", location: location)
    end
  end

  def show(conn, %{"id" => id}) do
    location = ProviderAccounts.get_location!(id)

    case location.provider_id == current_provider(conn).id do
      true ->
        render(conn, "show.json", location: location)
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  def update(conn, %{"id" => id, "location" => location_params}) do
    location = ProviderAccounts.get_location!(id)

    case location.provider_id == current_provider(conn).id do
      true ->
        with {:ok, %Location{} = location} <- ProviderAccounts.update_location(location, location_params) do
          render(conn, "show.json", location: location)
        end
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  def delete(conn, %{"id" => id}) do
    location = ProviderAccounts.get_location!(id)

    case locaiton.provider_id == current_provider(conn).id do
      true ->
        with {:ok, %Location{}} <- ProviderAccounts.delete_location(location) do
          send_resp(conn, :no_content, "")
        end
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end
end
