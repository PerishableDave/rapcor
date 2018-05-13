defmodule Rapcor.Repo.Migrations.CreateExperiences do
  use Ecto.Migration

  def change do
    create table(:experiences) do
      add :description, :string

      timestamps()
    end

    create table(:clinicians_experiences) do
      add :clinician_id, references(:clinicians)
      add :experience_id, references(:experiences)
      add :years, :integer

      timestamps()
    end
  end
end
