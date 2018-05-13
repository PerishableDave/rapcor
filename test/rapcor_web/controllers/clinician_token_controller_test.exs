defmodule RapcorWeb.ClinicianTokenControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.Fixtures.ClinicianFixtures
  alias Rapcor.ClinicianAccounts

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create clinician_token" do
    test "renders clinician_token when data is valid", %{conn: conn} do
      %{clinician: %{email: email}} = ClinicianFixtures.clinician
      password = ClinicianFixtures.password

      conn = post conn, clinician_token_path(conn, :create), email: email, password: password
      assert %{"id" => id} = json_response(conn, 201)["token"]
      assert String.length(id) == 36
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, clinician_token_path(conn, :create), stuff: "stuff"
      assert response(conn, 400)
      # assert json_response(conn, 400)["errors"] != %{}
    end
  end

  describe "delete clinician_token" do
    setup [:create_clinician_token]

    test "deletes chosen clinician_token", %{conn: conn, clinician_token: clinician_token} do
      conn = delete conn, clinician_token_path(conn, :delete, clinician_token)
      assert response(conn, 204)
      assert_raise Ecto.NoResultsError, fn -> ClinicianAccounts.get_clinician_token!(clinician_token.id) end
    end
  end

  defp create_clinician_token(_) do
    %{clinician: clinician} = ClinicianFixtures.clinician()
    {:ok, clinician_token} = ClinicianAccounts.create_clinician_token(clinician.email, ClinicianFixtures.password)

    {:ok, clinician_token: clinician_token}
  end
end
