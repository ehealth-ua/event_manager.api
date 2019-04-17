defmodule EventManagerConsumer do
  @moduledoc """
  Documentation for EventManagerConsumer.
  """

  use Application
  alias Kaffe.Consumer

  def start(_type, _args) do
    Application.put_env(:kaffe, :consumer, Application.get_env(:event_manager_consumer, :kaffe_consumer))
    children = [%{id: Consumer, start: {Consumer, :start_link, []}}]
    opts = [strategy: :one_for_one, name: EventManagerConsumer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
