defmodule Rapcor.ClinicianAccounts.ClinicianExperience do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.ClinicianAccounts.Experience

  schema "clinicians_experiences" do
    field :years, :integer
    belongs_to :clinician, Clinician
    belongs_to :experience, Experience

    timestamps
  end

  @doc false
  def changeset(clinician_experience, attrs) do
    clinician_experience
    |> cast(attrs, [:clinician_id, :experience_id, :years])
    |> validate_required([:clinician_id, :experience_id, :years])
  end

  def update_changeset(clinician_experience, attrs) do
    clinician_experience
    |> cast(attrs, [:years])
    |> validate_required([:years])
  end
end
