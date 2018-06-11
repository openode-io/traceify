defmodule Traceify.DistributedAction.LocalSearch do

  alias Traceify.DistributedAction.ActionUtil

  def search(service, level, content) do
    write_to_dir = ActionUtil.prepare_log_dir(service)

    Sqlitex.with_db("#{write_to_dir}/db.sqlite3", fn(db) ->
      {:ok, rows} = Sqlitex.query(
        db,
        "SELECT * FROM logs WHERE content LIKE ?1",
        bind: [content["search"]]
      )

      rows
    end)
  end

end
