defmodule Mage.GithubUsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mage.GithubUsers` context.
  """

  @doc """
  Generate a github_user.
  """
  def github_user_fixture(attrs \\ %{}) do
    {:ok, github_user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        bio: "some bio",
        bio_html: "some bio_html",
        company: "some company",
        company_html: "some company_html",
        database_id_in_github: "some database_id_in_github",
        email: "some email",
        id_in_github: "some id_in_github",
        location: "some location",
        login: "some login",
        name: "some name",
        url: "some url",
        website_url: "some website_url"
      })
      |> Mage.GithubUsers.create_github_user()

    github_user
  end

  @doc """
  Generate a github_user.
  """
  def github_user_fixture(attrs \\ %{}) do
    {:ok, github_user} =
      attrs
      |> Enum.into(%{
        avatar_url: "some avatar_url",
        bio: "some bio",
        bio_html: "some bio_html",
        company: "some company",
        company_html: "some company_html",
        database_id_in_github: "some database_id_in_github",
        email: "some email",
        id_in_github: "some id_in_github",
        last_synced_at: ~U[2022-01-12 08:35:00Z],
        location: "some location",
        login: "some login",
        name: "some name",
        url: "some url",
        website_url: "some website_url"
      })
      |> Mage.GithubUsers.create_github_user()

    github_user
  end
end
