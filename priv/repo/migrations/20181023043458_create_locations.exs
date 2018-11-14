defmodule Rapcor.Repo.Migrations.CreateLocations do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string, null: false
      add :country, :string, null: false
      add :administrative_area, :string, null: false
      add :locality, :string, null: false
      add :postal_code, :string, null: false
      add :premise, :string
      add :sub_administrative_area, :string
      add :thoroughfare, :string, null: false
      add :provider_id, references(:providers), null: false

      timestamps()
    end

    create index(:locations, [:provider_id])
  end
end
