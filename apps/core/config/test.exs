use Mix.Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "event_manager_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  ownership_timeout: 120_000_000

# Print only warnings and errors during test
config :logger, level: :warn
