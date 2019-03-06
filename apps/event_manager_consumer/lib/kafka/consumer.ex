defmodule EventManagerConsumer.Kafka.Consumer do
  @moduledoc false

  alias Core.Events.Event
  alias Core.Repo
  alias Ecto.Changeset
  require Logger

  def handle_message(%{offset: offset, value: value}) do
    value = :erlang.binary_to_term(value)
    Logger.debug(fn -> "message: " <> inspect(value) end)
    Logger.info(fn -> "offset: #{offset}" end)
    consume(value)
    :ok
  end

  def consume(%{} = event) do
    %Event{}
    |> Event.changeset(event)
    |> store_event()
  end

  def consume(value),
    do: Logger.warn(fn -> "Kafka message cannot be processed: #{inspect(value)}" end)

  defp store_event(%Changeset{valid?: true} = changeset), do: Repo.insert!(changeset)

  defp store_event(invalid_changeset),
    do: Logger.warn(fn -> "Invalid event changeset: #{inspect(invalid_changeset)}" end)
end
