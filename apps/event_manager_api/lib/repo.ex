defmodule EventManagerApi.Repo do
  use Ecto.Repo, otp_app: :event_manager_api
  use EctoTrail
end
