defmodule RapcorWeb.ClinicianRequestBidView do
  use RapcorWeb, :view

  import Ecto, only: [assoc_loaded?: 1]

  alias RapcorWeb.ClinicianRequestBidView
  alias Rapcor.Registry.RequestBid

  def render("index.json", %{clinician_request_bids: request_bids}) do
    %{request_bids: render_many(request_bids, ClinicianRequestBidView, "request_bid.json", as: :request_bid)}
  end

  def render("show.json", %{clinician_request_bid: request_bid}) do
    %{request_bid: render_one(request_bid, ClinicianRequestBidView, "request_bid.json", as: :request_bid)}
  end

  def render("accept.json", %{request: request}) do
    %{request: render_one(request, ClinicianRequestBidView, "request.json", as: :request)}
  end

  def render("request_bid.json", %{request_bid: %RequestBid{} = request_bid}) do
    %{
      id: request_bid.id,
      slug: request_bid.slug,
      request: render_one(request_bid.request, ClinicianRequestBidView, "request.json", as: :request)
    }
  end

  def render("request.json", %{request: request}) do
    data =%{
      contact_email: request.contact_email,
      contact_phone: request.contact_phone,
      start_date: request.start_date,
      end_date: request.end_date,
      notes: request.notes,
      status: request.status,
    }

    case assoc_loaded?(request.provider) do
      true ->
        Map.put(data, :provider, render_one(request.provider, ClinicianRequestBidView, "provider.json", as: :provider))
      false ->
        data
    end
  end

  def render("provider.json", %{provider: provider}) do
    %{
      administrative_area: provider.administrative_area,
      country: provider.country,
      locality: provider.locality,
      name: provider.name,
      postal_code: provider.postal_code,
      premise: provider.premise,
      sub_administrative_area: provider.sub_administrative_area,
      thoroughfare: provider.thoroughfare
    }
  end
end
