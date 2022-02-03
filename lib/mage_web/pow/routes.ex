defmodule MageWeb.Pow.Routes do
  use Pow.Phoenix.Routes
  alias MageWeb.Router.Helpers, as: Routes

  @impl true
  def after_sign_out_path(conn), do: Routes.user_login_path(conn, :login)
end
