defmodule Rapcor.ClinicianAccounts.ClinicianToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ClinicianAccounts.Clinician

  @attrs [
    :clinician_id,
    :source
  ]

  @required_attrs [
    :clinician_id
  ]

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "clinician_tokens" do
    field :source, :string

    belongs_to :clinician, Clincian

    timestamps()
  end

  @doc false
  def changeset(auth_token, attrs) do
    auth_token
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
