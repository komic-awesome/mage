defmodule Mage.SitesTest do
  use Mage.DataCase

  alias Mage.Sites

  describe "sites" do
    alias Mage.Sites.Site

    import Mage.SitesFixtures

    @invalid_attrs %{domain_coloring: nil, host: nil, icon: nil, last_synced_at: nil}

    test "list_sites/0 returns all sites" do
      site = site_fixture()
      assert Sites.list_sites() == [site]
    end

    test "get_site!/1 returns the site with given id" do
      site = site_fixture()
      assert Sites.get_site!(site.id) == site
    end

    test "create_site/1 with valid data creates a site" do
      valid_attrs = %{
        domain_coloring: "some domain_coloring",
        host: "some host",
        icon: %{},
        last_synced_at: ~U[2022-01-12 08:56:00Z]
      }

      assert {:ok, %Site{} = site} = Sites.create_site(valid_attrs)
      assert site.domain_coloring == "some domain_coloring"
      assert site.host == "some host"
      assert site.icon == %{}
      assert site.last_synced_at == ~U[2022-01-12 08:56:00Z]
    end

    test "create_site/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Sites.create_site(@invalid_attrs)
    end

    test "update_site/2 with valid data updates the site" do
      site = site_fixture()

      update_attrs = %{
        domain_coloring: "some updated domain_coloring",
        host: "some updated host",
        icon: %{},
        last_synced_at: ~U[2022-01-13 08:56:00Z]
      }

      assert {:ok, %Site{} = site} = Sites.update_site(site, update_attrs)
      assert site.domain_coloring == "some updated domain_coloring"
      assert site.host == "some updated host"
      assert site.icon == %{}
      assert site.last_synced_at == ~U[2022-01-13 08:56:00Z]
    end

    test "update_site/2 with invalid data returns error changeset" do
      site = site_fixture()
      assert {:error, %Ecto.Changeset{}} = Sites.update_site(site, @invalid_attrs)
      assert site == Sites.get_site!(site.id)
    end

    test "delete_site/1 deletes the site" do
      site = site_fixture()
      assert {:ok, %Site{}} = Sites.delete_site(site)
      assert_raise Ecto.NoResultsError, fn -> Sites.get_site!(site.id) end
    end

    test "change_site/1 returns a site changeset" do
      site = site_fixture()
      assert %Ecto.Changeset{} = Sites.change_site(site)
    end
  end
end
