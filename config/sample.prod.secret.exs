use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :traceify, TraceifyWeb.Endpoint,
  secret_key_base: "rqFnyjbmRocU+Ec8XgFFPdgcZLxIGpgCP9NBymUwmDirK0mtqJu1dKRtIZX+pNPI"


config :traceify, Traceify.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "XXX",
  password: "XXX",
  database: "traceify_prod",
  hostname: "localhost",
  pool_size: 10
