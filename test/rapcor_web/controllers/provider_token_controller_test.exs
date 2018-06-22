defmodule RapcorWeb.ProviderTokenControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.ProviderToken

  @create_attrs %{source: "some source"}
  @update_attrs %{source: "some updated source"}
  @invalid_attrs %{source: nil}

  def fixture(:provider_token) do
    {:ok, provider_token} = ProviderAccounts.create_provider_token(@create_attrs)
    provider_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all provider_tokens", %{conn: conn} do
      conn = get conn, provider_token_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create provider_token" do
    test "renders provider_token when data is valid", %{conn: conn} do
      conn = post conn, provider_token_path(conn, :create), provider_token: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, provider_token_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "source" => "some source"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, provider_token_path(conn, :create), provider_token: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update provider_token" do
    setup [:create_provider_token]

    test "renders provider_token when data is valid", %{conn: conn, provider_token: %ProviderToken{id: id} = provider_token} do
      conn = put conn, provider_token_path(conn, :update, provider_token), provider_token: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, provider_token_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "source" => "some updated source"}
    end

    test "renders errors when data is invalid", %{conn: conn, provider_token: provider_token} do
      conn = put conn, provider_token_path(conn, :update, provider_token), provider_token: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete provider_token" do
    setup [:create_provider_token]

    test "deletes chosen provider_token", %{conn: conn, provider_token: provider_token} do
      conn = delete conn, provider_token_path(conn, :delete, provider_token)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, provider_token_path(conn, :show, provider_token)
      end
    end
  end

  defp create_provider_token(_) do
    provider_token = fixture(:provider_token)
    {:ok, provider_token: provider_token}
  end
end
