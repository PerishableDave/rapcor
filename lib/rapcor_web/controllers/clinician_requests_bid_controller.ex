defmodule RapcorWeb.ClinicianRequestBidController do
  use RapcorWeb, :controller

  alias Rapcor.Registry
  alias Rapcor.Authorization.ClinicianAuthPlug

  action_fallback RapcorWeb.FallbackController

  plug ClinicianAuthPlug when action in [:index]

  def index(conn, _params) do
    clinician = current_clinician(conn)
    request_bids = Registry.list_request_bids(clinician)
    render(conn, "index.json", clinician_request_bids: request_bids)
  end

  def show(conn, %{"slug" => slug}) do
    case Registry.get_request_bid_by_slug(slug) do
      nil -> 
        send_resp(conn, :not_found, "")
      request_bid ->
        render(conn, "show.json", clinician_request_bid: request_bid)
    end
  end

  def accept(conn, %{"slug" => slug}) do
    case Registry.get_request_bid_by_slug(slug) do
      nil ->
        send_resp(conn, :not_found, "")
      request_bid ->
        case Registry.accept_request_bid(request_bid) do
          {:ok, request} ->
            render(conn, "accept.json", request: request)
          {:error, message} ->
            send_resp(conn, :gone, message)
        end
    end
  end
end
