defmodule Mage.SyncJobs.SyncJob do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sync_jobs" do
    field :job_finished_at, :utc_datetime
    field :job_started_at, :utc_datetime
    field :last_error, :binary
    field :status_label, :string, default: ""
    field :status_type, :string, default: ""
    field :user_id, :id

    timestamps()
  end

  @doc false
  def changeset(sync_job, attrs) do
    sync_job
    |> cast(attrs, [
      :status_type,
      :status_label,
      :last_error,
      :job_started_at,
      :job_finished_at,
      :user_id
    ])
    |> validate_required([
      :status_type,
      :job_started_at
    ])
  end
end
