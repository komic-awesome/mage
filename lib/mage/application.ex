defmodule Mage.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  defp poolboy_config do
    [
      name: {:local, :github_user_worker},
      worker_module: Mage.GithubUserWorker,
      size: 6,
      max_overflow: 2
    ]
  end

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Mage.Repo,
      # Start the Telemetry supervisor
      MageWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Mage.PubSub},
      # Start the Endpoint (http/https)
      # Start a worker by calling: Mage.Worker.start_link(arg)
      # {Mage.Worker, arg}
      #
      :poolboy.child_spec(:github_user_worker, poolboy_config()),
      {
        Task.Supervisor,
        name: :github_user_task_sup
      },
      {
        Task.Supervisor,
        name: :sync_job_sup
      },
      {
        Mage.SyncJobs.Monitor,
        name: Mage.SyncJobs.Monitor
      },
      MageWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mage.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MageWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
