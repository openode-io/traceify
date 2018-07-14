use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :traceify, TraceifyWeb.Endpoint,
  http: [port: 4001],
  server: false

# Do not print debug messages in production
config :logger, level: :info

config :logger,
  backends: [{LoggerFileBackend, :info},
             {LoggerFileBackend, :error}]

config :logger, :info,
 path: "/var/log/traceify/info.log",
 level: :info

config :logger, :error,
 path: "/var/log/traceify/error.log",
 level: :error


# Configure your database
config :traceify, Traceify.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: System.get_env("DB_USER"),
  password: System.get_env("DB_PASSWORD"),
  database: "traceify_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
