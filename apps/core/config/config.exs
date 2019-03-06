use Mix.Config

config :core, ecto_repos: [Core.Repo]
config :ecto_trail, table_name: "audit_log"

config :core, Core.Scheduler,
  events_termination: {:system, :string, "EVENTS_TERMINATION_SCHEDULE", "* 0-4 * * *"},
  max_events: {:system, :integer, "MAX_EVENTS", 10_000},
  events_expiration: {:system, :integer, "EVENTS_EXPIRATION", 30}

config :logger_json, :backend,
  formatter: EhealthLogger.Formatter,
  metadata: :all

config :logger,
  backends: [LoggerJSON],
  level: :info

import_config "#{Mix.env()}.exs"
