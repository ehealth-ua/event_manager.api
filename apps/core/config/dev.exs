use Mix.Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "event_manager",
  hostname: "localhost",
  pool_size: 10
