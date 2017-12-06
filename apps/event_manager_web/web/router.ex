defmodule EventManagerWeb.Router do
  @moduledoc false

  use EventManagerWeb.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventManagerWeb do
    pipe_through :api

    scope "/events" do
      get "/", EventController, :list
      get "/:id", EventController, :show
    end
  end
end
