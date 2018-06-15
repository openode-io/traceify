defmodule TraceifyWeb.Authentication do
  import Plug.Conn
  alias Traceify.Users

  def load_user(conn, _) do
    header_token = Enum.find(conn.req_headers, fn(x) -> elem(x, 0) == "x-auth-token" end)

    token = cond do
      header_token != nil -> elem(header_token, 1)
      true -> raise 'No token available'
    end

    user = Users.get_by_token!(token)

    assign(conn, :user, user)
  end

  def force_admin(conn, _) do
    unless conn.assigns.user.is_admin == 1 do
      raise "user should be an admin"
    end

    conn
  end

end
