defmodule TraceifyWeb.HomeController do
  use TraceifyWeb, :controller
  require Logger

  def index(conn, _params) do
    render(conn, "index.json")
  end

  def version(conn, _params) do
    render(conn, "version.json")
  end
end
