# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :jalama_scrapper,
  ecto_repos: [JalamaScrapper.Repo]

# Configures the endpoint
config :jalama_scrapper, JalamaScrapperWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xPLbzO7GmR1evLPonjSHysXAIbAif8pKPMpD7G2vS1vdp83IibuWmLIUdEMlpVaD",
  render_errors: [view: JalamaScrapperWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: JalamaScrapper.PubSub,
  live_view: [signing_salt: "OG9P+2bu"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
