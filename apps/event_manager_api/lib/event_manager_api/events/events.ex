defmodule EventManagerApi.Events do
  @moduledoc false

  import Ecto.Changeset
  import Ecto.Query
  alias EventManagerApi.Repo
  alias EventManagerApi.Events.Event
  alias EventManagerApi.Events.Search

  def list(params) do
    with %Ecto.Changeset{valid?: true, changes: changes} <- changeset(%Search{}, params) do
      Event
      |> where([e], e.event_type == ^Event.type(:change_status))
      |> add_date_query(changes)
      |> add_previous_status_query(changes)
      |> add_new_status_query(changes)
      |> Repo.paginate(params)
    end
  end

  def get_by_id!(id) do
    with {:ok, _} <- Ecto.Type.cast(:id, id) do
      Repo.get!(Event, id)
    else
      _ -> nil
    end
  end

  defp changeset(%Search{} = search, params) do
    {search, %{
      date: :date,
      previous_status: :string,
      new_status: :string
    }}
    |> cast(params, search |> Map.from_struct() |> Map.keys())
  end

  defp add_date_query(query, %{date: date}) do
    where(query, [e], fragment("?::date = ?", e.event_time, ^date))
  end
  defp add_date_query(query, _), do: query

  defp add_previous_status_query(query, %{previous_status: status}) do
    where(query, [e], fragment("?->>'previous_status' = ?", e.properties, ^status))
  end
  defp add_previous_status_query(query, _), do: query

  defp add_new_status_query(query, %{new_status: status}) do
    where(query, [e], fragment("?->>'new_status' = ?", e.properties, ^status))
  end
  defp add_new_status_query(query, _), do: query
end
