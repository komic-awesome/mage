defmodule Mage.SyncJobs.ProcessSyncJob do
  alias Mage.SyncJobs

  def start_task(job_id) do
    with job <- SyncJobs.get_sync_job(job_id) do
      IO.inspect("begin change")

      SyncJobs.update_sync_job(job, %{status_type: "processing"})

      Process.sleep(10000)

      SyncJobs.update_sync_job(job, %{status_type: "success", job_finished_at: DateTime.utc_now()})
    else
      _any -> nil
    end
  end
end
