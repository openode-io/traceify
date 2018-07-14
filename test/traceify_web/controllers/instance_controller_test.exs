defmodule TraceifyWeb.InstanceControllerTest do
  use TraceifyWeb.NormalUserConnCase

  describe "GET /api/v1/instances/" do
    test "regular case", %{conn: conn} do
      conn = get conn, "/api/v1/instances"

      assert String.contains?(conn.resp_body, "success")
    end
  end

  describe "POST /api/v1/instances/:sitename/:level/log and search" do

    setup do
      on_exit fn ->
        File.rm_rf!("./tmp/dbs/hello_world")
      end
    end

    test "regular case, single level", %{conn: conn} do
      conn_bak = conn

      conn = post conn, "/api/v1/instances/hello_world/info/log", %{
        hello2: "world2"
      }

      assert String.contains?(conn.resp_body, "success")

      conn_bak = post conn_bak, "/api/v1/instances/hello_world/search", %{
        levels: ["info"]
      }

      assert String.contains?(conn_bak.resp_body, "created_at")
      assert String.contains?(conn_bak.resp_body, "hello2")
      assert String.contains?(conn_bak.resp_body, "world2")
    end
  end
end
