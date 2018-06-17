defmodule RapcorWeb.ProviderControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ProviderAccounts
  alias Rapcor.ProviderAccounts.Provider

  @create_attrs %{administrative_area: "some administrative_area", contact_email: "some@email.com", contact_number: "some contact_number", country: "some country", locality: "some locality", name: "some name", password: "some password", password_confirmation: "some password", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
  @update_attrs %{administrative_area: "some updated administrative_area", contact_email: "some updated contact_email", contact_number: "some updated contact_number", country: "some updated country", locality: "some updated locality", name: "some updated name", password: "some updated password", password_confirmation: "some updated password", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}
  @invalid_attrs %{administrative_area: nil, contact_email: nil, contact_number: nil, country: nil, locality: nil, name: nil, password_hash: nil, postal_code: nil, premise: nil, sub_administrative_area: nil, thoroughfare: nil}

  def fixture(:provider) do
    {:ok, provider} = ProviderAccounts.create_provider(@create_attrs)
    provider
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create provider" do
    test "renders provider when data is valid", %{conn: conn} do
      conn = post conn, provider_path(conn, :create), provider: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, provider_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "administrative_area" => "some administrative_area",
        "contact_email" => "some contact_email",
        "contact_number" => "some contact_number",
        "country" => "some country",
        "locality" => "some locality",
        "name" => "some name",
        "password_hash" => "some password_hash",
        "postal_code" => "some postal_code",
        "premise" => "some premise",
        "sub_administrative_area" => "some sub_administrative_area",
        "thoroughfare" => "some thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, provider_path(conn, :create), provider: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update provider" do
    setup [:create_provider]

    test "renders provider when data is valid", %{conn: conn, provider: %Provider{id: id} = provider} do
      conn = put conn, provider_path(conn, :update, provider), provider: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, provider_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "administrative_area" => "some updated administrative_area",
        "contact_email" => "some updated contact_email",
        "contact_number" => "some updated contact_number",
        "country" => "some updated country",
        "locality" => "some updated locality",
        "name" => "some updated name",
        "password_hash" => "some updated password_hash",
        "postal_code" => "some updated postal_code",
        "premise" => "some updated premise",
        "sub_administrative_area" => "some updated sub_administrative_area",
        "thoroughfare" => "some updated thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn, provider: provider} do
      conn = put conn, provider_path(conn, :update, provider), provider: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete provider" do
    setup [:create_provider]

    test "deletes chosen provider", %{conn: conn, provider: provider} do
      conn = delete conn, provider_path(conn, :delete, provider)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, provider_path(conn, :show, provider)
      end
    end
  end

  defp create_provider(_) do
    provider = fixture(:provider)
    {:ok, provider: provider}
  end
end
