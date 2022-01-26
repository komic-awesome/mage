defmodule Mage.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mage.Sites.Site
  alias Mage.RssFeeds.RssFeed

  schema "links" do
    field :last_synced_at, :utc_datetime
    field :status_code, :integer
    field :title, :string
    field :url, :string
    belongs_to :site, Site
    belongs_to :rss_feed, RssFeed

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title, :status_code, :last_synced_at, :site_id, :rss_feed_id])
    |> validate_required([:url, :title, :status_code, :last_synced_at])
  end
end
