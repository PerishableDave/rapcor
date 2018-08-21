defmodule Rapcor.Registry.Request do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.Registry.Request.Enums.RequestStatus
  alias Rapcor.Registry.Request.RequestExperience
  
  @status ~w(open filled cancelled)

  schema "requests" do
    field :contact_email, :string
    field :contact_phone, :string
    field :end_date, :date
    field :notes, :string
    field :start_date, :date
    field :status, RequestStatus, defaults: :pending

    belongs_to :provider, Provider

    has_many :request_experiences, RequestExperience

    timestamps()
  end

  @doc false
  def create_changeset(request, attrs) do
    request
    |> cast(attrs, [:start_date, :end_date, :contact_email, :contact_phone, :notes, :status, :provider_id])
    |> cast_assoc(:request_experiences)
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_required([:start_date, :end_date, :provider_id, :status])
    |> validate_inclusion(:status, @status)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:contact_email, :contact_phone, :notes, :status])
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_inclusion(:status, @status)
  end

end
