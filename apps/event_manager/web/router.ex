defmodule EventManager.Router do
  @moduledoc false

  use EventManager.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventManager do
    pipe_through :api

    scope "/events" do
      get "/", EventController, :list
      get "/:id", EventController, :show
    end
  end
end
