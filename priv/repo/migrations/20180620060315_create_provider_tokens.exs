defmodule Rapcor.Repo.Migrations.CreateProviderTokens do
  use Ecto.Migration

  def change do
    create table(:provider_tokens, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :source, :string
      add :provider_id, references(:providers, on_delete: :nothing)

      timestamps()
    end

    create index(:provider_tokens, [:provider_id])
  end
end
