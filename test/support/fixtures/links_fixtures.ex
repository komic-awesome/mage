defmodule Mage.LinksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mage.Links` context.
  """

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> Enum.into(%{
        last_synced_at: ~U[2022-01-12 08:49:00Z],
        status_code: 42,
        title: "some title",
        url: "some url"
      })
      |> Mage.Links.create_link()

    link
  end
end
