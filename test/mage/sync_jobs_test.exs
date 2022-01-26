defmodule Mage.SyncJobsTest do
  use Mage.DataCase

  alias Mage.SyncJobs

  describe "sync_jobs" do
    alias Mage.SyncJobs.SyncJob

    import Mage.SyncJobsFixtures

    @invalid_attrs %{
      job_finished_at: nil,
      job_started_at: nil,
      last_error: nil,
      status_label: nil,
      status_type: nil
    }

    test "list_sync_jobs/0 returns all sync_jobs" do
      sync_job = sync_job_fixture()
      assert SyncJobs.list_sync_jobs() == [sync_job]
    end

    test "get_sync_job!/1 returns the sync_job with given id" do
      sync_job = sync_job_fixture()
      assert SyncJobs.get_sync_job!(sync_job.id) == sync_job
    end

    test "create_sync_job/1 with valid data creates a sync_job" do
      valid_attrs = %{
        job_finished_at: ~U[2022-01-11 07:44:00Z],
        job_started_at: ~U[2022-01-11 07:44:00Z],
        last_error: "some last_error",
        status_label: "some status_label",
        status_type: "some status_type"
      }

      assert {:ok, %SyncJob{} = sync_job} = SyncJobs.create_sync_job(valid_attrs)
      assert sync_job.job_finished_at == ~U[2022-01-11 07:44:00Z]
      assert sync_job.job_started_at == ~U[2022-01-11 07:44:00Z]
      assert sync_job.last_error == "some last_error"
      assert sync_job.status_label == "some status_label"
      assert sync_job.status_type == "some status_type"
    end

    test "create_sync_job/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SyncJobs.create_sync_job(@invalid_attrs)
    end

    test "update_sync_job/2 with valid data updates the sync_job" do
      sync_job = sync_job_fixture()

      update_attrs = %{
        job_finished_at: ~U[2022-01-12 07:44:00Z],
        job_started_at: ~U[2022-01-12 07:44:00Z],
        last_error: "some updated last_error",
        status_label: "some updated status_label",
        status_type: "some updated status_type"
      }

      assert {:ok, %SyncJob{} = sync_job} = SyncJobs.update_sync_job(sync_job, update_attrs)
      assert sync_job.job_finished_at == ~U[2022-01-12 07:44:00Z]
      assert sync_job.job_started_at == ~U[2022-01-12 07:44:00Z]
      assert sync_job.last_error == "some updated last_error"
      assert sync_job.status_label == "some updated status_label"
      assert sync_job.status_type == "some updated status_type"
    end

    test "update_sync_job/2 with invalid data returns error changeset" do
      sync_job = sync_job_fixture()
      assert {:error, %Ecto.Changeset{}} = SyncJobs.update_sync_job(sync_job, @invalid_attrs)
      assert sync_job == SyncJobs.get_sync_job!(sync_job.id)
    end

    test "delete_sync_job/1 deletes the sync_job" do
      sync_job = sync_job_fixture()
      assert {:ok, %SyncJob{}} = SyncJobs.delete_sync_job(sync_job)
      assert_raise Ecto.NoResultsError, fn -> SyncJobs.get_sync_job!(sync_job.id) end
    end

    test "change_sync_job/1 returns a sync_job changeset" do
      sync_job = sync_job_fixture()
      assert %Ecto.Changeset{} = SyncJobs.change_sync_job(sync_job)
    end
  end
end
