defmodule Mage.Repo.Migrations.CreateSites do
  use Ecto.Migration

  def change do
    create table(:sites) do
      add :host, :string
      add :icon, :map
      add :domain_coloring, :string
      add :last_synced_at, :utc_datetime

      timestamps()
    end

    alter table("links") do
      add :site_id, references(:sites, on_delete: :nothing)
    end
  end
end
