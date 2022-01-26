defmodule Mage.Repo.Migrations.LinksAddRssFeedId do
  use Ecto.Migration

  def change do
    alter table("links") do
      add :rss_feed_id, references(:rss_feeds, on_delete: :nothing)
    end
  end
end
