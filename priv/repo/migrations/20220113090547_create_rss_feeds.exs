defmodule Mage.Repo.Migrations.CreateRssFeeds do
  use Ecto.Migration

  def change do
    create table(:rss_feeds) do
      add :title, :string
      add :feed_url, :string
      add :last_synced_at, :utc_datetime
      add :last_error, :binary
      add :first_entity_title, :string
      add :first_entity_summary, :text
      add :first_entity_published_at, :utc_datetime
      add :link_id, references(:links, on_delete: :nothing)
      add :site_id, references(:sites, on_delete: :nothing)

      timestamps()
    end

    create index(:rss_feeds, [:link_id])
    create index(:rss_feeds, [:site_id])
  end
end
