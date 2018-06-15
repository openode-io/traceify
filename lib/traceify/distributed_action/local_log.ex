defmodule Traceify.DistributedAction.LocalLog do

  defp init_db(service) do
    ctbl = """
      CREATE TABLE IF NOT EXISTS logs (
        id integer PRIMARY KEY AUTOINCREMENT,
        level VARCHAR(15) NOT NULL,
        content TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    """

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      Sqlitex.query(db, ctbl)
      Sqlitex.query(db, "CREATE INDEX level_ind ON logs(level)")
      Sqlitex.query(db, "CREATE INDEX content_ind ON logs(content)")
    end)
  end

  def log(service, level, content) do
    init_db(service)

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
