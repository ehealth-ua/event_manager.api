defmodule EventManagerApi.Events do
  @moduledoc false

  import Ecto.Changeset
  import Ecto.Query
  alias EventManagerApi.Repo
  alias EventManagerApi.Events.Event
  alias EventManagerApi.Events.Search
  alias Ecto.Type

  def list(params) do
    with %Ecto.Changeset{valid?: true, changes: changes} <- changeset(%Search{}, params) do
      Event
      |> where([e], e.event_type == ^Event.type(:change_status))
      |> add_date_query(changes)
      |> add_new_status_query(changes)
      |> Repo.paginate(params)
    end
  end

  def get_by_id!(id) do
    with {:ok, _} <- Type.cast(:id, id) do
      Repo.get!(Event, id)
    else
      _ -> nil
    end
  end

  def delete_events(max_events, expiration) do
    event =
      Event
      |> order_by([e], desc: e.id)
      |> offset(^max_events)
      |> limit(1)
      |> Repo.one

    unless is_nil(event) do
      event_id = event.id
      Event
      |> where([e], e.id <= ^event_id)
      |> Repo.delete_all
    end

    date = Date.utc_today() |> Date.add(-expiration)
    Event
    |> where([e], fragment("?::date <= ?", e.inserted_at, ^date))
    |> Repo.delete_all
  end

  defp changeset(%Search{} = search, params) do
    {search, %{
      date: :date,
      new_status: :string
    }}
    |> cast(params, search |> Map.from_struct() |> Map.keys())
  end

  defp add_date_query(query, %{date: date}) do
    where(query, [e], fragment("?::date = ?", e.event_time, ^date))
  end
  defp add_date_query(query, _), do: query

  defp add_new_status_query(query, %{new_status: status}) do
    where(query, [e], fragment("?->>'new_status' = ?", e.properties, ^status))
  end
  defp add_new_status_query(query, _), do: query
end
