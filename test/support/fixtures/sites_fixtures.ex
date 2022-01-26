defmodule Mage.SitesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mage.Sites` context.
  """

  @doc """
  Generate a site.
  """
  def site_fixture(attrs \\ %{}) do
    {:ok, site} =
      attrs
      |> Enum.into(%{
        domain_coloring: "some domain_coloring",
        host: "some host",
        icon: %{},
        last_synced_at: ~U[2022-01-12 08:56:00Z]
      })
      |> Mage.Sites.create_site()

    site
  end
end
