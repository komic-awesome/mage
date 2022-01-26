defmodule Mage.Repo.Migrations.AddGithubUsersLinkId do
  use Ecto.Migration

  def change do
    alter table(:github_users) do
      add :link_id, references(:links, on_delete: :nothing)
    end
  end
end
