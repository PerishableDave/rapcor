defmodule RapcorWeb.ClinicianRequestBidController do
  use RapcorWeb, :controller

  alias Rapcor.Registry
  alias Rapcor.Authorization.ClinicianAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ClinicianAuthPlug when action in [:index, :show]

  def index(conn, _params) do
    clinician = current_clinician(conn)
    request_bids = Registry.list_request_bids(clinician)
    render(conn, "index.json", clinician_request_bids: request_bids)
  end

  def show_slug(conn, %{"slug" => slug}) do
    case Registry.get_request_bid_by_slug(slug) do
      nil -> 
        send_resp(conn, :not_found, "")
      request_bid ->
        render(conn, "show.json", clinician_request_bid: request_bid)
    end
  end

  def show(conn, %{"id" => id}) do
    clinician = current_clinician(conn)

    if String.to_integer(id) == clinician.id do
      case Registry.get_request_bid!(id) do
        nil -> 
          send_resp(conn, :not_found, "")
        request_bid ->
          render(conn, "show.json", clinician_request_bid: request_bid)
      end
    else
      send_resp(conn, :unauthorized, "")
    end
  end

  def accept(conn, %{"slug" => slug}) do
    request_bid = Registry.get_request_bid_by_slug(slug)

    case Registry.accept_request_bid(request_bid) do
      {:ok, request_bid} ->
        render(conn, "show.json", clinician_request_bid: request_bid)
      {:error, _message, request_bid} ->
        conn
        |> put_status(:conflict)
        |> render(conn, "show.json", clinician_request_bid: request_bid)
    end
  end
end
