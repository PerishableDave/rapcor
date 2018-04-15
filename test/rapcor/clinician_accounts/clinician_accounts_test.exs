defmodule Rapcor.ClinicianAccountsTest do
  use Rapcor.DataCase

  alias Rapcor.ClinicianAccounts
  alias Rapcor.Clinician

  describe "clinicians" do
    alias Rapcor.ClinicianAccounts.Clinician

    @valid_attrs %{administrative_area: "some administrative_area", country: "some country", email: "some@email.com", first_name: "some first_name", last_name: "some last_name", locality: "some locality", middle_name: "some middle_name", password: "some password_hash", phone_number: "some phone_number", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
    @update_attrs %{administrative_area: "some updated administrative_area", country: "some updated country", email: "some@email.com", first_name: "some updated first_name", last_name: "some updated last_name", locality: "some updated locality", middle_name: "some updated middle_name", password: "some updated password_hash", phone_number: "some updated phone_number", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}
    @invalid_attrs %{administrative_area: nil, country: nil, email: nil, first_name: nil, last_name: nil, locality: nil, middle_name: nil, password_hash: nil, phone_number: nil, postal_code: nil, premise: nil, sub_administrative_area: nil, thoroughfare: nil}

    def clinician_fixture(attrs \\ %{}) do
      {:ok, clinician} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ClinicianAccounts.create_clinician()

      clinician = Map.put(clinician, :password, nil)
      clinician
    end

    test "list_clinicians/0 returns all clinicians" do
      clinician = clinician_fixture()
      assert ClinicianAccounts.list_clinicians() == [clinician]
    end

    test "get_clinician!/1 returns the clinician with given id" do
      clinician = clinician_fixture()
      assert ClinicianAccounts.get_clinician!(clinician.id) == clinician
    end

    test "create_clinician/1 with valid data creates a clinician" do
      assert {:ok, %Clinician{} = clinician} = ClinicianAccounts.create_clinician(@valid_attrs)
      assert clinician.administrative_area == "some administrative_area"
      assert clinician.country == "some country"
      assert clinician.email == "some@email.com"
      assert clinician.first_name == "some first_name"
      assert clinician.last_name == "some last_name"
      assert clinician.locality == "some locality"
      assert clinician.middle_name == "some middle_name"
      assert Clinician.check_password(clinician, "some_password")
      assert clinician.phone_number == "some phone_number"
      assert clinician.postal_code == "some postal_code"
      assert clinician.premise == "some premise"
      assert clinician.sub_administrative_area == "some sub_administrative_area"
      assert clinician.thoroughfare == "some thoroughfare"
    end

    test "create_clinician/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.create_clinician(@invalid_attrs)
    end

    test "update_clinician/2 with valid data updates the clinician" do
      clinician = clinician_fixture()
      assert {:ok, clinician} = ClinicianAccounts.update_clinician(clinician, @update_attrs)
      assert %Clinician{} = clinician
      assert clinician.administrative_area == "some updated administrative_area"
      assert clinician.country == "some updated country"
      assert clinician.email == "some@email.com"
      assert clinician.first_name == "some updated first_name"
      assert clinician.last_name == "some updated last_name"
      assert clinician.locality == "some updated locality"
      assert clinician.middle_name == "some updated middle_name"
      assert Clinician.check_password(clinician, "some password")
      assert clinician.phone_number == "some updated phone_number"
      assert clinician.postal_code == "some updated postal_code"
      assert clinician.premise == "some updated premise"
      assert clinician.sub_administrative_area == "some updated sub_administrative_area"
      assert clinician.thoroughfare == "some updated thoroughfare"
    end

    test "update_clinician/2 with invalid data returns error changeset" do
      clinician = clinician_fixture()
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.update_clinician(clinician, @invalid_attrs)
      assert clinician == ClinicianAccounts.get_clinician!(clinician.id)
    end

    test "delete_clinician/1 deletes the clinician" do
      clinician = clinician_fixture()
      assert {:ok, %Clinician{}} = ClinicianAccounts.delete_clinician(clinician)
      assert_raise Ecto.NoResultsError, fn -> ClinicianAccounts.get_clinician!(clinician.id) end
    end

    test "change_clinician/1 returns a clinician changeset" do
      clinician = clinician_fixture()
      assert %Ecto.Changeset{} = ClinicianAccounts.change_clinician(clinician)
    end
  end
end
