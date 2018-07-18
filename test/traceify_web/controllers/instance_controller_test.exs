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
        File.rm_rf!("./tmp/dbs/hello_world_empty")
      end
    end

    test "regular case, single level", %{conn: conn} do
      conn_bak = conn

      conn = post conn, "/api/v1/instances/hello_world/info/log", %{
        hello2: "world2"
      }

      assert String.contains?(conn.resp_body, "success")

      :timer.sleep(1000)

      conn_bak = post conn_bak, "/api/v1/instances/hello_world/search", %{
        levels: ["info"]
      }

      assert String.contains?(conn_bak.resp_body, "created_at")
      assert String.contains?(conn_bak.resp_body, "hello2")
      assert String.contains?(conn_bak.resp_body, "world2")
      assert String.contains?(conn_bak.resp_body, "\"total_nb_entries\":1")
      assert String.contains?(conn_bak.resp_body, "\"nb_pages\":1")
    end

    @tag :wip
    test "regular case, multiple logs", %{conn: conn} do
      conn_bak = conn

      Enum.each 1..12, fn x ->
        post conn, "/api/v1/instances/hello_world_empty/info/log", %{
          hello2: "world2"
        }
      end

      :timer.sleep(3000)

      conn_bak = post conn_bak, "/api/v1/instances/hello_world_empty/search", %{
        levels: ["info"],
        per_page: 10,
        page: 0
      }

      assert String.contains?(conn_bak.resp_body, "\"total_nb_entries\":12")
      assert String.contains?(conn_bak.resp_body, "\"nb_pages\":2")
    end

    test "concurrent logging", %{conn: conn} do
      conn_bak = conn

      Enum.each 1..10, fn x ->
        spawn fn -> post conn, "/api/v1/instances/hello_world/info/log", %{ hello2: "world2" } end
      end

      Enum.each 1..10, fn x ->
        spawn fn -> post conn_bak, "/api/v1/instances/hello_world/search", %{ levels: ["info"] }  end
      end

      :timer.sleep 3000
    end
  end
end
