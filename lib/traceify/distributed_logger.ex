defmodule Traceify.Instances.DistributedLogger do

  alias Traceify.Instances.LocalLogger
  alias Traceify.Instances.RemoteLogger

  def log(conn, sitename, level, content) do

    url = "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
    IO.puts "url = #{url}"
    service = Traceify.Services.get_service_by_site_name!(sitename)

    logger_type = cond do
      service.storage_area.url == url ->
        "local"
      true ->
        "remote"
    end

    Module.concat(Traceify.Instances, "#{String.capitalize(logger_type)}Logger")
      |> apply(:log, [conn, service, level, content])
  end

end
