defmodule Rapcor.Repo.Migrations.CreateClinicians do
  use Ecto.Migration

  def change do
    create table(:clinicians) do
      add :first_name, :string
      add :last_name, :string
      add :middle_name, :string
      add :email, :string
      add :phone_number, :string
      add :country, :string
      add :administrative_area, :string
      add :locality, :string
      add :postal_code, :string
      add :premise, :string
      add :sub_administrative_area, :string
      add :thoroughfare, :string
      add :password_hash, :string

      timestamps()
    end

  end
end
