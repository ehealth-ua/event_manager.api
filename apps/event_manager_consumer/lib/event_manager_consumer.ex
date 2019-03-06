defmodule EventManagerConsumer do
  @moduledoc """
  Documentation for EventManagerConsumer.
  """

  use Application
  alias Core.EventManagerRepo
  alias Kaffe.Consumer

  def start(_type, _args) do
    Application.put_env(:kaffe, :consumer, Application.get_env(:event_manager, :kaffe_consumer))

    children = [
      {EventManagerRepo, []},
      {Consumer, []}
    ]

    opts = [strategy: :one_for_one, name: EventManagerConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
