defmodule Rapcor.Workers.NotifyRequestBid do
  require Logger

  alias ExTwilio.Message
  alias Rapcor.Registry
  alias Rapcor.Registry.RequestBid
  alias RapcorWeb.Endpoint

  @from_number Application.get_env(:orange, :twilio_from_number)

  def enqueue(%RequestBid{} = request_bid) do
    Exq.enqueue(Exq, "default", __MODULE__, [request_bid.id])
  end

  def perform(request_bid_id) do
    request_bid = Registry.get_request_bid!(request_bid_id)

    url = Endpoint.url <> "/r/" <> request_bid.url
    phone_number = request_bid.clincian.phone_number
    message = "Test message: #{url}"

    case Message.create(from: @from_number, to: phone_number, body: message) do
      {:ok, %Message{error_code: nil, sid: sid}} ->
        Logger.debug "TWILIO: Successful message: #{sid}"
      {:error, %Message{error_message: error_message}} ->
        Logger.warn "TWILIO: Error sending message: " <> error_message
    end
  end
end
