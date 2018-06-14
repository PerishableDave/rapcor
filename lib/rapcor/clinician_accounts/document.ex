defmodule Rapcor.ClinicianAccounts.Document do
  use Ecto.Schema
  import Ecto.Changeset
  import Rapcor.ClinicianAccounts.Document.RespiratoryTherapist

  alias Ecto.Changeset
  alias Rapcor.ClinicianAccounts.Clinician


  schema "documents" do
    field :back_photo, :string
    field :expiration, :date
    field :front_photo, :string
    field :number, :string
    field :slug, :string
    field :state, :string

    belongs_to :clinician, Clinician

    timestamps()
  end

  
  @doc false
  def changeset(document, attrs) do
    document
    |> cast(attrs, [:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
    |> validate_inclusion(:slug, ["rt-rcp", "rt-crt", "rt-rrt"])
    |> validate_document_update()
  end

  def create_changeset(document, attrs) do
    document
    |> cast(attrs, [:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
    |> validate_inclusion(:slug, ["rt-rcp", "rt-crt", "rt-rrt"])
    |> validate_document_create()

  end

  defp validate_document_create(%Changeset{changes: %{slug: slug}} = changeset) do
    attrs = document_attrs(slug)

    changeset
    |> cast(changeset.changes, attrs)
    |> validate_required(attrs)
  end

  defp validate_document_create(changeset) do
    validate_required(changeset, [:slug])
  end

  defp validate_document_update(%Changeset{changes: %{slug: slug}} = changeset) do
    attrs = document_attrs(slug)

    changeset
    |> cast(changeset.changes, attrs)
  end

  defp validate_document_update(changeset) do
    validate_required(changeset, [:slug])
  end
end
