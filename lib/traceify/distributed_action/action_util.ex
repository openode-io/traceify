defmodule Traceify.DistributedAction.ActionUtil do

  def token_valid?(conn, token) do
    header_token = Enum.find(conn.req_headers, fn(x) -> elem(x, 0) == "x-auth-token" end)
    header_token != nil && elem(header_token, 1) == token
  end

  def prepare_log_dir(service) do
    db_root_location = service.storage_area.root_path

    write_to_dir = "#{db_root_location}/#{service.site_name}"
    File.mkdir_p!(write_to_dir)

    write_to_dir
  end

end
