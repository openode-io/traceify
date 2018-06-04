defmodule Traceify.Instances.DistributedLogger do

  alias Traceify.Instances.LocalLogger
  alias Traceify.Instances.RemoteLogger
  alias Traceify.Instances.LoggerUtil

  def log(conn, sitename, level, content) do

    url = "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
    service = Traceify.Services.get_service_by_site_name!(sitename)

    unless LoggerUtil.token_valid?(conn, service.token) do
      raise "No valid token provided"
    end

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
