defmodule EventManagerApi.EventFactory do
  @moduledoc false

  defmacro __using__(_opts) do
    quote do
      import Ecto.UUID, only: [generate: 0]
      alias EventManagerApi.Events.Event

      def event_factory do
        %Event{
          event_type: Event.type(:change_status),
          entity_type: "MedicationRequest",
          entity_id: generate(),
          properties: %{"status" => %{"new_value" => "EXPIRED"}},
          event_time: NaiveDateTime.utc_now(),
          changed_by: generate(),
        }
      end
    end
  end
end
