defmodule TraceifyWeb.Admin.ServiceController do
  use TraceifyWeb, :controller
  require Logger

  action_fallback TraceifyWeb.FallbackController

  def exists(conn, _) do
    try do
      service = Traceify.Services.get_service_by_site_name!(conn.body_params["site_name"])

      render(conn, "exists.json", %{service: service})
    rescue
      e in _ -> {:error, :not_found}
    end
  end

  def create(conn, _) do
    try do
      Logger.info("creating service")

      service = conn.body_params

      service = cond do
        ! service["storage_area_id"] -> Logger.info("2")
		storage_area = Traceify.StorageAreas.first_storage_areas
		Logger.info("defaulting to storage area #{storage_area.name}")

		Map.put(service, "storage_area_id", storage_area.id)
	true -> conn.body_params
      end

      {:ok, service} = Traceify.Services.create_service service

      render(conn, "create.json", %{service: service})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

  def update(conn, %{ "id" => id }) do
    try do
      service = Traceify.Services.get_service!(id)
      {:ok, service} = Traceify.Services.update_service(service, conn.body_params)

      render(conn, "default.json", %{})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end

  def destroy(conn, %{"sitename" => sitename}) do
    try do
      # remove from db:
      service = Traceify.Services.get_service_by_site_name!(sitename)
      Traceify.Services.delete_service(service)

      render(conn, "destroy.json", %{service: service})
    rescue
      e in _ -> {:error, :unhandled_error}
    end
  end
end
