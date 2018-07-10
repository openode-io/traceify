defmodule TraceifyWeb.Admin.ServiceController do
  use TraceifyWeb, :controller

  action_fallback TraceifyWeb.FallbackController

  def exists(conn, _) do
    service = Traceify.Services.get_service_by_site_name!(conn.body_params["site_name"])
    
    render(conn, "exists.json", %{service: service})
  end

  def create(conn, _) do
    {:ok, service} = Traceify.Services.create_service conn.body_params

    render(conn, "create.json", %{service: service})
  end

  def destroy(conn, %{"sitename" => sitename}) do
    # remove from db:
    service = Traceify.Services.get_service_by_site_name!(sitename)
    Traceify.Services.delete_service(service)

    render(conn, "destroy.json", %{service: service})
  end

end
