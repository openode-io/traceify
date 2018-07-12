defmodule TraceifyWeb.Admin.UserController do
  use TraceifyWeb, :controller

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    try do
      users = Traceify.Users.list_users

      render(conn, "index.json", %{users: users})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

  def exists(conn, _) do
    try do
      user = Traceify.Users.get_by_email!(conn.body_params["email"])

      render(conn, "exists.json", %{user: user})
    rescue
      e in _ -> {:error, :not_found}
    end
  end

  def create(conn, _) do
    try do
      {:ok, user} = Traceify.Users.create_user conn.body_params

      render(conn, "create.json", %{user: user})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

  def update(conn, %{ "id" => id }) do
    try do
      user = Traceify.Users.get_user!(id)
      {:ok, user} = Traceify.Users.update_user(user, conn.body_params)

      render(conn, "default.json", %{})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

  def destroy(conn, %{ "id" => id }) do
    try do
      user = Traceify.Users.get_user!(id)
      Traceify.Users.delete_user user

      render(conn, "default.json", %{})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

end
