defmodule Traceify.DistributedAction do

  #alias Traceify.Instances.LocalLogger
  #alias Traceify.Instances.RemoteLogger
  alias Traceify.DistributedAction.ActionUtil
  alias Traceify.DistributedAction.RemoteAction

  def action(conn, action, sitename, level, content) do

    url = "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
    service = Traceify.Services.get_service_by_site_name!(sitename)

    unless ActionUtil.token_valid?(conn, service.token) do
      raise "No valid token provided"
    end

    logger_type = cond do
      service.storage_area.url == url ->
        "local"
      true ->
        "remote"
    end

    action_module = cond do
      logger_type == "local" ->
        action
      true ->
        "action"
    end

    IO.puts "logger type #{logger_type} action mod #{action_module}"

    Module.concat(Traceify.DistributedAction, "#{String.capitalize(logger_type)}#{String.capitalize(action_module)}")
      |> apply(String.to_atom(action_module), [service, level, content])
  end

end
