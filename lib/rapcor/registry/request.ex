defmodule Rapcor.Registry.Request do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.Registry.Request.Enums.RequestStatus
  alias Rapcor.Registry.Request.RequestExperience
  
  @status ~w(open filled cancelled)

  schema "requests" do
    field :contact_email, :string
    field :contact_phone, :string
    field :end_date, :utc_datetime
    field :notes, :string
    field :start_date, :utc_datetime
    field :status, RequestStatus, defaults: :open

    belongs_to :provider, Provider
    belongs_to :accepted_clinician, Clinician

    has_many :request_experiences, RequestExperience

    timestamps()
  end

  @doc false
  def create_changeset(request, attrs) do
    request
    |> cast(attrs, [:start_date, :end_date, :contact_email, :contact_phone, :notes, :status, :provider_id])
    |> cast_assoc(:request_experiences)
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.'+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_required([:start_date, :end_date, :provider_id, :status])
    |> validate_inclusion(:status, @status)
  end

  @doc false
  def changeset(request, attrs) do
    request
    |> cast(attrs, [:contact_email, :contact_phone, :notes, :status, :accepted_clinician_id])
    |> validate_format(:contact_email, ~r/^[a-zA-Z0-9_.'+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$/)
    |> validate_inclusion(:status, @status)
  end

end
