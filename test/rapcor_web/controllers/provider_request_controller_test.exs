defmodule RapcorWeb.ProviderRequestControllerTest do
  use RapcorWeb.ConnCase

  alias Rapcor.Registry
  alias Rapcor.Registry.Request
  alias Rapcor.Fixtures.ProviderFixtures
  alias Rapcor.Fixtures.ExperienceFixtures

  @create_attrs %{contact_email: "some@email.com", contact_phone: "+11231234", end_date: "2015-01-23T23:50:07.000000Z", notes: "some notes", request_experiences: [%{experience_id: 1, minimum_years: 3}], start_date: "2015-01-23T23:50:07.000000Z"}
  @update_attrs %{contact_email: "updated@email.com", contact_phone: "+12342345", end_date: "2015-01-23T23:50:07.000000Z", notes: "some updated notes", request_experiences: [], start_date: "2015-01-23T23:50:07.000000Z"}
  @invalid_attrs %{contact_email: "test", contact_phone: nil, notes: nil, request_experiences: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    setup [:create_request]

    test "lists all requests", %{conn: conn, request: request, provider_token: token, experience: experience} do
      conn = put_auth(conn, token)
      conn = get conn, current_provider_request_path(conn, :index)
      assert json_response(conn, 200)["requests"] == [%{
        "contact_email" => "some@email.com",
        "contact_phone" => "+11231234",
        "end_date" => "2015-01-23T23:50:07.000000Z",
        "id" => request.id,
        "notes" => "some notes",
        "request_experiences" => [%{"experience_id" => experience.id, "minimum_years" => 3}],
        "start_date" => "2015-01-23T23:50:07.000000Z"
      }]
    end
  end

  describe "create request" do
    setup [:create_provider]

    test "renders request when data is valid", %{conn: conn, provider_token: token} do
      %{experience: %{id: experience_id}} = ExperienceFixtures.experience
      create_attrs = Map.put(@create_attrs, :request_experiences, [%{experience_id: experience_id, minimum_years: 3}])
      create_conn = put_auth(conn, token)
      create_conn = post create_conn, current_provider_request_path(create_conn, :create), request: create_attrs
      assert %{"id" => id} = json_response(create_conn, 201)["request"]

      conn = put_auth(conn, token)
      conn = get conn, current_provider_request_path(conn, :show, id)
      assert json_response(conn, 200)["request"] == %{
        "id" => id,
        "contact_email" => "some@email.com",
        "contact_phone" => "+11231234",
        "end_date" => "2015-01-23T23:50:07.000000Z",
        "notes" => "some notes",
        "request_experiences" => [%{"experience_id" => experience_id, "minimum_years" => 3}],
        "start_date" => "2015-01-23T23:50:07.000000Z"}
    end

    test "renders errors when data is invalid", %{conn: conn, provider_token: token} do
      conn = put_auth(conn, token)
      conn = post conn, current_provider_request_path(conn, :create), request: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update request" do
    setup [:create_request]

    test "renders request when data is valid", %{conn: conn, request: %Request{id: id} = request, provider_token: token, experience: experience} do
      update_conn = put_auth(conn, token)
      update_conn = put update_conn, current_provider_request_path(update_conn, :update, request), request: @update_attrs
      assert %{"id" => ^id} = json_response(update_conn, 200)["request"]

      conn = put_auth(conn, token)
      conn = get conn, current_provider_request_path(conn, :show, id)
      assert json_response(conn, 200)["request"] == %{
        "id" => id,
        "contact_email" => "updated@email.com",
        "contact_phone" => "+12342345",
        "notes" => "some updated notes",
        "request_experiences" => [%{"experience_id" => experience.id, "minimum_years" => 3}],
        "start_date" => "2015-01-23T23:50:07.000000Z",
        "end_date" => "2015-01-23T23:50:07.000000Z"}
    end

    test "renders errors when data is invalid", %{conn: conn, request: request, provider_token: token} do
      conn = put_auth(conn, token)
      conn = put conn, current_provider_request_path(conn, :update, request), request: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  defp create_request(context) do
    %{experience: %{id: experience_id} = experience} = ExperienceFixtures.experience
    %{provider: provider, provider_token: token} = create_provider(context)

    attrs = @create_attrs
    |> Map.put(:provider_id, provider.id)
    |> Map.put(:request_experiences, [%{experience_id: experience_id, minimum_years: 3}])

    {:ok, request} = Registry.create_request(attrs)

    {:ok, request: request, provider: provider, provider_token: token, experience: experience}
  end

  defp create_provider(_) do
    ProviderFixtures.provider
  end
end
