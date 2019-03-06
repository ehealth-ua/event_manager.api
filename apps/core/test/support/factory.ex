defmodule Core.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo
  use Core.EventFactory
end
