use Mix.Config

config :core, Core.Repo,
  database: {:system, :string, "EVENT_MANAGER_DB_NAME"},
  username: {:system, :string, "EVENT_MANAGER_DB_USER"},
  password: {:system, :string, "EVENT_MANAGER_DB_PASSWORD"},
  hostname: {:system, :string, "EVENT_MANAGER_DB_HOST"},
  port: {:system, :integer, "EVENT_MANAGER_DB_PORT"},
  pool_size: {:system, :integer, "EVENT_MANAGER_DB_POOL_SIZE", 10},
  timeout: 15_000
