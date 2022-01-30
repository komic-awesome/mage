defmodule Mage.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Mage.Repo

  alias Mage.Accounts.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def update_followers(user_id, github_users) do
    get_user!(user_id)
    |> Repo.preload(:followers)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:followers, github_users)
    |> Repo.update()
  end

  def update_followings(user_id, github_users) do
    get_user!(user_id)
    |> Repo.preload(:followings)
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:followings, github_users)
    |> Repo.update()
  end

  def list_followers(user_id) do
    with %User{} = user <- Repo.get(User, user_id),
         %{followers: followers} <-
           user
           |> Repo.preload(followers: [link: :site, link: :rss_feed]) do
      followers
      |> Enum.filter(&(!is_nil(&1.link)))
    else
      _any -> []
    end
  end
end
