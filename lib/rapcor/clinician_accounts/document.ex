defmodule Rapcor.ClinicianAccounts.Document do
  use Ecto.Schema
  import Ecto.Changeset

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
    |> validate_required([:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
  end

  def create_changeset(document, attrs) do
    document
    |> cast(attrs, [:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
    |> validate_inclusion(:slug, ["rt-rcp", "rt-crt", "rt-rrt"])
    |> validate_document()

  end

  def validate_document(%Changeset{changes: %{slug: "rt-rcp"}} = changeset) do
    changeset
    |> cast(changeset.changes, [:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
    |> validate_required([:slug, :number, :expiration, :state, :front_photo, :back_photo, :clinician_id])
  end

  def validate_document(%Changeset{changes: %{slug: "rt-crt"}} = changeset) do
    changeset
    |> cast(changeset.changes, [:slug, :number, :expiration, :front_photo, :back_photo, :clinician_id])
    |> validate_required([:slug, :number, :expiration, :front_photo, :clinician_id])
  end

  def validate_document(%Changeset{changes: %{slug: "rt-rrt"}} = changeset) do
    changeset
    |> cast(changeset.changes, [:slug, :number, :expiration, :front_photo, :back_photo, :clinician_id])
    |> validate_required([:slug, :number, :expiration, :front_photo, :clinician_id])
  end

  def validate_document(changeset) do
    validate_required(changeset, [:slug])
  end
end
