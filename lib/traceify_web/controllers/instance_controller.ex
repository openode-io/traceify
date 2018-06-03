defmodule TraceifyWeb.InstanceController do
  use TraceifyWeb, :controller

  alias Traceify.Instances.DistributedLogger

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    render(conn, "index.json")
  end


  def log(conn, %{"sitename" => sitename, "level" => level}) do
    try do
      result = DistributedLogger.log(conn, sitename, level, conn.body_params)
      IO.puts "result = #{result}"
    rescue
      e in File.Error -> IO.puts "#{File.Error.message(e)}"
    end

    render(conn, "log.json")
  end

end
