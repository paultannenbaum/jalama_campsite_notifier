defmodule JalamaScrapper.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      JalamaScrapper.Repo,
      # Start the Telemetry supervisor
      JalamaScrapperWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: JalamaScrapper.PubSub},
      # Start the Endpoint (http/https)
      JalamaScrapperWeb.Endpoint
      # Start a worker by calling: JalamaScrapper.Worker.start_link(arg)
      # {JalamaScrapper.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: JalamaScrapper.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    JalamaScrapperWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
