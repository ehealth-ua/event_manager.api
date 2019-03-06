defmodule EventManager.FallbackController do
  @moduledoc """
  This controller should be used as `action_fallback` in rest of controllers to remove duplicated error handling.
  """
  use EventManager.Web, :controller

  alias EView.Views.Error
  alias EView.Views.ValidationError
  require Logger

  def call(conn, %Ecto.Changeset{valid?: false} = changeset) do
    call(conn, {:error, changeset})
  end

  def call(conn, {:error, %Ecto.Changeset{valid?: false} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(ValidationError)
    |> render(:"422", changeset)
  end

  def call(conn, nil) do
    conn
    |> put_status(:not_found)
    |> put_view(Error)
    |> render(:"404")
  end

  def call(conn, params) do
    Logger.error(fn ->
      Poison.encode!(%{
        "log_type" => "error",
        "message" =>
          "No function clause matching in EHealth.Web.FallbackController.call/2: #{
            inspect(params)
          }",
        "request_id" => Logger.metadata()[:request_id]
      })
    end)

    conn
    |> put_status(:not_implemented)
    |> put_view(Error)
    |> render(:"501")
  end
end
