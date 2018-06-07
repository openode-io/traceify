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

  defp distributed_action(conn, action, sitename, level, params) do
    try do
      IO.puts "distribut .. #{action}"
      result = DistributedAction.action(conn, action, sitename, level, conn.body_params)

      cond do
        result == "success" -> render(conn, "#{action}.json")
        true -> handle_error(conn, 500, result)
      end

    rescue
      e in File.Error -> handle_error(conn, 500, File.Error.message(e))
      e in RuntimeError -> handle_error(conn, 500, RuntimeError.message(e))
    end
  end

  def log(conn, %{"sitename" => sitename, "level" => level}) do
    distributed_action(conn, "log", sitename, level, conn.body_params)
  end

  def search(conn, %{"sitename" => sitename, "level" => level}) do
    distributed_action(conn, "search", sitename, level, conn.body_params)
  end

end
