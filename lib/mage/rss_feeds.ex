defmodule Mage.RssFeeds do
  @moduledoc """
  The RssFeeds context.
  """

  import Ecto.Query, warn: false
  alias Mage.Repo

  alias Mage.RssFeeds.RssFeed
  alias Mage.RssFeeds.SyncRssFeed

  @doc """
  Returns the list of rss_feeds.

  ## Examples

      iex> list_rss_feeds()
      [%RssFeed{}, ...]

  """
  def list_rss_feeds do
    Repo.all(RssFeed)
  end

  @doc """
  Gets a single rss_feed.

  Raises `Ecto.NoResultsError` if the Rss feed does not exist.

  ## Examples

      iex> get_rss_feed!(123)
      %RssFeed{}

      iex> get_rss_feed!(456)
      ** (Ecto.NoResultsError)

  """
  def get_rss_feed!(id), do: Repo.get!(RssFeed, id)

  @doc """
  Creates a rss_feed.

  ## Examples

      iex> create_rss_feed(%{field: value})
      {:ok, %RssFeed{}}

      iex> create_rss_feed(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_rss_feed(attrs \\ %{}) do
    %RssFeed{}
    |> RssFeed.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a rss_feed.

  ## Examples

      iex> update_rss_feed(rss_feed, %{field: new_value})
      {:ok, %RssFeed{}}

      iex> update_rss_feed(rss_feed, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_rss_feed(%RssFeed{} = rss_feed, attrs) do
    rss_feed
    |> RssFeed.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a rss_feed.

  ## Examples

      iex> delete_rss_feed(rss_feed)
      {:ok, %RssFeed{}}

      iex> delete_rss_feed(rss_feed)
      {:error, %Ecto.Changeset{}}

  """
  def delete_rss_feed(%RssFeed{} = rss_feed) do
    Repo.delete(rss_feed)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking rss_feed changes.

  ## Examples

      iex> change_rss_feed(rss_feed)
      %Ecto.Changeset{data: %RssFeed{}}

  """
  def change_rss_feed(%RssFeed{} = rss_feed, attrs \\ %{}) do
    RssFeed.changeset(rss_feed, attrs)
  end

  def update_or_create_rss_feed(queryable, changeset) do
    case Repo.get_by(RssFeed, queryable) do
      nil -> %RssFeed{}
      model -> model
    end
    |> RssFeed.changeset(Map.merge(queryable, changeset))
    |> Repo.insert_or_update()
  end

  def sync_rss_feed(link_url, link_body_html) do
    SyncRssFeed.sync_rss_feed(link_url, link_body_html)
  end
end
