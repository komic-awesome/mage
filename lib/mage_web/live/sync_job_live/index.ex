defmodule MageWeb.SyncJobLive.Index do
  use MageWeb, :live_view

  alias MageWeb.LiveHelpers
  alias Mage.SyncJobs
  alias Mage.Accounts

  import MageWeb.SyncJobLive.Components

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

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, params) do
    apply_action(socket, :followings, params)
  end

  defp apply_action(socket, :followings, _params) do
    current_user = socket.assigns.current_user

    socket
    |> assign(:page_title, "我关注的人")
    |> assign(:sync_job, get_sync_job(current_user))
    |> assign_github_users(:followings, current_user)
    |> auto_begin_sync_job()
  end

  defp apply_action(socket, :followers, _params) do
    current_user = socket.assigns.current_user

    socket
    |> assign(:page_title, "关注我的人")
    |> assign(:sync_job, get_sync_job(current_user))
    |> assign_github_users(:followers, current_user)
    |> auto_begin_sync_job()
  end

  @seconds_per_day 3600 * 24
  defp auto_begin_sync_job(socket) do
    case socket.assigns.current_user do
      %{id: user_id} ->
        now = DateTime.utc_now()

        if is_nil(socket.assigns.sync_job) or
             is_nil(socket.assigns.sync_job.job_started_at) or
             DateTime.diff(now, socket.assigns.sync_job.job_started_at) > @seconds_per_day do
          job = SyncJobs.begin_user_sync_job(user_id)
          socket |> assign(:sync_job, job)
        else
          socket
        end

      _ ->
        socket
    end
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
    socket =
      case job do
        %{status_type: "success"} ->
          socket |> assign_github_users(socket.assigns.live_action, socket.assigns.current_user)

        _ ->
          socket
      end

    {
      :noreply,
      socket
      |> assign(:sync_job, job)
    }
  end

  def get_sync_job(%{id: user_id}) do
    SyncJobs.get_user_sync_job(user_id)
  end

  def get_sync_job(_) do
    nil
  end

  defp assign_github_users(socket, _action, nil), do: socket

  defp assign_github_users(socket, :index, %{id: user_id}) do
    assign_github_users(socket, :followings, %{id: user_id})
  end

  defp assign_github_users(socket, :followings, %{id: user_id}) do
    socket |> assign(:github_users, Accounts.list_followings(user_id))
  end

  defp assign_github_users(socket, :followers, %{id: user_id}) do
    socket |> assign(:github_users, Accounts.list_followers(user_id))
  end

  defp maybe_menu_link(:index, item_action) do
    maybe_menu_link(:followings, item_action)
  end

  defp maybe_menu_link(live_action, item_action) do
    assigns = %{
      href: MageWeb.Router.Helpers.sync_job_index_path(MageWeb.Endpoint, item_action),
      actived_class:
        if live_action == item_action do
          "text-blue-700 bg-white shadow "
        else
          "text-blue-100 "
        end,
      title:
        case item_action do
          :followings -> "我关注的人"
          :followers -> "关注我的人"
        end
    }

    ~H"""
    <a
      class={"text-center inline-block w-full py-2.5 text-sm leading-5 font-medium rounded-lg focus:outline-none focus:ring-2 ring-offset-2 ring-offset-blue-400 ring-white ring-opacity-60 #{@actived_class}"}
      id="headlessui-tabs-tab-1"
      role="tab"
      type="button"
      data-phx-link="patch"
      data-phx-link-state="push"
      href={@href}
    ><%= @title%></a>
    """
  end
end
