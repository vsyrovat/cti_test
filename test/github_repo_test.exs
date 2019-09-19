defmodule T.GithubRepoTest do
  use ExUnit.Case
  import Tesla.Mock

  test "retrieve public repo" do
    mock(fn
      %{method: :get, url: "https://api.github.com/repos/foo/bar"} ->
        %Tesla.Env{
          status: 200,
          body: %{"stargazers_count" => 10},
          headers: [
            {"x-ratelimit-limit", "60"},
            {"x-ratelimit-remaining", "11"},
            {"x-ratelimit-reset", "1563085238"}
          ]
        }
    end)

    assert T.GithubRepo.stars("foo/bar") == {:ok, 10}
  end

  test "retrieve private repo" do
    mock(fn
      %{method: :get, url: "https://api.github.com/repos/private/private"} ->
        %Tesla.Env{
          status: 404,
          body: %{},
          headers: []
        }
    end)

    assert T.GithubRepo.stars("private/private") == {:error, "Repo is private or not exists"}
  end

  test "incorrect argument" do
    assert_raise ArgumentError, "Argument should match the pattern \"{user}/{repo}\"", fn ->
      T.GithubRepo.stars("foobar")
    end
  end
end
