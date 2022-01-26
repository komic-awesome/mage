defmodule Mage.GithubUsers do
  @moduledoc """
  The GithubUsers context.
  """

  import Ecto.Query, warn: false
  alias Mage.Repo

  alias Mage.GithubUsers.GithubUser

  @doc """
  Returns the list of github_users.

  ## Examples

      iex> list_github_users()
      [%GithubUser{}, ...]

  """
  def list_github_users do
    Repo.all(GithubUser)
  end

  @doc """
  Gets a single github_user.

  Raises `Ecto.NoResultsError` if the Github user does not exist.

  ## Examples

      iex> get_github_user!(123)
      %GithubUser{}

      iex> get_github_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_github_user!(id), do: Repo.get!(GithubUser, id)

  @doc """
  Creates a github_user.

  ## Examples

      iex> create_github_user(%{field: value})
      {:ok, %GithubUser{}}

      iex> create_github_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_github_user(attrs \\ %{}) do
    %GithubUser{}
    |> GithubUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a github_user.

  ## Examples

      iex> update_github_user(github_user, %{field: new_value})
      {:ok, %GithubUser{}}

      iex> update_github_user(github_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_github_user(%GithubUser{} = github_user, attrs) do
    github_user
    |> GithubUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a github_user.

  ## Examples

      iex> delete_github_user(github_user)
      {:ok, %GithubUser{}}

      iex> delete_github_user(github_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_github_user(%GithubUser{} = github_user) do
    Repo.delete(github_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking github_user changes.

  ## Examples

      iex> change_github_user(github_user)
      %Ecto.Changeset{data: %GithubUser{}}

  """
  def change_github_user(%GithubUser{} = github_user, attrs \\ %{}) do
    GithubUser.changeset(github_user, attrs)
  end
end
