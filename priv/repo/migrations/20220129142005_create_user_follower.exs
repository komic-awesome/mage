defmodule Mage.Repo.Migrations.CreateUserFollower do
  use Ecto.Migration

  def change do
    create table(:user_follower) do
      add :user_id, references(:users)
      add :github_user_id, references(:github_users)
    end

    create unique_index(:user_follower, [:user_id, :github_user_id])
  end
end
