defmodule Mage.RssFeeds.RssFeed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rss_feeds" do
    field :feed_url, :string
    field :first_entity_published_at, :utc_datetime
    field :first_entity_summary, :string
    field :first_entity_title, :string
    field :first_entity_url, :string
    field :last_error, :binary
    field :last_synced_at, :utc_datetime
    field :title, :string
    field :link_id, :id
    field :site_id, :id

    timestamps()
  end

  @doc false
  def changeset(rss_feed, attrs) do
    rss_feed
    |> cast(attrs, [
      :title,
      :feed_url,
      :last_synced_at,
      :last_error,
      :first_entity_title,
      :first_entity_summary,
      :first_entity_published_at
    ])
    |> validate_required([
      :feed_url
    ])
  end
end
