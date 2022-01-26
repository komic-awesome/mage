defmodule Mage.SyncJobsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Mage.SyncJobs` context.
  """

  @doc """
  Generate a sync_job.
  """
  def sync_job_fixture(attrs \\ %{}) do
    {:ok, sync_job} =
      attrs
      |> Enum.into(%{
        job_finished_at: ~U[2022-01-11 07:44:00Z],
        job_started_at: ~U[2022-01-11 07:44:00Z],
        last_error: "some last_error",
        status_label: "some status_label",
        status_type: "some status_type"
      })
      |> Mage.SyncJobs.create_sync_job()

    sync_job
  end
end
