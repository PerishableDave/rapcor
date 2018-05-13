defmodule RapcorWeb.ExperienceControllerTest do
  use RapcorWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all experiences", %{conn: conn} do
      conn = get conn, experience_path(conn, :index)
      assert json_response(conn, 200)["experiences"] == []
    end
  end
end
