defmodule Mage.RssFeedsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mage.RssFeeds` context.
  """

  @doc """
  Generate a rss_feed.
  """
  def rss_feed_fixture(attrs \\ %{}) do
    {:ok, rss_feed} =
      attrs
      |> Enum.into(%{
        feed_url: "some feed_url",
        first_entity_published_at: ~U[2022-01-12 09:05:00Z],
        first_entity_summary: "some first_entity_summary",
        first_entity_title: "some first_entity_title",
        last_error: "some last_error",
        last_synced_at: ~U[2022-01-12 09:05:00Z],
        title: "some title"
      })
      |> Mage.RssFeeds.create_rss_feed()

    rss_feed
  end
end
