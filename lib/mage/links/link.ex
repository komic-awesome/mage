defmodule Mage.Links.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :last_synced_at, :utc_datetime
    field :status_code, :integer
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :title, :status_code, :last_synced_at])
    |> validate_required([:url, :title, :status_code, :last_synced_at])
  end
end
