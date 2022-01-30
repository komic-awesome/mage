defmodule Mage.SyncJobs.ProcessSyncJob do
  alias Mage.SyncJobs
  alias Mage.UserIdentities
  alias Mage.Accounts

  require Logger

  import MageWeb.Endpoint, only: [broadcast: 3]

  def start_task(job_id) do
    try do
      process_sync_job(job_id)
    rescue
      e ->
        Logger.error(Exception.format(:error, e, __STACKTRACE__))
    end
  end

  defp process_sync_job(job_id) do
    with job <- SyncJobs.get_sync_job(job_id) do
      job = update_sync_job(job, %{status_type: "processing"})

      try do
        with {:ok, access_token} <- UserIdentities.fetch_access_token(job.user_id) do
          followers =
            Mage.Github.Followers.chunk_user_followers(access_token)
            |> Stream.map(fn entries ->
              Enum.map(entries, fn item ->
                create_github_user_task(item)
              end)
            end)
            |> Enum.flat_map(& &1)
            |> yeild_download_tasks()

          Accounts.update_followers(job.user_id, followers)

          followings =
            Mage.Github.Followings.chunk_user_followings(access_token)
            |> Stream.map(fn entries ->
              Enum.map(entries, fn item ->
                create_github_user_task(item)
              end)
            end)
            |> Enum.flat_map(& &1)
            |> yeild_download_tasks()

          Accounts.update_followings(job.user_id, followings)

          job =
            update_sync_job(job, %{
              status_type: "success",
              job_finished_at: DateTime.utc_now()
            })
        else
          {:error, error} ->
            job =
              update_sync_job(job, %{
                status_type: "error",
                job_finished_at: DateTime.utc_now(),
                last_error: :erlang.term_to_binary(error)
              })
        end
      rescue
        e ->
          job =
            update_sync_job(job, %{
              status_type: "error",
              job_finished_at: DateTime.utc_now(),
              last_error: :erlang.term_to_binary(e)
            })

          Logger.error(Exception.format(:error, e, __STACKTRACE__))
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

    tasks_with_results
    |> Enum.map(fn {task, res} ->
      case res || Task.shutdown(task, :brutal_kill) do
        nil ->
          Logger.warn("Failed to get a result in #{@task_queue_timeout}ms")
          nil

        {:ok, {:ok, github_user}} ->
          github_user

        _ ->
          nil
      end
    end)
    |> Enum.filter(&(!is_nil(&1)))
  end

  defp update_sync_job(job, attrs) do
    {:ok, new_job} = SyncJobs.update_sync_job(job, attrs)

    if job.user_id do
      broadcast("user:#{job.user_id}", "job:updated", new_job)
    end

    new_job
  end
end
