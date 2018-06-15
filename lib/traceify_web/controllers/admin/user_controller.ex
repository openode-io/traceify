defmodule TraceifyWeb.Admin.UserController do
  use TraceifyWeb, :controller

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    users = Traceify.Users.list_users

    render(conn, "index.json", %{users: users})
  end



end
