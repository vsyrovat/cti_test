defmodule T.EctoTest do
  use T.Support.DataCase
  alias T.Repo
  alias T.User
  alias T.Post
  import T.Ecto
  
  def user_fixture(id) do
    Repo.insert(%User{id: id})
  end
  
  def post_fixture(user_id, category) do
    Repo.insert(%Post{user_id: user_id, category: category})
  end
  
  setup do
    user_fixture(1)
    post_fixture(1, "link")
    post_fixture(1, "link")
    post_fixture(1, "article")
    post_fixture(1, "article")
    post_fixture(1, "article")
    post_fixture(1, "promotion")
    post_fixture(1, "promotion")
    post_fixture(1, "promotion")
    post_fixture(1, "promotion")
    
    user_fixture(2)
    post_fixture(2, "link")
    post_fixture(2, "link")
    post_fixture(2, "link")
    post_fixture(2, "article")
    post_fixture(2, "article")
    post_fixture(2, "article")
    post_fixture(2, "article")
    
    :ok
  end
  
  @expectation [
    %{user_id: 1, link_count: 2, article_count: 3, promotion_count: 4},
    %{user_id: 2, link_count: 3, article_count: 4, promotion_count: 0}
  ]
  
  test "ecto query correctness" do
    assert special_grouped() == @expectation
  end
end
