defmodule Rapcor.Registry.Request.RequestExperience do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.Registry.Request
  alias Rapcor.ClinicianAccounts.Experience

  schema "request_experiences" do
    field :minimum_years, :integer

    belongs_to :request, Request
    belongs_to :experience, Experience
  end

  def changeset(required_experience, attrs) do
    required_experience
    |> cast(attrs, [:experience_id, :minimum_years])
    |> validate_required([:experience_id, :minimum_years])
    |> validate_number(:minimum_years, greater_than: 0)
    |> validate_number(:experience_id, greater_than: 0)
    |> validate_number(:request_id, greater_than: 0)
  end
end
