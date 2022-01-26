defmodule MageWeb.Channels.UserChannel do
  use Phoenix.Channel

  def join("user:" <> _user_id, _payload, socket) do
    {:ok, socket}
  end
end
