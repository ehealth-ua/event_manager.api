defmodule EventManagerWeb.Router do
  use EventManagerWeb.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", EventManagerWeb do
    pipe_through :api
  end
end
