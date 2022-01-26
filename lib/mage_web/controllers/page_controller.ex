defmodule MageWeb.PageController do
  use MageWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
