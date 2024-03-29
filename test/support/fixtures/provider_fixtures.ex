defmodule Rapcor.Fixtures.ProviderFixtures do
  alias Rapcor.ProviderAccounts
  alias Faker.Name
  alias Faker.Address
  alias Faker.Util
  alias Faker.Internet

  import Map, only: [put: 3]

  def password() do
    "testing123"
  end

  def provider() do
    attrs = %{}
    |> put(:administrative_area, Address.state)
    |> put(:contact_email, Internet.safe_email)
    |> put(:contact_number, "+1" <> Util.format("%7d"))
    |> put(:country, Address.country_code)
    |> put(:locality, Address.city)
    |> put(:postal_code, Address.postcode)
    |> put(:premise, Address.secondary_address)
    |> put(:thoroughfare, Address.street_address)
    |> put(:password, password())
    |> put(:password_confirmation, password())
    |> put(:name, Name.name)

    {:ok, provider} = ProviderAccounts.create_provider(attrs)
    {:ok, token} = ProviderAccounts.create_provider_token(provider.contact_email, password())

    %{provider: provider, provider_token: token}
  end
end
