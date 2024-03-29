defmodule Rapcor.Workers.FillRequestWorker do
  require Logger

  alias Rapcor.Workers.Queue
  alias Rapcor.Registry
  alias Rapcor.Registry.Request

  def enqueue(%Request{} = request) do
    Queue.enqueue(__MODULE__, [request.id])
  end

  def perform(request_id) do
    request = Registry.get_request!(request_id)

    case request.status do
      :open ->
        case Registry.list_eligible_clinicians(request) do
          [] ->
            Logger.info "Eligible clinician unavailable for request: #{request.id}"
          clinicians ->
            create_bids(clinicians, request)
        end
    end
  end

  def create_bids([], request) do
    Queue.enqueue_in(__MODULE__, 600, [request.id])
  end

  def create_bids([clinician | rest], request) do
    Registry.create_request_bid(request, clinician)
    create_bids(rest, request)
  end
end
