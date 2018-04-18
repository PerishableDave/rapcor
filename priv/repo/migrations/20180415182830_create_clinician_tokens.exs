defmodule Rapcor.Repo.Migrations.CreateClinicianTokens do
  use Ecto.Migration

  def change do
    create table(:clinician_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :clinician_id, references(:clinicians, on_delete: :delete_all)
      add :source, :string

      timestamps()
    end
  end
end
