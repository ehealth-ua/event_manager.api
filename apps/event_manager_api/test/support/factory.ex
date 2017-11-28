defmodule EventManagerApi.Factory do
  use ExMachina.Ecto, repo: EventManagerApi.Repo
  use EventManagerApi.EventFactory
end
