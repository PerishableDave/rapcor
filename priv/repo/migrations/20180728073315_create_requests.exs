defmodule Rapcor.Repo.Migrations.CreateRequests do
  use Ecto.Migration

  def change do
    create table(:requests) do
      add :start_date, :date
      add :end_date, :date
      add :contact_email, :string
      add :contact_phone, :string
      add :notes, :string
      add :status, :integer
      add :provider_id, references(:providers, on_delete: :delete_all)
      add :required_experiences, :jsonb, default: "[]"

      timestamps()
    end

    create index(:requests, [:provider_id])
  end
end
