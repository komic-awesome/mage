defmodule Mage.Repo.Migrations.CreateUserFolloing do
  use Ecto.Migration

  def change do
    create table(:user_following) do
      add :user_id, references(:users)
      add :github_user_id, references(:github_users)
    end

    create unique_index(:user_following, [:user_id, :github_user_id])
  end
end
