defmodule RapcorWeb.ClinicianControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Clinician

  @create_attrs %{administrative_area: "some administrative_area", country: "some country", email: "some@email.com", first_name: "some first_name", last_name: "some last_name", locality: "some locality", middle_name: "some middle_name", password: "some password_hash", phone_number: "some phone_number", postal_code: "some postal_code", premise: "some premise", sub_administrative_area: "some sub_administrative_area", thoroughfare: "some thoroughfare"}
  @update_attrs %{administrative_area: "some updated administrative_area", country: "some updated country", email: "some@email.com", first_name: "some updated first_name", last_name: "some updated last_name", locality: "some updated locality", middle_name: "some updated middle_name", password_hash: "some updated password_hash", phone_number: "some updated phone_number", postal_code: "some updated postal_code", premise: "some updated premise", sub_administrative_area: "some updated sub_administrative_area", thoroughfare: "some updated thoroughfare"}
  @invalid_attrs %{administrative_area: nil, country: nil, email: nil, first_name: nil, last_name: nil, locality: nil, middle_name: nil, password_hash: nil, phone_number: nil, postal_code: nil, premise: nil, sub_administrative_area: nil, thoroughfare: nil}

  def fixture(:clinician) do
    {:ok, clinician} = ClinicianAccounts.create_clinician(@create_attrs)
    clinician
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all clinicians", %{conn: conn} do
      conn = get conn, clinician_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create clinician" do
    test "renders clinician when data is valid", %{conn: conn} do
      conn = post conn, clinician_path(conn, :create), clinician: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, clinician_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "administrative_area" => "some administrative_area",
        "country" => "some country",
        "email" => "some@email.com",
        "first_name" => "some first_name",
        "last_name" => "some last_name",
        "locality" => "some locality",
        "middle_name" => "some middle_name",
        "phone_number" => "some phone_number",
        "postal_code" => "some postal_code",
        "premise" => "some premise",
        "sub_administrative_area" => "some sub_administrative_area",
        "thoroughfare" => "some thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, clinician_path(conn, :create), clinician: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update clinician" do
    setup [:create_clinician]

    test "renders clinician when data is valid", %{conn: conn, clinician: %Clinician{id: id} = clinician} do
      conn = put conn, clinician_path(conn, :update, clinician), clinician: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, clinician_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "administrative_area" => "some updated administrative_area",
        "country" => "some updated country",
        "email" => "some@email.com",
        "first_name" => "some updated first_name",
        "last_name" => "some updated last_name",
        "locality" => "some updated locality",
        "middle_name" => "some updated middle_name",
        "phone_number" => "some updated phone_number",
        "postal_code" => "some updated postal_code",
        "premise" => "some updated premise",
        "sub_administrative_area" => "some updated sub_administrative_area",
        "thoroughfare" => "some updated thoroughfare"}
    end

    test "renders errors when data is invalid", %{conn: conn, clinician: clinician} do
      conn = put conn, clinician_path(conn, :update, clinician), clinician: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete clinician" do
    setup [:create_clinician]

    test "deletes chosen clinician", %{conn: conn, clinician: clinician} do
      conn = delete conn, clinician_path(conn, :delete, clinician)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, clinician_path(conn, :show, clinician)
      end
    end
  end

  defp create_clinician(_) do
    clinician = fixture(:clinician)
    {:ok, clinician: clinician}
  end
end
