# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :event_manager, EventManager.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "J1OsOdnG02lpUx+Picoqt7ABDpH780UVmWlWwFpUOcgU5EiKglKuN8dnOZjz51z2",
  render_errors: [view: EView.Views.PhoenixError, accepts: ~w(json)],
  instrumenters: [LoggerJSON.Phoenix.Instruments]

config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
