defmodule EventManagerWeb.EventView do
  @moduledoc false

  use EventManagerWeb.Web, :view

  def render("index.json", %{events: events}) do
    render_many(events, __MODULE__, "event.json", as: :event)
  end

  def render("event.json", %{event: event}) do
    Map.take(event, ~w(
      event_type
      entity_type
      entity_id
      properties
      event_time
      changed_by
    )a)
  end
end
