defmodule Mage.Repo.Migrations.GithubUsersAddAvatarColumn do
  use Ecto.Migration

  def change do
    alter table(:github_users) do
      add :avatar, :map
    end
  end
end
