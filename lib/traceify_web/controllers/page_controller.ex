defmodule TraceifyWeb.PageController do
  use TraceifyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.json")
  end
end
