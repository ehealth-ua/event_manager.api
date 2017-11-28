defmodule EventManagerWeb.EventController do
  use EventManagerWeb.Web, :controller

  alias EventManagerApi.Events
  alias Scrivener.Page

  action_fallback EventManagerWeb.FallbackController

  def list_change_status(conn, params) do
    with %Page{} = paging <- Events.list(params) do
      render(conn, "index.json",
        events: paging.entries,
        paging: paging
      )
    end
  end

  def show(conn, %{"id" => id}) do
  end
end
