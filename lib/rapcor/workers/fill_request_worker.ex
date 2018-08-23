defmodule Rapcor.Workers.FillRequestWorker do
  require Logger

  alias Rapcor.Registry
  alias Rapcor.Registry.Request

  def enqueue(%Request{} = request) do
    Exq.enqueue(Exq, "default", __MODULE__, [request.id])
  end

  def perform(request_id) do
    {:ok, request} = Registry.get_request(request_id)

    case Registry.list_eligible_clinicians(request) do
      [] ->
        Logger.info "Eligible clinician unavailable for request: #{request.id}"
      clinicians ->
        create_bids(clinicians, request)
    end
  end

  def create_bids([], request) do
    Exq.enqueue_in(Exq, "default", 600, __MODULE__, [request.id])
  end

  def create_bids([clinician | rest], request) do
    Registry.create_request_bid(request, clinician)
    create_bids(rest, request)
  end
end
