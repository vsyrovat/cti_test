use Mix.Config

config :tesla, adapter: Tesla.Mock

config :t, T.Repo,
  hostname: "localhost",
  port: 55433,
  database: "cti_t_test",
  username: "postgres",
  password: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
