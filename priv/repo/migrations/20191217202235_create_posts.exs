defmodule T.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :user_id, references(:users)
      add :category, :string
      
      timestamps()
    end
    
    create index(:posts, [:user_id])
  end
end
