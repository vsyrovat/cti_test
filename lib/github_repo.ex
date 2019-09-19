defmodule T.GithubRepo do
  @moduledoc """
  Retrieve stars count of given Github repo.

  Specify your Github token in config/github.exs
  """

  use Tesla

  plug(Tesla.Middleware.BaseUrl, "https://api.github.com")
  plug(Tesla.Middleware.Headers, headers())
  plug(Tesla.Middleware.JSON)

  defp headers do
    default = [{"User-Agent", "Tesla"}]

    case token = Application.get_env(:t, :github_api_token) do
      nil -> default
      _ -> default ++ [{"Authorization", "token #{token}"}]
    end
  end

  @spec stars(String.t()) :: {:ok, integer()} | {:error, String.t()}
  def stars(repo) when is_binary(repo) do
    unless String.match?(repo, ~r|[^/]+/[^/]+|),
      do: raise(ArgumentError, message: "Argument should match the pattern \"{user}/{repo}\"")

    {:ok, res} = get("/repos/#{repo}")

    case res do
      %Tesla.Env{status: 200} ->
        {:ok, stars_count(res)}

      %Tesla.Env{status: 404} ->
        {:error, "Repo is private or not exists"}

      %Tesla.Env{status: status} when status >= 500 ->
        {:error, :server, status, res.body["message"]}

      %Tesla.Env{status: status} when status >= 400 ->
        {:error, :client, status, res.body["message"], limits(res)}

      %Tesla.Env{status: status} ->
        {:error, :unknown, status}
    end
  end

  defp stars_count(%Tesla.Env{status: 200, body: body}) do
    body["stargazers_count"]
  end

  defp limits(%Tesla.Env{headers: headers}) do
    headers = Enum.into(headers, %{})

    {limit, ""} = Integer.parse(headers["x-ratelimit-limit"])
    {remain, ""} = Integer.parse(headers["x-ratelimit-remaining"])
    {reset_at_unix, ""} = Integer.parse(headers["x-ratelimit-reset"])
    reset_at = DateTime.from_unix!(reset_at_unix)
    %{limit: limit, remain: remain, reset_at: reset_at}
  end
end
