defmodule TraceifyWeb.HomeControllerTest do
  use TraceifyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"

    assert String.contains?(conn.resp_body, "welcome_to")
  end

  test "GET /version", %{conn: conn} do
    conn = get conn, "/version"

    assert String.contains?(conn.resp_body, "version")
  end
end
