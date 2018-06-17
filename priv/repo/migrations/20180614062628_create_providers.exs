defmodule Rapcor.Repo.Migrations.CreateProviders do
  use Ecto.Migration

  def change do
    create table(:providers) do
      add :name, :string, null: false
      add :contact_email, :string, null: false
      add :contact_number, :string, null: false
      add :country, :string, null: false
      add :administrative_area, :string, null: false
      add :locality, :string, null: false
      add :postal_code, :string, null: false
      add :premise, :string
      add :sub_administrative_area, :string
      add :thoroughfare, :string, null: false
      add :password_hash, :string, null: false

      timestamps()
    end

    create index(:providers, [:contact_email], unique: true)
  end
end
