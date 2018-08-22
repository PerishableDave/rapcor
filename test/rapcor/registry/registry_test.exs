defmodule Rapcor.RegistryTest do
  use Rapcor.DataCase

  alias Rapcor.Registry
  alias Rapcor.ClinicianAccounts
  alias Rapcor.Fixtures.ProviderFixtures
  alias Rapcor.Fixtures.ClinicianFixtures
  alias Rapcor.Fixtures.ExperienceFixtures
  alias Rapcor.Fixtures.RequestFixtures

  describe "requests" do
    alias Rapcor.Registry.Request

    @valid_attrs %{contact_email: "some@email.com", contact_phone: "some contact_phone", end_date: "2015-01-23T23:50:07.000000Z", notes: "some notes", request_experiences: [%{experience_id: 1, minimum_years: 3}, %{experience_id: 2, minimum_years: 5}], start_date: "2015-01-23T23:50:07.000000Z"}
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

      {:ok, date, _} = DateTime.from_iso8601("2015-01-23T23:50:07.000000Z")
      assert {:ok, %Request{} = request} = Registry.create_request(attrs)
      assert request.contact_email == "some@email.com"
      assert request.contact_phone == "some contact_phone"
      assert request.end_date == date
      assert request.notes == "some notes"
      assert request.start_date == date

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

  describe "request_bids" do
    test "create_request_bid/2 with valid data creates a request bid" do
      %{request: request} = RequestFixtures.request()
      %{clinician: clinician} = ClinicianFixtures.clinician()

      assert {:ok, request_bid} = Registry.create_request_bid(request, clinician)
      assert request_bid.request_id == request.id
      assert request_bid.clinician_id == clinician.id
    end

    test "list_eligible_clinicians/2 with eligible clinicians returns the clinicians" do
      _ = ClinicianFixtures.clinician() # Ineligible clinician
      %{clinician: eligible_clinician} = ClinicianFixtures.clinician()

      {:ok, experience_one} = ClinicianAccounts.create_experience(%{description: "one"})
      {:ok, experience_two} = ClinicianAccounts.create_experience(%{description: "two"})

      clinician_experience_attrs = [
        %{clinician_id: eligible_clinician.id, experience_id: experience_one.id, years: 3},
        %{clinician_id: eligible_clinician.id, experience_id: experience_two.id, years: 3}
      ]

      :ok = ClinicianAccounts.create_or_update_clinician_experiences(clinician_experience_attrs)

      %{request: request} = RequestFixtures.request(%{request_experiences: [
        %{experience_id: experience_one.id, minimum_years: 3},
        %{experience_id: experience_two.id, minimum_years: 3}
      ]})

      clinicians = Registry.list_eligible_clinicians(request)

      assert length(clinicians) == 1
    end

    test "accept_request_bid/1 with open request returns an updated and fulfilled request" do
      %{request: request} = RequestFixtures.request()
      %{clinician: clinician} = ClinicianFixtures.clinician()

      {:ok, request_bid} = Registry.create_request_bid(request, clinician)

      assert {:ok, request} = Registry.accept_request_bid(request_bid)
      assert request.status == :fulfilled
      assert request.accepted_clinician_id == clinician.id
    end

    test "accept_request_bid/1 with a fulfilled request returns an error" do
      %{request: request} = RequestFixtures.request()
      %{clinician: accepted_clinician} = ClinicianFixtures.clinician()
      %{clinician: rejected_clinician} = ClinicianFixtures.clinician()

      {:ok, accepted_request_bid} = Registry.create_request_bid(request, accepted_clinician)
      {:ok, rejected_request_bid} = Registry.create_request_bid(request, rejected_clinician)

      {:ok, _} = Registry.accept_request_bid(accepted_request_bid)
      assert {:error, _} = Registry.accept_request_bid(rejected_request_bid)

    end
  end
end
