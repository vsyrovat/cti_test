use Mix.Config

config :t,
  ecto_repos: [T.Repo]

import_config "#{Mix.env()}.exs"
