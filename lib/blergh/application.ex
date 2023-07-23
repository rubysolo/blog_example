defmodule Blergh.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      BlerghWeb.Telemetry,
      # Start the Ecto repository
      Blergh.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Blergh.PubSub},
      # Start Finch
      {Finch, name: Blergh.Finch},
      # Start the Endpoint (http/https)
      BlerghWeb.Endpoint
      # Start a worker by calling: Blergh.Worker.start_link(arg)
      # {Blergh.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Blergh.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BlerghWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
