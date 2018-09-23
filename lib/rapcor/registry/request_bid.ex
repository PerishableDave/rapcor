defmodule Rapcor.Registry.RequestBid do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.Registry.Request
  alias Rapcor.ClinicianAccounts.Clinician

  schema "request_bids" do
    field :slug, :string

    belongs_to :request, Request
    belongs_to :clinician, Clinician

    timestamps()
  end

  @doc false
  def create_changeset(request_bid, attrs) do
    request_bid
    |> cast(attrs, [:request_id, :clinician_id, :slug])
    |> validate_required([:clinician_id, :request_id])
    |> put_change(:slug, create_slug())
  end

  def create_slug do
    UUID.uuid4(:hex)
    |> Base.decode16!(case: :lower)
    |> Base.url_encode64(padding: false)
  end

  def request_bid_status(%{request: %{accepted_clinician_id: nil, status: status}}), do: status

  def request_bid_status(%{clinician_id: clinician_id, request: %{accepted_clinician_id: clinician_id, status: status}}), do: status

  def request_bid_status(_), do: :closed
end
