defmodule MageWeb.SyncJobLive.Index do
  use MageWeb, :live_view

  alias MageWeb.LiveHelpers
  alias Mage.SyncJobs

  @impl true
  def mount(_params, session, socket) do
    socket = socket |> assign_defaults(session)

    {:ok, socket |> assign(:sync_job, get_sync_job(socket.assigns.current_user))}
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
        SyncJobs.begin_user_sync_job(user_id)

      _ ->
        nil
    end

    {:noreply, socket}
  end

  def get_sync_job(%{id: user_id}) do
    SyncJobs.get_user_sync_job(user_id)
  end

  def get_sync_job(_) do
    nil
  end
end
