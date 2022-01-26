defmodule Mage.LinksTest do
  use Mage.DataCase

  alias Mage.Links

  describe "links" do
    alias Mage.Links.Link

    import Mage.LinksFixtures

    @invalid_attrs %{last_synced_at: nil, status_code: nil, title: nil, url: nil}

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert Links.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert Links.get_link!(link.id) == link
    end

    test "create_link/1 with valid data creates a link" do
      valid_attrs = %{
        last_synced_at: ~U[2022-01-12 08:49:00Z],
        status_code: 42,
        title: "some title",
        url: "some url"
      }

      assert {:ok, %Link{} = link} = Links.create_link(valid_attrs)
      assert link.last_synced_at == ~U[2022-01-12 08:49:00Z]
      assert link.status_code == 42
      assert link.title == "some title"
      assert link.url == "some url"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Links.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()

      update_attrs = %{
        last_synced_at: ~U[2022-01-13 08:49:00Z],
        status_code: 43,
        title: "some updated title",
        url: "some updated url"
      }

      assert {:ok, %Link{} = link} = Links.update_link(link, update_attrs)
      assert link.last_synced_at == ~U[2022-01-13 08:49:00Z]
      assert link.status_code == 43
      assert link.title == "some updated title"
      assert link.url == "some updated url"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = Links.update_link(link, @invalid_attrs)
      assert link == Links.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = Links.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> Links.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = Links.change_link(link)
    end
  end
end
