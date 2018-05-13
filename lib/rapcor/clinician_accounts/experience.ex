defmodule Rapcor.ClinicianAccounts.Experience do
  use Ecto.Schema
  import Ecto.Changeset


  schema "experiences" do
    field :description, :string

    timestamps()
  end

  @doc false
  def changeset(experience, attrs) do
    experience
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
