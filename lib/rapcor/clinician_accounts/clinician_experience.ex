defmodule Rapcor.ClinicianAccounts.ClinicianExperience do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ClinicianAccounts.Clinician
  alias Rapcor.ClinicianAccounts.Experience

  schema "clinicians_experiences" do
    belongs_to :clinician, Clinician
    belongs_to :experience, Experience
    timestamps
  end

  @doc false
  def changeset(clinician_experience, attrs) do
    clinician_experience
    |> cast(attrs, [:clinician_id, :experience_id])
    |> validate_required([:clinician_id, :experience_id])
  end
end
