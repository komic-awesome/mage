defmodule Mage.SyncJobs do
  @moduledoc """
  The SyncJobs context.
  """

  import Ecto.Query, warn: false
  alias Mage.Repo

  alias Mage.SyncJobs.SyncJob

  @doc """
  Returns the list of sync_jobs.

  ## Examples

      iex> list_sync_jobs()
      [%SyncJob{}, ...]

  """
  def list_sync_jobs do
    Repo.all(SyncJob)
  end

  def get_user_sync_job(user_id) do
    Repo.one(from s0 in Mage.SyncJobs.SyncJob, where: s0.user_id == ^user_id, limit: 1)
  end

  def get_sync_job(job_id) do
    Repo.get(SyncJob, job_id)
  end

  @doc """
  Creates a sync_job.

  ## Examples

      iex> create_sync_job(%{field: value})
      {:ok, %SyncJob{}}

      iex> create_sync_job(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_sync_job(attrs \\ %{}) do
    %SyncJob{}
    |> SyncJob.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a sync_job.

  ## Examples

      iex> update_sync_job(sync_job, %{field: new_value})
      {:ok, %SyncJob{}}

      iex> update_sync_job(sync_job, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_sync_job(%SyncJob{} = sync_job, attrs) do
    sync_job
    |> SyncJob.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a sync_job.

  ## Examples

      iex> delete_sync_job(sync_job)
      {:ok, %SyncJob{}}

      iex> delete_sync_job(sync_job)
      {:error, %Ecto.Changeset{}}

  """
  def delete_sync_job(%SyncJob{} = sync_job) do
    Repo.delete(sync_job)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking sync_job changes.

  ## Examples

      iex> change_sync_job(sync_job)
      %Ecto.Changeset{data: %SyncJob{}}

  """
  def change_sync_job(%SyncJob{} = sync_job, attrs \\ %{}) do
    SyncJob.changeset(sync_job, attrs)
  end

  def begin_user_sync_job(user_id) do
    with {:ok, job} <-
           create_sync_job(%{
             job_started_at: DateTime.utc_now(),
             status_type: "waiting",
             user_id: user_id
           }) do
      Mage.SyncJobs.Monitor.add_sync_job(job.id)
    end
  end
end
