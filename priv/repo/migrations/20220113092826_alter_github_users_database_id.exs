defmodule Mage.Repo.Migrations.AlterGithubUsersDatabaseId do
  use Ecto.Migration

  def change do
    alter table("github_users") do
      modify :database_id_in_github, :"BIGINT UNSIGNED"
    end
  end
end
