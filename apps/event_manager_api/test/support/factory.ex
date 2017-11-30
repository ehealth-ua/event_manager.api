defmodule EventManagerApi.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: EventManagerApi.Repo
  use EventManagerApi.EventFactory
end
