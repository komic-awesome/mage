defmodule Mage.GithubUsers do
  @moduledoc """
  The GithubUsers context.
  """

  import Ecto.Query, warn: false
  alias Mage.Repo

  alias Mage.GithubUsers.GithubUser
  alias Mage.Links
  alias Mage.Github.Helpers
  alias Mage.ContextHelpers

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

  def process_github_user(github_api_result) do
    id_in_github = github_api_result["id"]

    github_user =
      case Repo.get_by(GithubUser, id_in_github: id_in_github) do
        nil ->
          {:ok, github_user} = create_github_user(:github_api_result, github_api_result)
          github_user

        found ->
          {:ok, github_user} = update_github_user(:github_api_result, found, github_api_result)
          github_user
      end

    case github_user do
      %{avatar_url: nil} ->
        nil

      %{avatar_url: ""} ->
        nil

      %{avatar_url: avatar_url} ->
        case ContextHelpers.download_file(avatar_url, "avatars") do
          {:ok, avatar} ->
            update_github_user(github_user, %{avatar: avatar})

          _ ->
            nil
        end
    end

    case github_user do
      %{website_url: nil} ->
        nil

      %{website_url: website_url} ->
        case Links.sync_link(website_url) do
          {:ok, link} ->
            update_github_user(github_user, %{link_id: link.id})

          _ ->
            nil
        end
    end
  end

  defp create_github_user(:github_api_result, result) do
    create_github_user(%{
      "avatar_url" => result["avatarUrl"],
      "bio" => result["bio"],
      "bio_html" => result["bioHTML"],
      "company" => result["company"],
      "company_html" => result["companyHTML"],
      "database_id_in_github" => result["databaseId"],
      "email" => result["email"],
      "id_in_github" => result["id"],
      "location" => result["location"],
      "login" => result["login"],
      "name" => result["name"],
      "url" => result["url"],
      "website_url" => Helpers.link(result["websiteUrl"]),
      "last_synced_at" => DateTime.utc_now()
    })
  end

  defp update_github_user(:github_api_result, github_user, result) do
    update_github_user(github_user, %{
      "avatar_url" => result["avatarUrl"],
      "bio" => result["bio"],
      "bio_html" => result["bioHTML"],
      "company" => result["company"],
      "company_html" => result["companyHTML"],
      "database_id_in_github" => result["databaseId"],
      "email" => result["email"],
      "location" => result["location"],
      "login" => result["login"],
      "name" => result["name"],
      "url" => result["url"],
      "website_url" => Helpers.link(result["websiteUrl"]),
      "last_synced_at" => DateTime.utc_now()
    })
  end
end
