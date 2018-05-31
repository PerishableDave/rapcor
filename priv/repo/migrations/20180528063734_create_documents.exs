defmodule Rapcor.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents) do
      add :slug, :string, null: false
      add :number, :string
      add :expiration, :date
      add :state, :string
      add :front_photo, :string
      add :back_photo, :string
      add :clinician_id, references(:clinicians), null: false

      timestamps()
    end

  end
end
