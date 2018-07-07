defmodule TraceifyWeb.PageControllerTest do
  use TraceifyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"

    assert String.contains?(conn.resp_body, "welcome_to")
  end
end
