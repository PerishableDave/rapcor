defmodule Rapcor.Registry.Request.RequiredExperience do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :experience_id, :integer
    field :minimum_years, :integer
  end

  def changeset(required_experience, attrs) do
    required_experience
    |> cast(attrs, [:experience_id, :minimum_years])
    |> validate_required([:experience_id, :minimum_years])
    |> validate_number(:minimum_years, greater_than: 0)
    |> validate_number(:experience_id, greater_than: 0)
  end
end
