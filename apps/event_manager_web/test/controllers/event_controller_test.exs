defmodule EventManagerWeb.EventControllerTest do
  @moduledoc false

  use EventManagerWeb.ConnCase, async: false

  describe "list change_status events" do
    test "success list no filters", %{conn: conn} do
      conn = get conn, event_path(conn, :list_change_status)
      assert json_response(conn, 200)
    end

    test "fail with invalid date", %{conn: conn} do
      conn = get conn, event_path(conn, :list_change_status), %{date: "invalid"}
      assert json_response(conn, 422)
    end

    test "success by date filter", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :list_change_status), %{date: to_string(Date.utc_today())}
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["event_time"] == NaiveDateTime.to_iso8601(event.event_time)
    end

    test "success by new_status filter", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :list_change_status), %{attribute_name: "status", new_value: "EXPIRED"}
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["properties"]["status"]["new_value"] == event.properties["status"]["new_value"]
    end

    test "success by attribute_name filter", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :list_change_status), %{attribute_name: "status"}
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["properties"]["status"]["new_value"] == event.properties["status"]["new_value"]
    end

    test "fail by new_value", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :list_change_status), %{new_value: "EXPIRED"}
      assert json_response(conn, 422)
    end

    test "success by all filters with paging", %{conn: conn} do
      event = insert(:event)
      insert(:event)
      insert(:event)
      insert(:event, properties: %{"status" => %{"new_value" => "REJECTED"}})
      conn = get conn, event_path(conn, :list_change_status), %{
        date: to_string(Date.utc_today()),
        attribute_name: "status",
        new_value: "EXPIRED",
        page_size: 1,
        page: 2
      }
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["properties"]["status"]["new_value"] == event.properties["status"]["new_value"]
      assert resp["paging"]["total_pages"] == 3
      assert resp["paging"]["page_number"] == 2
    end
  end

  describe "show by id" do
    test "success get by id", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :show, event.id)
      resp = json_response(conn, 200)
      assert event.id == resp["data"]["id"]
    end

    test "fail get by id", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get conn, event_path(conn, :show, "1")
      end

      conn = get conn, event_path(conn, :show, "invalid")
      assert json_response(conn, 404)
    end
  end
end
