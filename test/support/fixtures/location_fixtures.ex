defmodule Rapcor.Fixtures.LocationFixtures do
  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider

  alias Faker.Company
  alias Faker.Address
  alias Faker.Util
  alias Faker.Internet

  def location(%Provider{} = provider) do
    attrs = %{}
            |> put(:name, Company.name)
            |> put(:country, Address.country_code)
            |> put(:locality, Address.city)
            |> put(:postal_code, Address.postcode)
            |> put(:premise, Address.secondary_address)
            |> put(:administrative_area, Address.state)
            |> put(:thoroughfare, Address.street)
            |> put(:provider_id, provider.id)

    {:ok, location} = ProivderAccounts.create_location(attrs)

    %{location: location}
  end
