defmodule Traceify.MyLogWorker do
  alias Traceify.RedixPool, as: Redis

  def pending_logs_delimiter, do: "="
  def prefix_pending_logs, do: "traceify#{pending_logs_delimiter}"
  import Logger

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

  defp remove_old_records(db, max_days_retentions) do
    Sqlitex.query!(
      db,
      "DELETE FROM logs WHERE created_at < datetime('now', '-$1 days')",
      bind: [max_days_retentions]
    )
  end

  defp insert_log(db, level, content, timestamp) do
    Sqlitex.query!(
      db,
      "INSERT INTO logs (level, content, created_at) VALUES ($1, $2, $3)",
      bind: [level, content, timestamp]
    )
  end

  defp remove_tmp_log(key) do
    Redis.command(["DEL", key])
  end

  def perform(service, logs) do
    Traceify.Services.ensure_db(service)

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      try do
        # TODO: fix
        # remove_old_records(db, System.get_env("MAX_DAYS_RETENTION") || 31)

        Enum.each(logs, fn(log) ->
          insert_log(db, log["level"], log["content"], log["ts"])

          remove_tmp_log(log["key"])
        end)
      rescue
        e in _ -> IO.inspect e #Logger.error("could not perform log properly")
      end
    end)

    "success"
  end

  def log(service, level, content) do
    ts = DateTime.utc_now |> DateTime.to_unix
    key_name = "traceify=#{service.site_name}=#{level}=#{ts}_#{:rand.uniform(1000000)}"

    Redis.command(["SET", "#{key_name}", Traceify.MyLogWorker.stringify_log_content(content)])
  end
end

defmodule Traceify.DistributedAction.LocalLog do
  alias Traceify.Services.Service

  def log(service, [level], content) do
    Traceify.MyLogWorker.log(service, level, content)

    "success"
  end

end
