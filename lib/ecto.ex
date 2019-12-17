defmodule T.Repo do
  use Ecto.Repo,
    otp_app: :t,
    adapter: Ecto.Adapters.Postgres
end

defmodule T.User do
  use Ecto.Schema
  
  schema "users" do
    timestamps()
  end
end

defmodule T.Post do
  use Ecto.Schema
  
  schema "posts" do
    belongs_to :user, T.User
    field :category, :string
    timestamps()
  end
end

defmodule T.Ecto do
  alias T.{Repo, User, Post}
  import Ecto.Query
  import Ecto.Query.API
  
  def special_grouped do
    query = from p in Post,
      group_by: [p.user_id, p.category],
      select: {p.user_id, p.category, count(p.id)}
    
    rows = Repo.all(query)
    
    Enum.reduce(rows, %{}, fn row, acc -> 
      {user_id, category, count} = row
      acc_cell = case Map.get(acc, user_id) do
        nil -> %{user_id: user_id, link_count: 0, article_count: 0, promotion_count: 0}
        cell -> cell
      end
      acc_put = Map.put(acc_cell, String.to_existing_atom("#{category}_count"), count)
      Map.put(acc, user_id, acc_put)
    end)
    |> Map.values()
  end
  
  def special_grouped_2 do
    query = from p in Post,
      group_by: [p.user_id],
      select: {
        p.user_id,
        fragment("SUM(CASE WHEN ? = ? THEN 1 ELSE 0 END)", p.category, "link"),
        fragment("SUM(CASE WHEN ? = ? THEN 1 ELSE 0 END)", p.category, "article"),
        fragment("SUM(CASE WHEN ? = ? THEN 1 ELSE 0 END)", p.category, "promotion")
      },
      order_by: [asc: p.user_id]
     
    Repo.all(query)
    |> Enum.map(fn row -> 
      {a, b, c, d} = row
      %{user_id: a, link_count: b, article_count: c, promotion_count: d}
    end)
  end
end
