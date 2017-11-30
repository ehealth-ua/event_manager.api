defmodule EventManagerApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  alias EventManagerApi.Scheduler

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # List all child processes to be supervised
    children = [
      supervisor(EventManagerApi.Repo, []),
      worker(Scheduler, [])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: EventManagerApi.Supervisor]
    result = Supervisor.start_link(children, opts)
    Scheduler.create_jobs()
    result
  end
end
