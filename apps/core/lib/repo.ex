defmodule Core.Repo do
  @moduledoc false

  use Ecto.Repo, otp_app: :core, adapter: Ecto.Adapters.Postgres
  use EctoTrail
  use Scrivener, page_size: 10
end
