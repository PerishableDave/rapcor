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
    |> cast(attrs, [:request_id, :provider_id, :slug])
    |> validate_required([:clinician_id, :request_id])
  end
end
