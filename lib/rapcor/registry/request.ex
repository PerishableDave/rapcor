defmodule Rapcor.Registry.Request do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.Registry.Request.Enums.RequestStatus
  alias Rapcor.Registry.Request.RequiredExperience
  
  @status ~w(open filled cancelled)

  schema "requests" do
    field :contact_email, :string
    field :contact_phone, :string
    field :end_date, :date
    field :notes, :string
    field :start_date, :date
    field :status, RequestStatus, defaults: :pending

    embeds_many :required_experiences, RequiredExperience

    belongs_to :provider, Provider

    timestamps()
  end

  @doc false
  def create_changeset(request, attrs) do
    request
    |> cast(attrs, [:start_date, :end_date, :contact_email, :contact_phone, :notes, :status, :provider_id])
    |> cast_embed(:required_experiences)
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
