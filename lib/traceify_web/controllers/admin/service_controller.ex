defmodule TraceifyWeb.Admin.ServiceController do
  use TraceifyWeb, :controller

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    users = Traceify.Users.list_users

    render(conn, "index.json", %{users: users})
  end

  def create(conn, _) do
    {:ok, service} = Traceify.Services.create_service conn.body_params

    render(conn, "create.json", %{service: service})
  end

end
