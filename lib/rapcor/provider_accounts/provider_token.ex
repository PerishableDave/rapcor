defmodule Rapcor.ProviderAccounts.ProviderToken do
  use Ecto.Schema
  import Ecto.Changeset

  alias Rapcor.ProviderAccounts.Provider

  schema "provider_tokens" do
    field :source, :string

    belongs_to :provider, :Provider

    timestamps()
  end

  @doc false
  def changeset(provider_token, attrs) do
    provider_token
    |> cast(attrs, [:provider_id, :source])
    |> validate_required([:provider_id])
  end
end
