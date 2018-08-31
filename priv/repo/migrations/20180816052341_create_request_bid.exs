defmodule Rapcor.Repo.Migrations.CreateRequestBid do
  use Ecto.Migration

  def change do
    create table(:request_bids) do
      add :clinician_id, references(:clinicians, on_delete: :delete_all), null: false
      add :request_id, references(:requests, on_delete: :delete_all), null: false
      add :slug, :string

      timestamps()
    end

    create index(:request_bids, [:clinician_id, :request_id], unique: true)
    create index(:request_bids, [:slug], unique: true)

    create table(:request_experiences) do
      add :experience_id, references(:experiences), null: false
      add :request_id, references(:requests, on_delete: :delete_all), null: false
      add :minimum_years, :integer, null: false
    end

    create index(:request_experiences, [:request_id])

    alter table(:requests) do
      remove :required_experiences

      modify :start_date, :utc_datetime
      modify :end_date, :utc_datetime

      add :accepted_clinician_id, references(:clinicians)
    end
  end
end
