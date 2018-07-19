defmodule MyLogWorker do
  def perform(service, [level], content) do
    Traceify.Services.ensure_db(service)

    content_to_log = try do
      Poison.encode!(content)
    rescue
      e in _ -> inspect(content)
    end

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      Sqlitex.query!(
        db,
        "INSERT INTO logs (level, content) VALUES ($1, $2)",
        bind: [level, content_to_log]
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
