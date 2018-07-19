defmodule MyLogWorker do
  def stringify_log_content(content) do
    content_to_log = try do
      keys =

      cond do
        length(Map.keys(content)) == 1 && Map.values(content) == [nil] -> Enum.at(Map.keys(content), 0)
        true -> Poison.encode!(content)
      end
    rescue
      e in _ -> inspect(content)
    end
  end

  def perform(service, [level], content) do
    Traceify.Services.ensure_db(service)
    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      Sqlitex.query!(
        db,
        "INSERT INTO logs (level, content) VALUES ($1, $2)",
        bind: [level, stringify_log_content(content)]
      )
    end)

    "success"
  end
end

defmodule Traceify.DistributedAction.LocalLog do

  alias Traceify.Services.Service

  def log(service, [level], content) do
    service_worker = %{"site_name" => service.site_name, "root_path": service.storage_area.root_path}

    {:ok, _} = Exq.enqueue(Exq, "default", MyLogWorker, [service_worker, [level], content])

    "success"
  end

end
