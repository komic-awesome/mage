defmodule Mage.Sites.Site do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sites" do
    field :domain_coloring, :string
    field :host, :string
    field :icon, :map
    field :last_synced_at, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(site, attrs) do
    site
    |> cast(attrs, [:host, :icon, :domain_coloring, :last_synced_at])
    |> validate_required([:host, :icon, :domain_coloring, :last_synced_at])
  end
end
