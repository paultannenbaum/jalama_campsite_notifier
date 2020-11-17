# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :logger, :console, format: "$time $metadata[$level] $message\n"

config :phoenix, :json_library, Jason

config :sendgrid, api_key: {:system, "SENDGRID_API_KEY"}

config :jalama_scrapper,
       JalamaScrapper.Scheduler,
       timezone: "America/Los_Angeles",
       jobs: [{"0 0 * * *", fn -> JalamaScrapper.Job.perform(5) end}],
       debug_logging: false

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"


