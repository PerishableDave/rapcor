defmodule Rapcor.ClinicianAccountsTest do
  use Rapcor.DataCase

  alias Rapcor.ClinicianAccounts
  alias Rapcor.Clinician
  alias Rapcor.ClinicianAccounts.ClinicianToken

  @clinician_valid_attrs %{administrative_area: "some administrative_area", country: "some country", email: "some@email.com", first_name: "some first_name", last_name: "some last_name", locality: "some locality", middle_name: "some middle_name", password: "some password", phone_number: "+11231234", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
  @experience_valid_attrs %{description: "some description"}
  @valid_attrs %{back_photo: "some back_photo", expiration: ~D[2010-04-17], front_photo: "some front_photo", name: "some name", number: "some number", slug: "rt-rcp", state: "some state"}

 
  def clinician_fixture(attrs \\ %{}) do
    {:ok, clinician} =
      attrs
      |> Enum.into(@clinician_valid_attrs)
      |> ClinicianAccounts.create_clinician()

    clinician = Map.put(clinician, :password, nil)
    clinician
  end

  def clinician_token_fixture() do
    clinician = clinician_fixture()

    {:ok, clinician_token} = ClinicianAccounts.create_clinician_token(clinician.email, "some password")

    %{clinician_token: clinician_token, clinician: clinician}
  end

  def experience_fixture(attrs \\ %{}) do
    {:ok, experience} =
      attrs
      |> Enum.into(@experience_valid_attrs)
      |> ClinicianAccounts.create_experience()

    experience
  end

  def document_fixture(attrs \\ %{}) do
    clinician = clinician_fixture()

    {:ok, document} =
      attrs
      |> Enum.into(@valid_attrs)
      |> Map.put(:clinician_id, clinician.id)
      |> ClinicianAccounts.create_document()

    document
  end

  describe "clinicians" do
    alias Rapcor.ClinicianAccounts.Clinician

    @valid_attrs %{administrative_area: "some administrative_area", country: "some country", email: "some@email.com", first_name: "some first_name", last_name: "some last_name", locality: "some locality", middle_name: "some middle_name", password: "some password_hash", phone_number: "+11231234", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
    @update_attrs %{administrative_area: "some updated administrative_area", country: "some updated country", email: "some@email.com", first_name: "some updated first_name", last_name: "some updated last_name", locality: "some updated locality", middle_name: "some updated middle_name", password: "some updated password_hash", phone_number: "+12342345", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}
    @invalid_attrs %{administrative_area: nil, country: nil, email: nil, first_name: nil, last_name: nil, locality: nil, middle_name: nil, password_hash: nil, phone_number: nil, postal_code: nil, premise: nil, sub_administrative_area: nil, thoroughfare: nil}


    test "list_clinicians/0 returns all clinicians" do
      clinician = clinician_fixture()
      assert ClinicianAccounts.list_clinicians() == [clinician]
    end

    test "get_clinician!/1 returns the clinician with given id" do
      clinician = clinician_fixture()
      assert ClinicianAccounts.get_clinician!(clinician.id) == clinician
    end

    test "get_clinician_by_token/1 returns the clinician with the given token" do
      %{clinician_token: %ClinicianToken{id: token}, clinician: clinician} = clinician_token_fixture()

      assert ClinicianAccounts.get_clinician_by_token(token) == clinician
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
      assert clinician.phone_number == "+11231234"
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
      assert clinician.phone_number == "+12342345"
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

  describe "clinician_tokens" do

    
    test "get_clinician_token!/1 returns the clinician_token with given id" do
      %{clinician_token: clinician_token} = clinician_token_fixture()
      assert ClinicianAccounts.get_clinician_token!(clinician_token.id) == clinician_token
    end

    test "create_clinician_token/1 with valid data creates a clinician_token" do
      clinician = clinician_fixture()
      assert {:ok, %ClinicianToken{} = clinician_token} = ClinicianAccounts.create_clinician_token("some@email.com", "some password", source: "some source")
      assert String.length(clinician_token.id) == 36
      assert clinician_token.clinician_id == clinician.id
      assert clinician_token.source == "some source"
    end

    test "create_clinician_token/1 with invalid data returns error changeset" do
      assert {:error, :unauthorized} = ClinicianAccounts.create_clinician_token("some@email.com", "other password")
    end

    test "delete_clinician_token/1 deletes the clinician_token" do
      %{clinician_token: clinician_token} = clinician_token_fixture()
      assert {:ok, %ClinicianToken{}} = ClinicianAccounts.delete_clinician_token(clinician_token)
      assert_raise Ecto.NoResultsError, fn -> ClinicianAccounts.get_clinician_token!(clinician_token.id) end
    end
  end

  describe "experiences" do
    alias Rapcor.ClinicianAccounts.Experience

    @valid_attrs %{description: "some description"}
    @update_attrs %{description: "some updated description"}
    @invalid_attrs %{description: nil}

    test "list_experiences/0 returns all experiences" do
      experience = experience_fixture()
      assert ClinicianAccounts.list_experiences() == [experience]
    end

    test "get_experience!/1 returns the experience with given id" do
      experience = experience_fixture()
      assert ClinicianAccounts.get_experience!(experience.id) == experience
    end

    test "create_experience/1 with valid data creates a experience" do
      assert {:ok, %Experience{} = experience} = ClinicianAccounts.create_experience(@valid_attrs)
      assert experience.description == "some description"
    end

    test "create_experience/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.create_experience(@invalid_attrs)
    end

    test "update_experience/2 with valid data updates the experience" do
      experience = experience_fixture()
      assert {:ok, experience} = ClinicianAccounts.update_experience(experience, @update_attrs)
      assert %Experience{} = experience
      assert experience.description == "some updated description"
    end

    test "update_experience/2 with invalid data returns error changeset" do
      experience = experience_fixture()
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.update_experience(experience, @invalid_attrs)
      assert experience == ClinicianAccounts.get_experience!(experience.id)
    end

    test "delete_experience/1 deletes the experience" do
      experience = experience_fixture()
      assert {:ok, %Experience{}} = ClinicianAccounts.delete_experience(experience)
      assert_raise Ecto.NoResultsError, fn -> ClinicianAccounts.get_experience!(experience.id) end
    end

    test "change_experience/1 returns a experience changeset" do
      experience = experience_fixture()
      assert %Ecto.Changeset{} = ClinicianAccounts.change_experience(experience)
    end
  end

  describe "clinicians experiences" do
    alias Rapcor.ClinicianAccounts.ClinicianExperience

    test "create_clinician_experience()/1 with valid data creates a clinician experience" do
      clinician = clinician_fixture()
      experience = experience_fixture()

      attrs = %{
        clinician_id: clinician.id,
        experience_id: experience.id,
        years: 1
      }

      assert {:ok, %ClinicianExperience{}} = ClinicianAccounts.create_clinician_experience(attrs)
    end
  end

  describe "documents" do
    alias Rapcor.ClinicianAccounts.Document

        @update_attrs %{back_photo: "some updated back_photo", expiration: ~D[2011-05-18], front_photo: "some updated front_photo", name: "some updated name", number: "some updated number", slug: "rt-rcp", state: "some updated state"}
    @invalid_attrs %{back_photo: nil, expiration: nil, front_photo: nil, number: nil, slug: nil, state: nil}
    @valid_attrs %{back_photo: "some back_photo", expiration: ~D[2010-04-17], front_photo: "some front_photo", name: "some name", number: "some number", slug: "rt-rcp", state: "some state"}


    
    test "list_documents/0 returns all documents" do
      document = document_fixture()
      clinician = ClinicianAccounts.get_clinician!(document.clinician_id)
      assert ClinicianAccounts.list_clinician_documents(clinician) == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert ClinicianAccounts.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      clinician = clinician_fixture()
      attrs = Map.put(@valid_attrs, :clinician_id, clinician.id)
      assert {:ok, %Document{} = document} = ClinicianAccounts.create_document(attrs)
      assert document.back_photo == "some back_photo"
      assert document.expiration == ~D[2010-04-17]
      assert document.front_photo == "some front_photo"
      assert document.number == "some number"
      assert document.slug == "rt-rcp"
      assert document.state == "some state"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, document} = ClinicianAccounts.update_document(document, @update_attrs)
      assert %Document{} = document
      assert document.back_photo == "some updated back_photo"
      assert document.expiration == ~D[2011-05-18]
      assert document.front_photo == "some updated front_photo"
      assert document.number == "some updated number"
      assert document.slug == "rt-rcp"
      assert document.state == "some updated state"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = ClinicianAccounts.update_document(document, @invalid_attrs)
      assert document == ClinicianAccounts.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = ClinicianAccounts.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> ClinicianAccounts.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = ClinicianAccounts.change_document(document)
    end
  end
end
