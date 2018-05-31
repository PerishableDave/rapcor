defmodule RapcorWeb.DocumentControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.ClinicianAccounts
  alias Rapcor.ClinicianAccounts.Document
  alias Rapcor.Fixtures.ClinicianFixtures

  @create_attrs %{back_photo: "some back_photo", expiration: ~D[2010-04-17], front_photo: "some front_photo", number: "some number", slug: "rt-rcp", state: "some state"}
  @update_attrs %{back_photo: "some updated back_photo", expiration: ~D[2011-05-18], front_photo: "some updated front_photo", number: "some updated number", slug: "rt-rcp", state: "some updated state"}
  @invalid_attrs %{back_photo: nil, expiration: nil, front_photo: nil, number: nil, slug: nil, state: nil}


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_clinician]
    test "lists all documents", %{conn: conn, clinician_token: token} do
      conn = put_auth(conn, token)
      conn = get conn, current_clinician_document_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create document" do
    setup [:create_clinician]
    test "renders document when data is valid", %{conn: conn, clinician_token: token} do
      create_conn = put_auth(conn, token)
      create_conn = post create_conn, current_clinician_document_path(create_conn, :create), document: @create_attrs
      assert %{"id" => id} = json_response(create_conn, 201)["data"]

      conn = put_auth(conn, token)
      conn = get conn, current_clinician_document_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "back_photo" => "some back_photo",
        "expiration" => "2010-04-17",
        "front_photo" => "some front_photo",
        "number" => "some number",
        "slug" => "rt-rcp",
        "state" => "some state"}
    end

    test "renders errors when data is invalid", %{conn: conn, clinician_token: token} do
      conn = put_auth(conn, token)
      conn = post conn, current_clinician_document_path(conn, :create), document: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update document" do
    setup [:create_document]

    test "renders document when data is valid", %{conn: conn, document: %Document{id: id} = document, clinician_token: token} do
      update_conn = put_auth(conn, token)
      update_conn = put update_conn, current_clinician_document_path(update_conn, :update, document), document: @update_attrs
      assert %{"id" => ^id} = json_response(update_conn, 200)["data"]

      conn = put_auth(conn, token)
      conn = get conn, current_clinician_document_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "back_photo" => "some updated back_photo",
        "expiration" => "2011-05-18",
        "front_photo" => "some updated front_photo",
        "number" => "some updated number",
        "slug" => "rt-rcp",
        "state" => "some updated state"}
    end

    test "renders errors when data is invalid", %{conn: conn, document: document, clinician_token: token} do
      conn = put_auth(conn, token)
      conn = put conn, current_clinician_document_path(conn, :update, document), document: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete document" do
    setup [:create_document]

    test "deletes chosen document", %{conn: conn, document: document, clinician_token: token} do
      delete_conn = put_auth(conn, token)
      delete_conn = delete delete_conn, current_clinician_document_path(delete_conn, :delete, document)
      assert response(delete_conn, 204)
      assert_error_sent 404, fn ->
        conn = put_auth(conn, token)
        get conn, current_clinician_document_path(conn, :show, document)
      end
    end
  end

  defp create_document(context) do
    %{clinician: clinician, clinician_token: token} = create_clinician(context)
    attrs = Map.put(@create_attrs, :clinician_id, clinician.id)

    {:ok, document} = ClinicianAccounts.create_document(attrs)
    {:ok, document: document, clinician: clinician, clinician_token: token}
  end

  defp create_clinician(_) do
    ClinicianFixtures.clinician
  end
end
