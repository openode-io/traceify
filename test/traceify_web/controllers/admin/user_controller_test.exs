defmodule TraceifyWeb.AdminUserControllerTest do
  use TraceifyWeb.AdminConnCase

  describe "GET /admin/users" do
    test "regular scenario", %{conn: conn} do
      conn = get conn, "/api/v1/admin/users"

      assert Poison.decode!(conn.resp_body)
        |> Enum.any?(fn(u) -> u["email"] == "admin@gmailll.com" end)
    end
  end

  describe "POST /admin/users/exists" do
    test "with existing", %{conn: conn} do
      conn = post conn, "/api/v1/admin/users/exists", %{ email: "hello@gmail.com" }

      assert String.contains?(conn.resp_body, "email")
    end

    test "with non existant email", %{conn: conn} do
      conn = post conn, "/api/v1/admin/users/exists", %{ email: "hello-invaliddd@gmail.com" }

      assert conn.status == 404
    end
  end

  describe "POST /admin/users" do
    test "basic user", %{conn: conn} do
      conn = post conn, "/api/v1/admin/users", %{
          token: "my-very-secret-token-create-user",
          email: "hello-create-user@gmail.com",
          is_admin: 0
        }

      res_obj = Poison.decode!(conn.resp_body)

      assert res_obj["id"] >= 1
    end

    test "invalid user", %{conn: conn} do
      conn = post conn, "/api/v1/admin/users", %{
          token1234: "invalid"
        }

      assert conn.status == 500
    end
  end

  describe "PATCH /admin/users/:id" do
    test "existing user", %{conn: conn} do

      user = Traceify.Users.get_by_email!("hello-to-update@gmail.com")

      new_token = "my-very-secret-token-to-update-updated"

      conn = patch conn, "/api/v1/admin/users/#{user.id}", %{
          token: new_token,
          is_admin: 1
        }

      assert String.contains?(conn.resp_body, "success")

      user = Traceify.Users.get_by_email!("hello-to-update@gmail.com")
      assert user.token == new_token
      assert user.is_admin == 1
    end

    test "invalid user", %{conn: conn} do
      conn = patch conn, "/api/v1/admin/users/-1", %{
          token: "",
          is_admin: 1
        }

      assert conn.status == 500
    end
  end

  describe "DELETE /admin/users/:id" do
    test "existing user", %{conn: conn} do
      user = Traceify.Users.get_by_email!("hello-to-delete@gmail.com")

      conn = delete conn, "/api/v1/admin/users/#{user.id}"

      assert String.contains?(conn.resp_body, "result")
      assert String.contains?(conn.resp_body, "success")
    end

    test "non existing user", %{conn: conn} do
      conn = delete conn, "/api/v1/admin/users/-1"

      assert conn.status == 500
    end
  end

end
