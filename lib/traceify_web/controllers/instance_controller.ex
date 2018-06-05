defmodule TraceifyWeb.InstanceController do
  use TraceifyWeb, :controller

  alias Traceify.DistributedAction
  alias TraceifyWeb.InstanceController

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    render(conn, "index.json")
  end

  def handle_error(conn, code, msg) do
    conn
    |> put_status(:internal_server_error)
    |> render(TraceifyWeb.ErrorView, "500.json", %{msg: msg})
  end

  def log(conn, %{"sitename" => sitename, "level" => level}) do
    try do
      IO.puts "i log"
      result = DistributedAction.action(conn, "log", sitename, level, conn.body_params)

      cond do
        result == "success" -> render(conn, "log.json")
        true -> handle_error(conn, 500, result)
      end

    rescue
      e in File.Error -> handle_error(conn, 500, File.Error.message(e))
      e in RuntimeError -> handle_error(conn, 500, RuntimeError.message(e))
    end
  end

  def search(conn, %{"sitename" => sitename, "level" => level}) do
    try do
      service = Traceify.Services.get_service_by_site_name!(sitename)

      #cond do
      #  result == "success" -> render(conn, "log.json")
      #  true -> handle_error(conn, 500, result)
      #end
      IO.puts "coucou"

      render(conn, "log.json")
    rescue
      e in File.Error -> handle_error(conn, 500, File.Error.message(e))
      e in RuntimeError -> handle_error(conn, 500, RuntimeError.message(e))
    end
  end

end
