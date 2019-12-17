use Mix.Config

config :t, T.Repo,
  hostname: "localhost",
  port: 55433,
  database: "cti_t",
  username: "postgres",
  password: "postgres",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

import_config "github.exs"
