defmodule Rapcor.Fixtures.ExperienceFixtures do
  alias Rapcor.ClinicianAccounts

  alias Faker.Lorem

  def experience do
    attrs = %{}
    |> Map.put(:description, Lorem.sentence)

    {:ok, experience} = ClinicianAccounts.create_experience(attrs)

    %{experience: experience}
  end
end
