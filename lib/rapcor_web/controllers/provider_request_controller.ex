defmodule RapcorWeb.ProviderRequestController do
  use RapcorWeb, :controller

  alias Rapcor.Registry
  alias Rapcor.Registry.Request
  alias Rapcor.Authorization.ProviderAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ProviderAuthPlug

  def index(conn, _params) do
    provider = current_provider(conn)
    requests = Registry.list_provider_requests(provider)
    render(conn, "index.json", requests: requests)
  end

  def create(conn, %{"request" => request_params}) do
    provider = current_provider(conn)

    request_params = Map.put(request_params, "provider_id", provider.id)

    with {:ok, %Request{} = request} <- Registry.create_request(request_params) do
      conn
      |> put_status(:created)
      |> render("show.json", request: request)
    end
  end

  def show(conn, %{"id" => id}) do
    request = Registry.get_request!(id)

    case request.provider_id == current_provider(conn).id do
      true ->
        render(conn, "show.json", request: request)
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end

  def update(conn, %{"id" => id, "request" => request_params}) do
    request = Registry.get_request!(id)

    case request.provider_id == current_provider(conn).id do
      true ->
        with {:ok, %Request{} = request} <- Registry.update_request(request, request_params) do
          render(conn, "show.json", request: request)
        end
      false ->
        send_resp(conn, :unauthorized, "")
    end
  end
end
