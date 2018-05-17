defmodule Rapcor.Repo.Migrations.CreateExperiences do
  use Ecto.Migration

  def change do
    create table(:experiences) do
      add :description, :string, null: false

      timestamps()
    end

    create table(:clinicians_experiences) do
      add :clinician_id, references(:clinicians), null: false
      add :experience_id, references(:experiences), null: false
      add :years, :integer, null: false

      timestamps()
    end

    create index("clinicians_experiences", [:clinician_id, :experience_id], unique: true)
  end
end
