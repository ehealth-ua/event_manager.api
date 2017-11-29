defmodule EventManagerApi.EventFactory do
  defmacro __using__(_opts) do
    quote do
      alias EventManagerApi.Events.Event

      def event_factory do
        %Event{
          event_type: Event.type(:change_status),
          entity_type: "MedicationRequest",
          entity_id: Ecto.UUID.generate(),
          properties: %{"previous_status" => "ACTIVE", "new_status" => "EXPIRED"},
          event_time: NaiveDateTime.utc_now(),
          changed_by: Ecto.UUID.generate(),
        }
      end
    end
  end
end
