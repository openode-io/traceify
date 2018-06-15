defmodule Traceify.DistributedAction.LocalSearch do

  def search(service, level, content) do
    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      {:ok, rows} = Sqlitex.query(
        db,
        "SELECT * FROM logs WHERE content LIKE ?1",
        bind: [content["search"]]
      )

      rows
    end)
  end

end
