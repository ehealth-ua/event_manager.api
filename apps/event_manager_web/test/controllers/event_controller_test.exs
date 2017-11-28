defmodule EventManagerWeb.EventControllerTest do
  @moduledoc false

  use EventManagerWeb.ConnCase, async: false

  describe "list change_status events" do
    test "success list no filters", %{conn: conn} do
      conn = get conn, event_path(conn, :list_change_status)
      assert json_response(conn, 200)
    end

    test "fail list with invalid date", %{conn: conn} do
      conn = get conn, event_path(conn, :list_change_status), %{date: "invalid"}
      assert json_response(conn, 422)
    end

    test "test by date filter", %{conn: conn} do
      event = insert(:event)
      conn = get conn, event_path(conn, :list_change_status), %{date: to_string(Date.utc_today())}
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["event_time"] == NaiveDateTime.to_iso8601(event.event_time)
    end
  end
end
