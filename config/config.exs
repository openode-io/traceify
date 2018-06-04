# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

required_env_variables = ["CURRENT_HOST", "DB_USER", "DB_PASSWORD", "HTTP_PORT", "HTTPS_PORT"]

for var <- required_env_variables do
  unless System.get_env(var) do
    raise "No variable #{var} found in config"
  end
end

# General application configuration
config :traceify,
  ecto_repos: [Traceify.Repo]

# Configures the endpoint
config :traceify, TraceifyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "BfRwW98jd9jtM3oO+t9NiMSz2u3vyc40RJgDPzBku5lNshwrHbVubfd9AI/RciX+",
  render_errors: [view: TraceifyWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Traceify.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
