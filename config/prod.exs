use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

config :sendgrid, api_key: {:system, "SENDGRID_API_KEY"}
