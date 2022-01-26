defmodule Mage.SyncJobs.Monitor do
  use GenServer
  require Logger

  @refresh_interval :timer.seconds(2)
  @size 2

  defmodule State do
    defstruct pending_tasks: [],
              current_tasks: []
  end

  def start_link(_) do
    Logger.info("Mage.SyncJobs.Monitor started", ansi_color: :green)

    GenServer.start_link(__MODULE__, %State{}, name: __MODULE__)
  end

  def add_sync_job(sync_job_id) when is_integer(sync_job_id) do
    Logger.info(":add_task: :add_sync_job, #{sync_job_id}", ansi_color: :green)

    GenServer.call(__MODULE__, {:add_task, :sync_job, sync_job_id})
  end

  def init(initial_state) do
    schedule_timer()
    {:ok, initial_state}
  end

  def handle_call({:add_task, :sync_job, sync_job_id}, _from, state)
      when is_integer(sync_job_id) do
    {
      :reply,
      :ok,
      push_state(state, :pending_tasks, {:sync_job, sync_job_id})
    }
  end

  def handle_info(:process_tasks, state) do
    new_state = process_tasks(state)
    schedule_timer()
    {:noreply, new_state}
  end

  def handle_info({:DOWN, ref, :process, _pid, _reason}, state) do
    IO.inspect("handle_info failed")
    {:noreply, remove_state(state, :current_tasks, ref)}
  end

  def handle_info({ref, _answer}, state) do
    IO.inspect("handle_info success")
    Process.demonitor(ref, [:flush])
    {:noreply, remove_state(state, :current_tasks, ref)}
  end

  defp schedule_timer do
    Process.send_after(self(), :process_tasks, @refresh_interval)
  end

  defp process_tasks(state) do
    cap = @size - length(state.current_tasks)

    if cap > 0 do
      Enum.reduce(1..cap, state, fn _index, state ->
        {task_event, new_state} = pop_state(state, :pending_tasks)

        case task_event do
          nil ->
            new_state

          {:sync_job, sync_job_id} ->
            start_task(new_state, {:sync_job, sync_job_id})
        end
      end)
    else
      state
    end
  end

  defp push_state(state, key, value) do
    current_list = Map.get(state, key, [])

    state
    |> Map.replace(
      key,
      current_list ++ [value]
    )
  end

  defp pop_state(state, key) do
    {value, list} = List.pop_at(Map.get(state, key, []), 0)

    {value, state |> Map.replace(key, list)}
  end

  defp remove_state(state, key, value) do
    list = Map.get(state, key, [])

    state |> Map.replace(key, List.delete(list, value))
  end

  defp start_task(state, task_event) do
    task =
      Task.Supervisor.async_nolink(:sync_job_sup, fn ->
        case task_event do
          {:sync_job, sync_job_id} ->
            Mage.SyncJobs.ProcessSyncJob.start_task(sync_job_id)

          _ ->
            nil
        end
      end)

    push_state(state, :current_tasks, task.ref)
  end
end
