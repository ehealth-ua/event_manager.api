defmodule EventManagerWeb.EventView do
  @moduledoc false

  use EventManagerWeb.Web, :view

  def render("index.json", %{events: events}) do
    render_many(events, __MODULE__, "show.json", as: :event)
  end

  def render("show.json", %{event: event}) do
    Map.take(event, ~w(
      id
      event_type
      entity_type
      entity_id
      properties
      event_time
      changed_by
    )a)
  end
end
