defmodule Rapcor.ProviderAccountsTest do
  use Rapcor.DataCase

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider

  describe "providers" do
    alias Rapcor.ProviderAccounts.Provider

    @valid_attrs %{administrative_area: "some administrative_area", contact_email: "some@email.com", contact_number: "some contact_number", country: "some country", locality: "some locality", name: "some name", password: "some password", password_confirmation: "some password", postal_code: "some postal_code", premise: "some premise", thoroughfare: "some thoroughfare"}
    @update_attrs %{administrative_area: "some updated administrative_area", contact_email: "some@email.com", contact_number: "some updated contact_number", country: "some updated country", locality: "some updated locality", name: "some updated name", password: "some updated password", password_confirmation: "some updated password", postal_code: "some updated postal_code", premise: "some updated premise", thoroughfare: "some updated thoroughfare"}
    @invalid_attrs %{administrative_area: nil, contact_email: nil, contact_number: nil, country: nil, locality: nil, name: nil, password_hash: nil, postal_code: nil, premise: nil, thoroughfare: nil}

    def provider_fixture(attrs \\ %{}) do
      {:ok, provider} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ProviderAccounts.create_provider()

      provider
      |> Map.put(:password, nil)
      |> Map.put(:password_confirmation, nil)
    end

    test "list_providers/0 returns all providers" do
      provider = provider_fixture()
      assert ProviderAccounts.list_providers() == [provider]
    end

    test "get_provider!/1 returns the provider with given id" do
      provider = provider_fixture()
      assert ProviderAccounts.get_provider!(provider.id) == provider
    end

    test "create_provider/1 with valid data creates a provider" do
      assert {:ok, %Provider{} = provider} = ProviderAccounts.create_provider(@valid_attrs)
      assert provider.administrative_area == "some administrative_area"
      assert provider.contact_email == "some contact_email"
      assert provider.contact_number == "some contact_number"
      assert provider.country == "some country"
      assert provider.locality == "some locality"
      assert provider.name == "some name"
      assert Provider.check_password(provider, "some password")
      assert provider.postal_code == "some postal_code"
      assert provider.premise == "some premise"
      assert provider.thoroughfare == "some thoroughfare"
    end

    test "create_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ProviderAccounts.create_provider(@invalid_attrs)
    end

    test "update_provider/2 with valid data updates the provider" do
      provider = provider_fixture()
      assert {:ok, provider} = ProviderAccounts.update_provider(provider, @update_attrs)
      assert %Provider{} = provider
      assert provider.administrative_area == "some updated administrative_area"
      assert provider.contact_email == "some updated contact_email"
      assert provider.contact_number == "some updated contact_number"
      assert provider.country == "some updated country"
      assert provider.locality == "some updated locality"
      assert provider.name == "some updated name"
      assert Provider.check_password(provider, "some password")
      assert provider.postal_code == "some updated postal_code"
      assert provider.premise == "some updated premise"
      assert provider.thoroughfare == "some updated thoroughfare"
    end

    test "update_provider/2 with invalid data returns error changeset" do
      provider = provider_fixture()
      assert {:error, %Ecto.Changeset{}} = ProviderAccounts.update_provider(provider, @invalid_attrs)
      assert provider == ProviderAccounts.get_provider!(provider.id)
    end

    test "delete_provider/1 deletes the provider" do
      provider = provider_fixture()
      assert {:ok, %Provider{}} = ProviderAccounts.delete_provider(provider)
      assert_raise Ecto.NoResultsError, fn -> ProviderAccounts.get_provider!(provider.id) end
    end

    test "change_provider/1 returns a provider changeset" do
      provider = provider_fixture()
      assert %Ecto.Changeset{} = ProviderAccounts.change_provider(provider)
    end
  end
end
