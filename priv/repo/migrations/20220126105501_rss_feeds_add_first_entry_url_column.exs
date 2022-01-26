defmodule Mage.Repo.Migrations.RssFeedsAddFirstEntryUrlColumn do
  use Ecto.Migration

  def change do
    alter table(:rss_feeds) do
      add :first_entity_url, :string, size: 2048
    end
  end
end
