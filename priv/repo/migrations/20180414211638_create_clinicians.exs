defmodule Rapcor.Repo.Migrations.CreateClinicians do
  use Ecto.Migration

  def change do
    create table(:clinicians) do
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :middle_name, :string
      add :email, :string, null: false, unique: true
      add :phone_number, :string
      add :country, :string
      add :administrative_area, :string
      add :locality, :string
      add :postal_code, :string
      add :premise, :string
      add :sub_administrative_area, :string
      add :thoroughfare, :string
      add :password_hash, :string, null: false

      timestamps()
    end

    create index(:clinicians, [:email], unique: true)
  end
end
