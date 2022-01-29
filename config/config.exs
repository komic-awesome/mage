# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :mage,
  ecto_repos: [Mage.Repo]

# Configures the endpoint
config :mage, MageWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: MageWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mage.PubSub,
  live_view: [signing_salt: "gZhNIwPZ"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :mage, Mage.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :mage, :pow,
  user: Mage.Users.User,
  repo: Mage.Repo,
  controller_callbacks: MageWeb.Pow.ControllerCallbacks,
  cache_store_backend: Pow.Store.Backend.EtsCache

config :mage, :pow_assent,
  providers: [
    github: [
      client_id: "4fc1d5cf9a8ed2000dcf",
      client_secret: System.get_env("GITHUB_CLIENT_SECRET"),
      strategy: Assent.Strategy.Github
    ]
  ]

config :mime, :types, %{
  "image/x-icon" => ["ico"]
}

config :tailwind,
  version: "3.0.7",
  default: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),
    cd: Path.expand("../assets", __DIR__)
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
