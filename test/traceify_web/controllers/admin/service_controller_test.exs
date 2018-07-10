defmodule TraceifyWeb.AdminServiceControllerTest do
  use TraceifyWeb.AdminConnCase

  #test "GET /admin/services", %{conn: conn} do
  #  conn = get conn, "/api/v1/admin/users"

  #  assert Poison.decode!(conn.resp_body)
  #    |> Enum.any?(fn(u) -> u["email"] == "admin@gmailll.com" end)
  #end

  test "POST /admin/services", %{conn: conn} do
    user = Traceify.Users.list_users
      |> Enum.at(0)
    storage_area = Traceify.StorageAreas.list_storage_areas
      |> Enum.at(0)
    last_service = Traceify.Services.list_services
      |> Enum.at(0)

    new_site_name = "siteeeee-#{last_service.id + 1}"

    conn = post conn, "/api/v1/admin/services", %{
        storage_area_id: storage_area.id,
        user_id: user.id,
        site_name: new_site_name
      }

    service_created = Traceify.Services.get_service_by_site_name!(new_site_name)

    assert service_created.site_name == new_site_name
  end

  test "POST /admin/services/exists", %{conn: conn} do
    last_service = Traceify.Services.list_services
      |> Enum.at(0)

    conn = post conn, "/api/v1/admin/services/exists", %{
        site_name: last_service.site_name
      }

    assert String.contains?(conn.resp_body, "site_name")
    assert String.contains?(conn.resp_body, last_service.site_name)
  end

  test "DELETE /admin/services/:sitename", %{conn: conn} do
    service = Traceify.Services.get_service_by_site_name!("hello_world_to_delete")

    conn = delete conn, "/api/v1/admin/services/#{service.site_name}"

    try do
      Traceify.Services.get_service_by_site_name!("hello_world_to_delete")
      assert false
    rescue
      e in _ -> assert true
    end
  end
end
