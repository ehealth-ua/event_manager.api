defmodule EventManagerWeb.EventController do
  @moduledoc false

  use EventManagerWeb.Web, :controller

  alias EventManagerApi.Events
  alias EventManagerApi.Events.Event
  alias Scrivener.Page

  action_fallback EventManagerWeb.FallbackController

  def list(conn, params) do
    with %Page{} = paging <- Events.list(params) do
      render(conn, "index.json",
        events: paging.entries,
        paging: paging
      )
    end
  end

  def show(conn, %{"id" => id}) do
    with %Event{} = event <- Events.get_by_id!(id) do
      render(conn, "show.json", %{
        event: event
      })
    end
  end
end
