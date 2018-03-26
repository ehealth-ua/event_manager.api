defmodule EventManagerWeb.EventControllerTest do
  @moduledoc false

  use EventManagerWeb.ConnCase, async: false
  alias Ecto.UUID

  describe "list change_status events" do
    test "success list no filters", %{conn: conn} do
      conn = get(conn, event_path(conn, :list))
      assert json_response(conn, 200)
    end

    test "fail with invalid date", %{conn: conn} do
      conn = get(conn, event_path(conn, :list), %{date: "invalid"})
      assert json_response(conn, 422)
    end

    test "success by date filter", %{conn: conn} do
      date = NaiveDateTime.utc_now()
      event = insert(:event)
      conn = get(conn, event_path(conn, :list), %{date: to_string(date)})
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["event_time"] == NaiveDateTime.to_iso8601(event.event_time)
    end

    test "success by new_status filter", %{conn: conn} do
      event = insert(:event)
      conn = get(conn, event_path(conn, :list), %{attribute_name: "status", new_value: "EXPIRED"})
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])

      assert hd(resp["data"])["properties"]["status"]["new_value"] ==
               event.properties["status"]["new_value"]
    end

    test "success by attribute_name filter", %{conn: conn} do
      event = insert(:event)
      conn = get(conn, event_path(conn, :list), %{attribute_name: "status"})
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])

      assert hd(resp["data"])["properties"]["status"]["new_value"] ==
               event.properties["status"]["new_value"]
    end

    test "success by entity_type", %{conn: conn} do
      insert(:event, entity_type: "EmployeeRequest")
      event = insert(:event)
      conn = get(conn, event_path(conn, :list), %{entity_type: "MedicationRequest"})
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["entity_type"] == event.entity_type
    end

    test "success by event_type", %{conn: conn} do
      insert(:event, event_type: "OtherEventType")
      event = insert(:event)
      conn = get(conn, event_path(conn, :list), %{event_type: "StatusChangeEvent"})
      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])
      assert hd(resp["data"])["event_type"] == event.event_type
    end

    test "fail by new_value", %{conn: conn} do
      insert(:event)
      conn = get(conn, event_path(conn, :list), %{new_value: "EXPIRED"})
      assert json_response(conn, 422)
    end

    test "success by all filters with paging", %{conn: conn} do
      event = insert(:event)
      insert(:event)
      insert(:event)
      insert(:event, properties: %{"status" => %{"new_value" => "REJECTED"}})

      conn =
        get(conn, event_path(conn, :list), %{
          date: "2017-12-20T15:00:00",
          attribute_name: "status",
          new_value: "EXPIRED",
          entity_type: "MedicationRequest",
          event_type: "StatusChangeEvent",
          page_size: 1,
          page: 2
        })

      assert resp = json_response(conn, 200)
      assert 1 == length(resp["data"])

      assert hd(resp["data"])["properties"]["status"]["new_value"] ==
               event.properties["status"]["new_value"]

      assert hd(resp["data"])["event_type"] == event.event_type
      assert hd(resp["data"])["entity_type"] == event.entity_type
      assert resp["paging"]["total_pages"] == 3
      assert resp["paging"]["page_number"] == 2
    end
  end

  describe "show by id" do
    test "success get by id", %{conn: conn} do
      event = insert(:event)
      conn = get(conn, event_path(conn, :show, event.id))
      resp = json_response(conn, 200)
      assert event.id == resp["data"]["id"]
    end

    test "fail get by id", %{conn: conn} do
      assert_raise Ecto.NoResultsError, fn ->
        get(conn, event_path(conn, :show, UUID.generate()))
      end

      conn = get(conn, event_path(conn, :show, "invalid"))
      assert json_response(conn, 404)
    end
  end
end
