defmodule Mage.SyncJobs.ProcessSyncJob do
  alias Mage.SyncJobs

  import MageWeb.Endpoint, only: [broadcast: 3]

  def start_task(job_id) do
    with job <- SyncJobs.get_sync_job(job_id) do
      job = update_sync_job(job, %{status_type: "processing"})

      Process.sleep(10000)

      job =
        update_sync_job(job, %{
          status_type: "success",
          job_finished_at: DateTime.utc_now()
        })
    else
      _any -> nil
    end
  end

  defp update_sync_job(job, attrs) do
    {:ok, new_job} =
      SyncJobs.update_sync_job(job, %{
        status_type: "success",
        job_finished_at: DateTime.utc_now()
      })

    if job.user_id do
      broadcast("user:#{job.user_id}", "job:updated", new_job)
    end

    new_job
  end
end
