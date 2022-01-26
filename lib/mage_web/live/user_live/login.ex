defmodule MageWeb.UserLive.Login do
  use MageWeb, :live_view

  alias Mage.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:login), do: "登录"
end
