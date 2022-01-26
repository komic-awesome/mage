defmodule Mage.GithubUsersTest do
  use Mage.DataCase

  alias Mage.GithubUsers

  describe "github_users" do
    alias Mage.GithubUsers.GithubUser

    import Mage.GithubUsersFixtures

    @invalid_attrs %{
      avatar_url: nil,
      bio: nil,
      bio_html: nil,
      company: nil,
      company_html: nil,
      database_id_in_github: nil,
      email: nil,
      id_in_github: nil,
      location: nil,
      login: nil,
      name: nil,
      url: nil,
      website_url: nil
    }

    test "list_github_users/0 returns all github_users" do
      github_user = github_user_fixture()
      assert GithubUsers.list_github_users() == [github_user]
    end

    test "get_github_user!/1 returns the github_user with given id" do
      github_user = github_user_fixture()
      assert GithubUsers.get_github_user!(github_user.id) == github_user
    end

    test "create_github_user/1 with valid data creates a github_user" do
      valid_attrs = %{
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
      }

      assert {:ok, %GithubUser{} = github_user} = GithubUsers.create_github_user(valid_attrs)
      assert github_user.avatar_url == "some avatar_url"
      assert github_user.bio == "some bio"
      assert github_user.bio_html == "some bio_html"
      assert github_user.company == "some company"
      assert github_user.company_html == "some company_html"
      assert github_user.database_id_in_github == "some database_id_in_github"
      assert github_user.email == "some email"
      assert github_user.id_in_github == "some id_in_github"
      assert github_user.location == "some location"
      assert github_user.login == "some login"
      assert github_user.name == "some name"
      assert github_user.url == "some url"
      assert github_user.website_url == "some website_url"
    end

    test "create_github_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GithubUsers.create_github_user(@invalid_attrs)
    end

    test "update_github_user/2 with valid data updates the github_user" do
      github_user = github_user_fixture()

      update_attrs = %{
        avatar_url: "some updated avatar_url",
        bio: "some updated bio",
        bio_html: "some updated bio_html",
        company: "some updated company",
        company_html: "some updated company_html",
        database_id_in_github: "some updated database_id_in_github",
        email: "some updated email",
        id_in_github: "some updated id_in_github",
        location: "some updated location",
        login: "some updated login",
        name: "some updated name",
        url: "some updated url",
        website_url: "some updated website_url"
      }

      assert {:ok, %GithubUser{} = github_user} =
               GithubUsers.update_github_user(github_user, update_attrs)

      assert github_user.avatar_url == "some updated avatar_url"
      assert github_user.bio == "some updated bio"
      assert github_user.bio_html == "some updated bio_html"
      assert github_user.company == "some updated company"
      assert github_user.company_html == "some updated company_html"
      assert github_user.database_id_in_github == "some updated database_id_in_github"
      assert github_user.email == "some updated email"
      assert github_user.id_in_github == "some updated id_in_github"
      assert github_user.location == "some updated location"
      assert github_user.login == "some updated login"
      assert github_user.name == "some updated name"
      assert github_user.url == "some updated url"
      assert github_user.website_url == "some updated website_url"
    end

    test "update_github_user/2 with invalid data returns error changeset" do
      github_user = github_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               GithubUsers.update_github_user(github_user, @invalid_attrs)

      assert github_user == GithubUsers.get_github_user!(github_user.id)
    end

    test "delete_github_user/1 deletes the github_user" do
      github_user = github_user_fixture()
      assert {:ok, %GithubUser{}} = GithubUsers.delete_github_user(github_user)
      assert_raise Ecto.NoResultsError, fn -> GithubUsers.get_github_user!(github_user.id) end
    end

    test "change_github_user/1 returns a github_user changeset" do
      github_user = github_user_fixture()
      assert %Ecto.Changeset{} = GithubUsers.change_github_user(github_user)
    end
  end

  describe "github_users" do
    alias Mage.GithubUsers.GithubUser

    import Mage.GithubUsersFixtures

    @invalid_attrs %{
      avatar_url: nil,
      bio: nil,
      bio_html: nil,
      company: nil,
      company_html: nil,
      database_id_in_github: nil,
      email: nil,
      id_in_github: nil,
      last_synced_at: nil,
      location: nil,
      login: nil,
      name: nil,
      url: nil,
      website_url: nil
    }

    test "list_github_users/0 returns all github_users" do
      github_user = github_user_fixture()
      assert GithubUsers.list_github_users() == [github_user]
    end

    test "get_github_user!/1 returns the github_user with given id" do
      github_user = github_user_fixture()
      assert GithubUsers.get_github_user!(github_user.id) == github_user
    end

    test "create_github_user/1 with valid data creates a github_user" do
      valid_attrs = %{
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
      }

      assert {:ok, %GithubUser{} = github_user} = GithubUsers.create_github_user(valid_attrs)
      assert github_user.avatar_url == "some avatar_url"
      assert github_user.bio == "some bio"
      assert github_user.bio_html == "some bio_html"
      assert github_user.company == "some company"
      assert github_user.company_html == "some company_html"
      assert github_user.database_id_in_github == "some database_id_in_github"
      assert github_user.email == "some email"
      assert github_user.id_in_github == "some id_in_github"
      assert github_user.last_synced_at == ~U[2022-01-12 08:35:00Z]
      assert github_user.location == "some location"
      assert github_user.login == "some login"
      assert github_user.name == "some name"
      assert github_user.url == "some url"
      assert github_user.website_url == "some website_url"
    end

    test "create_github_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = GithubUsers.create_github_user(@invalid_attrs)
    end

    test "update_github_user/2 with valid data updates the github_user" do
      github_user = github_user_fixture()

      update_attrs = %{
        avatar_url: "some updated avatar_url",
        bio: "some updated bio",
        bio_html: "some updated bio_html",
        company: "some updated company",
        company_html: "some updated company_html",
        database_id_in_github: "some updated database_id_in_github",
        email: "some updated email",
        id_in_github: "some updated id_in_github",
        last_synced_at: ~U[2022-01-13 08:35:00Z],
        location: "some updated location",
        login: "some updated login",
        name: "some updated name",
        url: "some updated url",
        website_url: "some updated website_url"
      }

      assert {:ok, %GithubUser{} = github_user} =
               GithubUsers.update_github_user(github_user, update_attrs)

      assert github_user.avatar_url == "some updated avatar_url"
      assert github_user.bio == "some updated bio"
      assert github_user.bio_html == "some updated bio_html"
      assert github_user.company == "some updated company"
      assert github_user.company_html == "some updated company_html"
      assert github_user.database_id_in_github == "some updated database_id_in_github"
      assert github_user.email == "some updated email"
      assert github_user.id_in_github == "some updated id_in_github"
      assert github_user.last_synced_at == ~U[2022-01-13 08:35:00Z]
      assert github_user.location == "some updated location"
      assert github_user.login == "some updated login"
      assert github_user.name == "some updated name"
      assert github_user.url == "some updated url"
      assert github_user.website_url == "some updated website_url"
    end

    test "update_github_user/2 with invalid data returns error changeset" do
      github_user = github_user_fixture()

      assert {:error, %Ecto.Changeset{}} =
               GithubUsers.update_github_user(github_user, @invalid_attrs)

      assert github_user == GithubUsers.get_github_user!(github_user.id)
    end

    test "delete_github_user/1 deletes the github_user" do
      github_user = github_user_fixture()
      assert {:ok, %GithubUser{}} = GithubUsers.delete_github_user(github_user)
      assert_raise Ecto.NoResultsError, fn -> GithubUsers.get_github_user!(github_user.id) end
    end

    test "change_github_user/1 returns a github_user changeset" do
      github_user = github_user_fixture()
      assert %Ecto.Changeset{} = GithubUsers.change_github_user(github_user)
    end
  end
end
