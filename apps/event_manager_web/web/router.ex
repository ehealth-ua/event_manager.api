defmodule EventManagerWeb.Router do
  use EventManagerWeb.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventManagerWeb do
    pipe_through :api

    scope "/events" do
      get "/StatusChangeEvent", EventController, :list_change_status
      get "/:id", EventController, :show
    end
  end
end
