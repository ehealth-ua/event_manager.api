defmodule Core.Application do
  @moduledoc false

  use Application
  alias Confex.Resolver
  alias Core.Scheduler

  def start(_type, _args) do
    :telemetry.attach("log-handler", [:core, :repo, :query], &Core.TelemetryHandler.handle_event/4, nil)

    children = [
      {Core.Repo, []},
      {Scheduler, []}
    ]

    opts = [strategy: :one_for_one, name: Core.Supervisor]
    result = Supervisor.start_link(children, opts)
    Scheduler.create_jobs()
    result
  end
end
