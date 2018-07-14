defmodule MyLogWorker do
  def perform(service, [level], content) do
    Traceify.Services.ensure_db(service)

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      Sqlitex.query!(
        db,
        "INSERT INTO logs (level, content) VALUES ($1, $2)",
        bind: [level, inspect(content)]
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
