defmodule Rapcor.Fixtures.ClinicianFixtures do
  alias Rapcor.Clinician
  alias Rapcor.ClinicianAccounts
  alias Faker.Name
  alias Faker.Internet
  alias Faker.Phone.EnUs, as: Phone
  alias Faker.Address

  import Map, only: [put: 3]

  def password() do
    "testing123"
  end

  def clinician() do
    attrs = %{}
    |> put(:first_name, Name.first_name)
    |> put(:last_name, Name.last_name)
    |> put(:middle_name, Name.last_name)
    |> put(:email, Internet.email)
    |> put(:phone_number, Phone.phone)
    |> put(:administrative_area, Address.state)
    |> put(:locality, Address.city)
    |> put(:postal_code, Address.postcode)
    |> put(:premise, Address.secondary_address)
    |> put(:thoroughfare, Address.street_address)
    |> put(:password, password)
    |> put(:country, Address.country_code)

    {:ok, clinician} = ClinicianAccounts.create_clinician(attrs)
    {:ok, token} = ClinicianAccounts.create_clinician_token(clinician.email, password)

    %{clinician: clinician, clinician_token: token}
  end
end
