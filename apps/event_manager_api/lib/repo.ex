defmodule EventManagerApi.Repo do
  use Ecto.Repo, otp_app: :event_manager_api
  use EctoTrail
  use Scrivener, page_size: 10
end
