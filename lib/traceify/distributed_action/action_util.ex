defmodule Traceify.DistributedAction.ActionUtil do

  def token_valid?(conn, token) do
    header_token = Enum.find(conn.req_headers, fn(x) -> elem(x, 0) == "x-auth-token" end)
    header_token != nil && elem(header_token, 1) == token
  end

  

end
