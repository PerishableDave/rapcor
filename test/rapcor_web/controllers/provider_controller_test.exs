defmodule RapcorWeb.ProviderControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ProviderAccounts.Provider
  alias Rapcor.Fixtures.ProviderFixtures

  @create_attrs %{administrative_area: "some administrative_area", contact_email: "some@email.com", contact_number: "some contact_number", country: "some country", locality: "some locality", name: "some name", password: "some password", password_confirmation: "some password", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
  @update_attrs %{administrative_area: "some updated administrative_area", contact_email: "some@email.com", contact_number: "some updated contact_number", country: "some updated country", locality: "some updated locality", name: "some updated name", password: "some updated password", password_confirmation: "some updated password", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}
  @invalid_attrs %{administrative_area: nil, contact_email: nil, contact_number: "some updated contact_number", country: "some updated country", locality: "some updated locality", name: "some updated name", password: "some updated password", password_confirmation: "some updated password", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create provider" do
    test "renders provider when data is valid", %{conn: conn} do
      conn = post conn, provider_path(conn, :create), provider: @create_attrs
      json = json_response(conn, 201)["provider"]
      assert %{"id" => id} = json
      assert json == %{
        "id" => id,
        "administrative_area" => "some administrative_area",
        "contact_email" => "some@email.com",
        "contact_number" => "some contact_number",
        "country" => "some country",
        "locality" => "some locality",
        "name" => "some name",
        "postal_code" => "some postal_code",
        "premise" => "some premise",
        "sub_administrative_area" => "some sub_administrative_area",
        "thoroughfare" => "some thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, provider_path(conn, :create), provider: %{}
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update provider" do
    setup [:create_provider]

    test "renders provider when data is valid", %{conn: conn, provider: %Provider{id: id}, provider_token: token} do
      conn = put_auth(conn, token)
      conn = put conn, current_provider_path(conn, :update), provider: @update_attrs
      assert json_response(conn, 200)["provider"] == %{
        "id" => id,
        "administrative_area" => "some updated administrative_area",
        "contact_email" => "some@email.com",
        "contact_number" => "some updated contact_number",
        "country" => "some updated country",
        "locality" => "some updated locality",
        "name" => "some updated name",
        "postal_code" => "some updated postal_code",
        "premise" => "some updated premise",
        "sub_administrative_area" => "some updated sub_administrative_area",
        "thoroughfare" => "some updated thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn, provider_token: token} do
      conn = put_auth(conn, token)
      conn = put conn, current_provider_path(conn, :update), provider: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_provider(_) do
    ProviderFixtures.provider
  end
end
