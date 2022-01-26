defmodule Mage.Repo.Migrations.CreateGithubUsers do
  use Ecto.Migration

  def change do
    create table(:github_users) do
      add :id_in_github, :string
      add :name, :string
      add :login, :string
      add :email, :string
      add :location, :string
      add :website_url, :string
      add :url, :string
      add :company, :text
      add :company_html, :text
      add :database_id_in_github, :string
      add :avatar_url, :string
      add :bio, :text
      add :bio_html, :text
      add :last_synced_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:github_users, [:user_id])
  end
end
