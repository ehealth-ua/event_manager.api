use Mix.Config

config :event_manager_api, EventManagerApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "event_manager",
  hostname: "localhost",
  pool_size: 10
