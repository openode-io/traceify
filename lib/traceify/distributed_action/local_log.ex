defmodule Traceify.DistributedAction.LocalLog do

  def log(service, [level], content) do
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
