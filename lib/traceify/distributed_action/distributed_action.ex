defmodule Traceify.DistributedAction do

  require Logger
  alias Traceify.DistributedAction.ActionUtil
  alias Traceify.DistributedAction.RemoteAction

  def action(conn, action, sitename, levels, content) do
    url = "#{Atom.to_string(conn.scheme)}://#{conn.host}:#{conn.port}"
    Logger.info("Distributed action on #{url}")
    service = Traceify.Services.get_service_by_site_name!(sitename)

    unless ActionUtil.token_valid?(conn, service.user.token) do
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

    Module.concat(Traceify.DistributedAction, "#{String.capitalize(logger_type)}#{String.capitalize(action_module)}")
      |> apply(String.to_atom(action_module), [service, levels, content])
  end

end
