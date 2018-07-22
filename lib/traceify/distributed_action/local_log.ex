defmodule Traceify.MyLogWorker do
  alias Traceify.RedixPool, as: Redis

  def pending_logs_delimiter, do: "="
  def prefix_pending_logs, do: "traceify#{pending_logs_delimiter}"

  def stringify_log_content(content) do
    try do
      cond do
        length(Map.keys(content)) == 1 && Map.values(content) == [nil] -> Map.keys(content) |> Enum.at(0)
        true -> Poison.encode!(content)
      end
    rescue
      e in _ -> inspect(content)
    end
  end

  def perform(service, logs) do
    Traceify.Services.ensure_db(service)

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      Enum.each(logs, fn(log) ->
        IO.puts "logging"
        IO.inspect log
        Sqlitex.query!(
          db,
          "INSERT INTO logs (level, content) VALUES ($1, $2)",
          bind: [log["level"], stringify_log_content(log["content"])]
        )
        Redis.command(["DEL", log["key"]])
      end)
    end)

    "success"
  end

  def log(service, level, content) do
    ts = DateTime.utc_now |> DateTime.to_unix
    key_name = "traceify=#{service.site_name}=#{level}=#{ts}_#{:rand.uniform(1000000)}"

    Redis.command(["SET", "#{key_name}", stringify_log_content(content)])
  end
end

defmodule Traceify.DistributedAction.LocalLog do
  alias Traceify.Services.Service

  def log(service, [level], content) do
    Traceify.MyLogWorker.log(service, level, content)

    "success"
  end

end
