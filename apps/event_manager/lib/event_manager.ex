defmodule EventManager do
  @moduledoc false

  use Application
  alias EventManager.Endpoint

  def start(_type, _args) do
    children = [
      {Endpoint, []}
    ]

    opts = [strategy: :one_for_one, name: EventManager.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
