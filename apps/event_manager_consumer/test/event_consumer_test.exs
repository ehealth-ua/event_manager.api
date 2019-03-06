defmodule EventManagerConsumerTest do
  use Core.ModelCase

  alias Core.Events.Event
  alias Core.Repo
  alias Ecto.UUID
  alias EventManagerConsumer.Kafka.Consumer

  test "invalid event is not stored" do
    event = %{
      event_type: "",
      entity_type: "User",
      entity_id: ""
    }

    Consumer.consume(event)
    refute Repo.one(Event)
  end

  test "consume valid event with atom keys works" do
    entity_id = UUID.generate()
    changed_by = UUID.generate()
    status = Event.type(:change_status)
    ts = NaiveDateTime.utc_now()

    event = %{
      event_type: status,
      entity_type: "User",
      entity_id: entity_id,
      properties: %{},
      event_time: ts,
      changed_by: changed_by
    }

    Consumer.consume(event)

    assert %Event{
             id: _,
             event_type: status,
             entity_type: "User",
             entity_id: entity_id,
             properties: %{},
             event_time: ts,
             changed_by: changed_by
           } = Repo.one(Event)
  end

  test "consume valid event with string keys works" do
    entity_id = UUID.generate()
    changed_by = UUID.generate()
    status = Event.type(:change_status)
    ts = NaiveDateTime.utc_now()

    event = %{
      "event_type" => status,
      "entity_type" => "User",
      "entity_id" => entity_id,
      "properties" => %{},
      "event_time" => ts,
      "changed_by" => changed_by
    }

    Consumer.consume(event)

    assert %Event{
             id: _,
             event_type: status,
             entity_type: "User",
             entity_id: entity_id,
             properties: %{},
             event_time: ts,
             changed_by: changed_by
           } = Repo.one(Event)
  end
end
