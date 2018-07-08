defmodule TraceifyWeb.AdminUserControllerTest do
  use TraceifyWeb.AdminConnCase

  test "GET /admin/users", %{conn: conn} do
    conn = get conn, "/api/v1/admin/users"

    assert Poison.decode!(conn.resp_body)
      |> Enum.any?(fn(u) -> u["email"] == "admin@gmailll.com" end)
  end

  test "POST /admin/users", %{conn: conn} do
    conn = post conn, "/api/v1/admin/users", %{
        token: "my-very-secret-token-create-user",
        email: "hello-create-user@gmail.com",
        is_admin: 0
      }

    res_obj = Poison.decode!(conn.resp_body)

    assert res_obj["id"] >= 1
  end

  test "DELETE /admin/users/", %{conn: conn} do
    user = Traceify.Users.get_by_email!("hello-to-delete@gmail.com")

    conn = delete conn, "/api/v1/admin/users/#{user.id}"

    assert String.contains?(conn.resp_body, "result")
    assert String.contains?(conn.resp_body, "success")
  end
end
