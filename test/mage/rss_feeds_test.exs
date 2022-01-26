defmodule Mage.RssFeedsTest do
  use Mage.DataCase

  alias Mage.RssFeeds

  describe "rss_feeds" do
    alias Mage.RssFeeds.RssFeed

    import Mage.RssFeedsFixtures

    @invalid_attrs %{
      feed_url: nil,
      first_entity_published_at: nil,
      first_entity_summary: nil,
      first_entity_title: nil,
      last_error: nil,
      last_synced_at: nil,
      title: nil
    }

    test "list_rss_feeds/0 returns all rss_feeds" do
      rss_feed = rss_feed_fixture()
      assert RssFeeds.list_rss_feeds() == [rss_feed]
    end

    test "get_rss_feed!/1 returns the rss_feed with given id" do
      rss_feed = rss_feed_fixture()
      assert RssFeeds.get_rss_feed!(rss_feed.id) == rss_feed
    end

    test "create_rss_feed/1 with valid data creates a rss_feed" do
      valid_attrs = %{
        feed_url: "some feed_url",
        first_entity_published_at: ~U[2022-01-12 09:05:00Z],
        first_entity_summary: "some first_entity_summary",
        first_entity_title: "some first_entity_title",
        last_error: "some last_error",
        last_synced_at: ~U[2022-01-12 09:05:00Z],
        title: "some title"
      }

      assert {:ok, %RssFeed{} = rss_feed} = RssFeeds.create_rss_feed(valid_attrs)
      assert rss_feed.feed_url == "some feed_url"
      assert rss_feed.first_entity_published_at == ~U[2022-01-12 09:05:00Z]
      assert rss_feed.first_entity_summary == "some first_entity_summary"
      assert rss_feed.first_entity_title == "some first_entity_title"
      assert rss_feed.last_error == "some last_error"
      assert rss_feed.last_synced_at == ~U[2022-01-12 09:05:00Z]
      assert rss_feed.title == "some title"
    end

    test "create_rss_feed/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = RssFeeds.create_rss_feed(@invalid_attrs)
    end

    test "update_rss_feed/2 with valid data updates the rss_feed" do
      rss_feed = rss_feed_fixture()

      update_attrs = %{
        feed_url: "some updated feed_url",
        first_entity_published_at: ~U[2022-01-13 09:05:00Z],
        first_entity_summary: "some updated first_entity_summary",
        first_entity_title: "some updated first_entity_title",
        last_error: "some updated last_error",
        last_synced_at: ~U[2022-01-13 09:05:00Z],
        title: "some updated title"
      }

      assert {:ok, %RssFeed{} = rss_feed} = RssFeeds.update_rss_feed(rss_feed, update_attrs)
      assert rss_feed.feed_url == "some updated feed_url"
      assert rss_feed.first_entity_published_at == ~U[2022-01-13 09:05:00Z]
      assert rss_feed.first_entity_summary == "some updated first_entity_summary"
      assert rss_feed.first_entity_title == "some updated first_entity_title"
      assert rss_feed.last_error == "some updated last_error"
      assert rss_feed.last_synced_at == ~U[2022-01-13 09:05:00Z]
      assert rss_feed.title == "some updated title"
    end

    test "update_rss_feed/2 with invalid data returns error changeset" do
      rss_feed = rss_feed_fixture()
      assert {:error, %Ecto.Changeset{}} = RssFeeds.update_rss_feed(rss_feed, @invalid_attrs)
      assert rss_feed == RssFeeds.get_rss_feed!(rss_feed.id)
    end

    test "delete_rss_feed/1 deletes the rss_feed" do
      rss_feed = rss_feed_fixture()
      assert {:ok, %RssFeed{}} = RssFeeds.delete_rss_feed(rss_feed)
      assert_raise Ecto.NoResultsError, fn -> RssFeeds.get_rss_feed!(rss_feed.id) end
    end

    test "change_rss_feed/1 returns a rss_feed changeset" do
      rss_feed = rss_feed_fixture()
      assert %Ecto.Changeset{} = RssFeeds.change_rss_feed(rss_feed)
    end
  end
end
