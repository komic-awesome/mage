defmodule Mage.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :url, :string, size: 2048
      add :title, :string
      add :status_code, :integer
      add :last_synced_at, :utc_datetime

      timestamps()
    end
  end
end
