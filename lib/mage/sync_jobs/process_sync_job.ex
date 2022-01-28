defmodule Mage.SyncJobs.ProcessSyncJob do
  alias Mage.SyncJobs
  alias Mage.UserIdentities

  require Logger

  import MageWeb.Endpoint, only: [broadcast: 3]

  def start_task(job_id) do
    with job <- SyncJobs.get_sync_job(job_id) do
      job = update_sync_job(job, %{status_type: "processing"})

      with {:ok, access_token} <- UserIdentities.fetch_access_token(job.user_id) do
        Mage.Github.Followers.chunk_user_followers(access_token)
        |> Stream.map(fn entries ->
          Enum.map(entries, fn item ->
            create_github_user_task(item)
          end)
        end)
        |> Enum.flat_map(& &1)
        |> yeild_download_tasks()

        job =
          update_sync_job(job, %{
            status_type: "success",
            job_finished_at: DateTime.utc_now()
          })
      else
        {:error, error} ->
          # TODO(yangqing)
          Process.sleep(10000)

          job =
            update_sync_job(job, %{
              status_type: "error",
              job_finished_at: DateTime.utc_now(),
              last_error: :erlang.term_to_binary(error)
            })
      end
    else
      _any -> nil
    end
  end

  @task_queue_timeout 120 * 60_000

  def create_github_user_task(api_result) do
    Task.Supervisor.async_nolink(
      :github_user_task_sup,
      fn ->
        :poolboy.transaction(
          :github_user_worker,
          fn pid -> GenServer.call(pid, {:sync_github_user, api_result}, @task_queue_timeout) end,
          @task_queue_timeout
        )
      end
    )
  end

  def yeild_download_tasks(tasks) do
    tasks_with_results = Task.yield_many(tasks, @task_queue_timeout)

    Enum.each(tasks_with_results, fn {task, res} ->
      case res || Task.shutdown(task, :brutal_kill) do
        nil ->
          Logger.warn("Failed to get a result in #{@task_queue_timeout}ms")

        _ ->
          nil
      end
    end)

    :ok
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
