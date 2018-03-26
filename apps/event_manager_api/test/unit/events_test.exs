defmodule EventManagerApi.EventsTest do
  @moduledoc false

  use ExUnit.Case, async: true

  alias EventManagerApi.Events
  alias EventManagerApi.Events.Event
  alias Ecto.Adapters.SQL.Sandbox
  alias EventManagerApi.Repo
  import EventManagerApi.Factory

  setup do
    Sandbox.checkout(EventManagerApi.Repo)
  end

  test "delete_events by max_number" do
    insert(:event)
    %{id: id2} = insert(:event)
    assert 2 == length(Repo.all(Event))

    Events.delete_events(1, 1)
    events = Repo.all(Event)
    assert 1 == length(events)
    assert id2 == hd(events).id
  end

  test "delete_events by expired_date" do
    insert(:event)
    insert(:event)
    assert 2 == length(Repo.all(Event))

    Events.delete_events(10_000, 0)
    events = Repo.all(Event)
    assert Enum.empty?(events)
  end

  test "events list without search parameters" do
    insert(:event)
    insert(:event)

    entries_count =
      %{}
      |> Events.list()
      |> Map.from_struct()
      |> Map.get(:total_entries)

    assert entries_count == 2
  end

  test "events list with search parameters: date" do
    moment = NaiveDateTime.utc_now()
    event_out = insert(:event, %{event_time: NaiveDateTime.add(moment, -2)})
    event_in = insert(:event, %{event_time: moment})
    insert(:event, %{event_time: NaiveDateTime.add(moment, 2)})

    entries =
      %{}
      |> Map.put("date", moment)
      |> Events.list()
      |> Map.from_struct()
      |> Map.get(:entries)

    assert length(entries) == 2
    refute event_out in entries
    assert event_in in entries
  end

  test "events list with search parameters: other" do
    event_out = insert(:event, properties: %{"status" => %{"new_value" => "TEST"}})
    event_in = insert(:event)

    entries =
      %{}
      |> Map.put("attribute_name", "status")
      |> Map.put("new_value", "EXPIRED")
      |> Events.list()
      |> Map.from_struct()
      |> Map.get(:entries)

    refute event_out in entries
    assert event_in in entries
  end

  test "events list with search parameters: new_value is nil" do
    event_out = insert(:event, properties: %{"status" => nil})
    event_in = insert(:event)

    entries =
      %{}
      |> Map.put("attribute_name", "status")
      |> Events.list()
      |> Map.from_struct()
      |> Map.get(:entries)

    refute event_out in entries
    assert event_in in entries
  end

  test "events list with bad search parameters: attribute_name is not set" do
    insert(:event)
    changeset = Events.list(%{"new_value" => "TEST"})
    refute changeset.valid?
  end

  test "events list with bad search parameters: changeset is not valid" do
    insert(:event)
    changeset = Events.list(%{"date" => "TEST"})
    refute changeset.valid?
  end

  test "events list with search parameters: entity_type" do
    event_in = insert(:event)
    event_out = insert(:event, %{entity_type: "TestRequest"})

    entries =
      %{}
      |> Map.put("entity_type", "MedicationRequest")
      |> Events.list()
      |> Map.from_struct()
      |> Map.get(:entries)

    refute event_out in entries
    assert event_in in entries
  end

  test "getting event by id" do
    insert(:event)
    event = insert(:event)
    insert(:event)

    assert event == Events.get_by_id!(event.id)
  end
end
