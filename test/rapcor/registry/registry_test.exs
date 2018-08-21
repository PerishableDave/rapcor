defmodule Rapcor.RegistryTest do
  use Rapcor.DataCase

  alias Rapcor.Registry
  alias Rapcor.Fixtures.ProviderFixtures
  alias Rapcor.Fixtures.ExperienceFixtures

  describe "requests" do
    alias Rapcor.Registry.Request

    @valid_attrs %{contact_email: "some@email.com", contact_phone: "some contact_phone", end_date: ~D[2010-04-17], notes: "some notes", request_experiences: [%{experience_id: 1, minimum_years: 3}, %{experience_id: 2, minimum_years: 5}], start_date: ~D[2010-04-17]}
    @update_attrs %{contact_email: "updated@email.com", contact_phone: "some updated contact_phone", notes: "some updated notes"}
    @invalid_attrs %{contact_email: nil, contact_phone: nil, end_date: nil, notes: nil, request_experiences: nil, start_date: nil, status: "test"}

    def request_fixture(attrs \\ %{}) do
      %{experience: %{id: experience_id}} = ExperienceFixtures.experience

      %{provider: provider} = ProviderFixtures.provider
      {:ok, request} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Map.put(:provider_id, provider.id)
        |> Map.put(:request_experiences, [%{experience_id: experience_id, minimum_years: 3}])
        |> Registry.create_request()

      request
    end

    test "list_requests/0 returns all requests" do
      request = request_fixture()
      provider = Rapcor.ProviderAccounts.get_provider!(request.provider_id)

      assert Registry.list_provider_requests(provider) == [request]
    end

    test "get_request!/1 returns the request with given id" do
      request = request_fixture()
      assert Registry.get_request!(request.id) == request
    end

    test "create_request/1 with valid data creates a request" do
      %{experience: %{id: experience_id}} = ExperienceFixtures.experience
      %{provider: provider} = ProviderFixtures.provider

      attrs = @valid_attrs
      |> Map.put(:provider_id, provider.id)
      |> Map.put(:request_experiences, [%{experience_id: experience_id, minimum_years: 3}])

      assert {:ok, %Request{} = request} = Registry.create_request(attrs)
      assert request.contact_email == "some@email.com"
      assert request.contact_phone == "some contact_phone"
      assert request.end_date == ~D[2010-04-17]
      assert request.notes == "some notes"
      assert request.start_date == ~D[2010-04-17]

      assert length(request.request_experiences) == 1
    end

    test "create_request/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Registry.create_request(@invalid_attrs)
    end

    test "update_request/2 with valid data updates the request" do
      request = request_fixture()
      assert {:ok, request} = Registry.update_request(request, @update_attrs)
      assert %Request{} = request
      assert request.contact_email == "updated@email.com"
      assert request.contact_phone == "some updated contact_phone"
      assert request.notes == "some updated notes"
    end

    test "update_request/2 with invalid data returns error changeset" do
      request = request_fixture()
      assert {:error, %Ecto.Changeset{}} = Registry.update_request(request, @invalid_attrs)
      assert request == Registry.get_request!(request.id)
    end

    test "delete_request/1 deletes the request" do
      request = request_fixture()
      assert {:ok, %Request{}} = Registry.delete_request(request)
      assert_raise Ecto.NoResultsError, fn -> Registry.get_request!(request.id) end
    end

    test "change_request/1 returns a request changeset" do
      request = request_fixture()
      assert %Ecto.Changeset{} = Registry.change_request(request)
    end
  end
end
