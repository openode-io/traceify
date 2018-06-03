defmodule Traceify.Instances.RemoteLogger do

  def log(conn, service, level, content) do
    # request
    IO.puts "remotee log path = #{conn.request_path}"

    url = "#{service.storage_area.url}#{conn.request_path}"

    IO.puts url

    header = [{"Accept", "application/json"},
              {"Content-Type", "application/json"}
             ]
    response = HTTPotion.post(url, [body: content, headers: header])

    IO.inspect response

    "success"
  end

end
