defmodule RapcorWeb.ProviderTokenControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.Fixtures.ProviderFixtures
  alias Rapcor.ProviderAccounts

  @create_attrs %{source: "some source"}
  @invalid_attrs %{source: nil}

  def fixture(:provider_token) do
    {:ok, provider_token} = ProviderAccounts.create_provider_token(@create_attrs)
    provider_token
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create provider_token" do
    setup [:create_provider_token]

    test "renders provider_token when data is valid", %{conn: conn, provider: provider} do
      password = ProviderFixtures.password
      conn = post conn, provider_token_path(conn, :create), contact_email: provider.contact_email, password: password

      assert %{"id" => id} = json_response(conn, 201)["token"]
      assert String.length(id) == 36
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, provider_token_path(conn, :create), provider_token: @invalid_attrs
      assert response(conn, 400)
    end
  end

    describe "delete provider_token" do
    setup [:create_provider_token]

    test "deletes chosen provider_token", %{conn: conn, provider_token: provider_token} do
      conn = delete conn, provider_token_path(conn, :delete, provider_token)
      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> ProviderAccounts.get_provider_token!(provider_token.id) end
    end
  end

  defp create_provider_token(_) do
    {:ok, ProviderFixtures.provider()}
  end
end
