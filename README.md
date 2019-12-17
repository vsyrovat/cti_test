**Installation**

1. In folder `config` copy file `github.exs.dist` to `github.exs` and specify your Github token or set to `nil` if no exists.
2. Other standard steps (like `mix deps.get` etc...)
3. Ensure your system have Docker and Docker Compose installed, then run `./env-up.sh`.


**Purposed functions**

1. `T.Cartesian.product/2`
2. `T.GithubRepo.stars/1`
3. `T.Ecto.special_grouped/0`, `T.Ecto.special_grouped_2/0`


**Running tests**

`mix test`
