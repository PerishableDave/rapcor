defmodule Rapcor.Fixtures.RequestFixtures do
  alias Rapcor.Registry
  alias Rapcor.Fixtures.ProviderFixtures
  alias Faker.Internet
  alias Faker.Phone.EnUs, as: Phone
  alias Faker.Lorem

  def request(attrs \\ %{}) do
    %{provider: provider} = ProviderFixtures.provider

    date = DateTime.utc_now
    |> DateTime.to_iso8601

    attrs = attrs
    |> Map.put_new(:contact_email, Internet.safe_email)
    |> Map.put_new(:contact_phone, Phone.phone)
    |> Map.put_new(:start_date, date)
    |> Map.put_new(:end_date, date)
    |> Map.put_new(:notes, Lorem.sentence)
    |> Map.put_new(:provider_id, provider.id)

    {:ok, request} = Registry.create_request(attrs)

    %{request: request, provider: provider}
  end
end
