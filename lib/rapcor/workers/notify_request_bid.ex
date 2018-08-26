defmodule Rapcor.Workers.NotifyRequestBid do
  require Logger

  alias ExTwilio.Message
  alias Rapcor.Registry
  alias Rapcor.Registry.RequestBid
  alias RapcorWeb.Endpoint

  @from_number Application.get_env(:rapcor, :twilio_from_number)

  def enqueue(%RequestBid{} = request_bid) do
    Exq.enqueue(Exq, "default", __MODULE__, [request_bid.id])
  end

  def perform(request_bid_id) do
    request_bid = Registry.get_request_bid!(request_bid_id)

    url = Endpoint.url <> "/r/" <> request_bid.slug
    phone_number = request_bid.clinician.phone_number
    {:ok, start_time} = Timex.format(request_bid.request.start_date, "{WDshort}, {M}/{D} {h12}:{m} {AM}")
    message = "RT Request: #{start_time} #{url}"

    IO.inspect @from_number

    case Message.create(from: @from_number, to: phone_number, body: message) do
      {:ok, %Message{error_code: nil, sid: sid}} ->
        Logger.debug "TWILIO: Successful message: #{sid}"
    end
  end
end
