defmodule Mage.GithubUsers.SyncGithubUser do
  alias Mage.Repo
  alias Mage.GithubUsers
  alias Mage.GithubUsers.GithubUser
  alias Mage.ContextHelpers
  alias Mage.Links
  alias Mage.Github.Helpers

  def sync_github_user(github_api_result) do
    id_in_github = github_api_result["id"]
    github_user = Repo.get_by(GithubUser, id_in_github: id_in_github)

    case should_sync?(github_user) do
      true ->
        sync_github_user(:from_remote, github_api_result)

      false ->
        {:ok, github_user}
    end
  end

  @seconds_per_day 3600 * 24

  defp should_sync?(nil), do: true
  defp should_sync?(%GithubUser{last_synced_at: nil}), do: true

  defp should_sync?(github_user) do
    now = DateTime.utc_now()

    if DateTime.diff(now, github_user.last_synced_at) < @seconds_per_day do
      false
    else
      true
    end
  end

  defp sync_github_user(:from_remote, github_api_result) do
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
            GithubUsers.update_github_user(github_user, %{avatar: avatar})

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
            GithubUsers.update_github_user(github_user, %{link_id: link.id})

          _ ->
            nil
        end
    end
  end

  defp create_github_user(:github_api_result, result) do
    GithubUsers.create_github_user(%{
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
    GithubUsers.update_github_user(github_user, %{
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
