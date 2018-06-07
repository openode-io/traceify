defmodule Traceify.DistributedAction.RemoteAction do


  def action(conn, action, service, level, content) do
    # request
    url = "#{service.storage_area.url}#{conn.request_path}"

    header = [{"Accept", "application/json"},
              {"Content-Type", "application/json"},
              {"x-auth-token", service.token}
             ]
    body = Poison.encode!(content)

    case HTTPotion.post(url, [body: body, headers: header]) do
      %HTTPotion.Response{status_code: 200, body: body} ->
        "success"
      %HTTPotion.Response{status_code: _, body: body} ->
        body
      %HTTPotion.ErrorResponse{} ->
        "failure"
      true ->
        "failure"
    end
  end

end
