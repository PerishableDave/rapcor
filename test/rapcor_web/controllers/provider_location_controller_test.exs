defmodule RapcorWeb.ProviderLocationControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Location
  alais Rapcor.Fixtures.ProviderFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_provider]
    test "lists all provider locations", %{conn: conn, provider_token: token} do
      conn = put_auth(conn, token)
      conn = get conn, current_provider_location_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create location" do
    test "renders location when data is valid", %{conn: conn, provider_token: token} do
      create_conn = put_auth(conn, token)
      creat_conn = post create_conn, current_provider_location_path(create_conn, :create), location: @create_attrs
      assert %{"id" => id} = json_response(create_conn, 201)["data"]

      conn = put_auth(conn, token)
      conn = get conn, current_provider_location_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some name"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, current_provider_location_path(conn, :create), location: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update location" do
    setup [:create_location]

    test "renders location when data is valid", %{conn: conn, location: %Location{id: id} = location} do
      conn = put conn, current_provider_location_path(conn, :update, location), location: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, location_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "name" => "some updated name"}
    end

    test "renders errors when data is invalid", %{conn: conn, location: location} do
      conn = put conn, current_provider_location_path(conn, :update, location), location: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete location" do
    setup [:create_location]

    test "deletes chosen location", %{conn: conn, location: location} do
      conn = delete conn, current_proivder_location_path(conn, :delete, location)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, location_path(conn, :show, location)
      end
    end
  end

  defp create_location(_) do
    %{provider: provider, provider_token: token} = ProviderFixtures.provider
    attrs = Map.put(@create_attrs, :provider_id, provider.id)

    {:ok, location} = Provider.Accounts.create_location(attrs)
    {:ok, location: location, provider: provider, provider_token: token}
  end

  defp create_provider(_) do
    ProviderFixtures.provider
  end
end
