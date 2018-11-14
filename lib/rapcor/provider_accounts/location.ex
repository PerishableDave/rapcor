defmodule Rapcor.ProviderAccounts.Location do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ProviderAccounts.Provider

  schema "locations" do
    field :name, :string
    field :country, :string
    field :locality, :string
    field :postal_code, :string
    field :premise, :string
    field :sub_administrative_area, :string
    field :thoroughfare, :string
    field :administrative_area, :string

    belongs_to :provider, Provider

    timestamps()
  end

  @doc false
  def changeset(location, attrs) do
    location
    |> cast(attrs, [:name, :country, :locality, :postal_code, :premise, :sub_administrative_area, :administrative_area, :thoroughfare, :provider_id])
    |> validate_required([:name, :country, :locality, :postal_code, :premise, :administrative_area, :thoroughfare, :provider_id])
  end
end
