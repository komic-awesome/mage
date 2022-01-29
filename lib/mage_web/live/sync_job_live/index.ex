defmodule MageWeb.SyncJobLive.Index do
  use MageWeb, :live_view

  alias MageWeb.LiveHelpers
  alias Mage.SyncJobs
  alias Mage.Accounts

  import MageWeb.Endpoint, only: [unsubscribe: 1, subscribe: 1]

  @impl true
  def mount(_params, session, socket) do
    socket = socket |> assign_defaults(session)
    current_user = socket.assigns.current_user

    case current_user do
      %{id: user_id} ->
        subscribe("user:#{user_id}")

      _ ->
        nil
    end

    {:ok,
     socket |> assign(:sync_job, get_sync_job(current_user)) |> assign_github_users(current_user)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "当前同步")
  end

  def handle_event("begin_sync_job", _params, socket) do
    case socket.assigns.current_user do
      %{id: user_id} ->
        job = SyncJobs.begin_user_sync_job(user_id)
        {:noreply, socket |> assign(:sync_job, job)}

      _ ->
        {:noreply, socket}
    end
  end

  def handle_info(%{event: "job:updated", payload: job}, socket) do
    {:noreply, socket |> assign(:sync_job, job)}
  end

  def get_sync_job(%{id: user_id}) do
    SyncJobs.get_user_sync_job(user_id)
  end

  def get_sync_job(_) do
    nil
  end

  defp assign_github_users(socket, nil), do: socket

  defp assign_github_users(socket, %{id: user_id}) do
    socket |> assign(:github_users, Accounts.list_followers(user_id))
  end
end
