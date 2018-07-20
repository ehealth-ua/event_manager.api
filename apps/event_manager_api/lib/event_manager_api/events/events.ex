defmodule EventManagerApi.Events do
  @moduledoc false

  import Ecto.Changeset
  import Ecto.Query
  alias Ecto.UUID
  alias EventManagerApi.Events.Event
  alias EventManagerApi.Events.Search
  alias EventManagerApi.Repo

  def list(params) do
    with %Ecto.Changeset{valid?: true, changes: changes} <- changeset(%Search{}, params) do
      Event
      |> add_date_query(changes)
      |> add_field_query(:event_type, Map.get(changes, :event_type))
      |> add_field_query(:entity_type, Map.get(changes, :entity_type))
      |> add_new_value_query(changes)
      |> Repo.paginate(params)
    end
  end

  def get_by_id!(id) do
    with {:ok, _} <- UUID.dump(id) do
      Repo.get!(Event, id)
    else
      _ -> nil
    end
  end

  def delete_events(max_events, expiration) do
    event =
      Event
      |> order_by([e], desc: e.inserted_at)
      |> offset(^max_events)
      |> limit(1)
      |> Repo.one()

    unless is_nil(event) do
      inserted_at = event.inserted_at

      Event
      |> where([e], e.inserted_at <= ^inserted_at)
      |> Repo.delete_all()
    end

    date = Date.utc_today() |> Date.add(-expiration)

    Event
    |> where([e], fragment("?::date <= ?", e.inserted_at, ^date))
    |> Repo.delete_all()
  end

  defp changeset(%Search{} = search, params) do
    {search,
     %{
       date: :naive_datetime,
       attribute_name: :string,
       new_value: :string,
       event_type: :string,
       entity_type: :string
     }}
    |> cast(params, search |> Map.from_struct() |> Map.keys())
    |> validate_name_value()
  end

  defp validate_name_value(%Ecto.Changeset{valid?: true} = changeset) do
    if !is_nil(get_change(changeset, :new_value)) &&
         is_nil(get_change(changeset, :attribute_name)) do
      add_error(changeset, :attribute_name, "must be set")
    else
      changeset
    end
  end

  defp validate_name_value(changeset), do: changeset

  defp add_date_query(query, %{date: date}) do
    where(query, [e], fragment("? >= ?", e.event_time, ^date))
  end

  defp add_date_query(query, _), do: query

  defp add_new_value_query(query, %{attribute_name: name, new_value: value}) do
    where(query, [e], fragment("?->?->>'new_value' = ?", e.properties, ^name, ^value))
  end

  defp add_new_value_query(query, %{attribute_name: name}) do
    where(query, [e], fragment("?->>? IS NOT NULL", e.properties, ^name))
  end

  defp add_new_value_query(query, _), do: query

  defp add_field_query(query, _, nil), do: query

  defp add_field_query(query, field, value) do
    where(query, [e], field(e, ^field) == ^value)
  end
end
