defmodule TraceifyWeb.Admin.UserController do
  use TraceifyWeb, :controller

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    users = Traceify.Users.list_users

    render(conn, "index.json", %{users: users})
  end

  def create(conn, _) do
    {:ok, user} = Traceify.Users.create_user conn.body_params

    render(conn, "create.json", %{user: user})
  end

end