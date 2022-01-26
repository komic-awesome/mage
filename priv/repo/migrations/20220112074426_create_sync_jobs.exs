defmodule Mage.Repo.Migrations.CreateSyncJobs do
  use Ecto.Migration

  def change do
    create table(:sync_jobs) do
      add :status_type, :string
      add :status_label, :string
      add :last_error, :binary
      add :job_started_at, :utc_datetime
      add :job_finished_at, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:sync_jobs, [:user_id])
  end
end
