defmodule TraceifyWeb.AdminServiceControllerTest do
  use TraceifyWeb.AdminConnCase

  describe "POST /admin/services" do
    test "create valid service", %{conn: conn} do
      user = Traceify.Users.list_users
        |> Enum.at(0)
      storage_area = Traceify.StorageAreas.list_storage_areas
        |> Enum.at(0)
      last_service = Traceify.Services.list_services
        |> Enum.at(0)

      new_site_name = "siteeeee-#{last_service.id + 1}"

      post conn, "/api/v1/admin/services", %{
          storage_area_id: storage_area.id,
          user_id: user.id,
          site_name: new_site_name
        }

      service_created = Traceify.Services.get_service_by_site_name!(new_site_name)

      assert service_created.site_name == new_site_name
    end

    test "create valid service without storage area", %{conn: conn} do
      user = Traceify.Users.list_users
        |> Enum.at(0)
      storage_area = Traceify.StorageAreas.list_storage_areas
        |> Enum.at(0)
      last_service = Traceify.Services.list_services
        |> Enum.at(0)

      new_site_name = "siteeeee-#{last_service.id + 1}"

      post conn, "/api/v1/admin/services", %{
          user_id: user.id,
          site_name: new_site_name
        }

      service_created = Traceify.Services.get_service_by_site_name!(new_site_name)

      assert service_created.site_name == new_site_name
      assert service_created.storage_area_id == storage_area.id
    end

    test "create invalid service", %{conn: conn} do
      conn = post conn, "/api/v1/admin/services", %{
          whats: "that"
        }

      assert conn.status == 500
    end
  end

  describe "PATCH /admin/services/:id" do
    test "existing service", %{conn: conn} do

      service = Traceify.Services.get_service_by_site_name!("hello_world_to_update")

      new_site_name = "hello_world_to_updated"

      conn = patch conn, "/api/v1/admin/services/#{service.id}", %{
          site_name: new_site_name
        }

      assert String.contains?(conn.resp_body, "success")

      service = Traceify.Services.get_service_by_site_name!("hello_world_to_updated")
      assert service.site_name == new_site_name
    end

    test "invalid service", %{conn: conn} do
      conn = patch conn, "/api/v1/admin/services/-1", %{}

      assert conn.status == 500
    end
  end

  describe "POST /admin/services/exists" do
    test "with existing site", %{conn: conn} do
      last_service = Traceify.Services.list_services
        |> Enum.at(0)

      conn = post conn, "/api/v1/admin/services/exists", %{
          site_name: last_service.site_name
        }

      assert String.contains?(conn.resp_body, "site_name")
      assert String.contains?(conn.resp_body, last_service.site_name)
    end

    test "with non existant site", %{conn: conn} do
      conn = post conn, "/api/v1/admin/services/exists", %{
          site_name: "innnnvalid"
        }

      assert conn.status == 404
    end
  end


  describe "DELETE /admin/services/:sitename" do
    test "with existing site", %{conn: conn} do
      service = Traceify.Services.get_service_by_site_name!("hello_world_to_delete")

      con_res = delete conn, "/api/v1/admin/services/#{service.site_name}"

      assert con_res.status == 200

      try do
        Traceify.Services.get_service_by_site_name!("hello_world_to_delete")
        assert false
      rescue
        _ in _ -> assert true
      end
    end

    test "with non existing site", %{conn: conn} do
      conn = delete conn, "/api/v1/admin/services/invalid-site-here"

      assert conn.status == 500
    end
  end

end
