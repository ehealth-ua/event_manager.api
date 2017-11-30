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
end
