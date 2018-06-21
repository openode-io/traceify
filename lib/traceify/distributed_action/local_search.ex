defmodule Traceify.DistributedAction.LocalSearch do

  # content
  #  - search: keyword
  #  - per_page: number of items per page
  #  - page: page #
  def exec_search(db_path, level, content) do
    limit = content["per_page"] || 30
    page = content["page"] || 0
    offset = page * limit

    Sqlitex.with_db(db_path, fn(db) ->
      {:ok, rows} = Sqlitex.query(db,
        "SELECT * FROM logs WHERE content LIKE ?1 LIMIT ?2 OFFSET ?3 ",
        bind: ["%#{content["search"]}%", limit, offset]
      )

      rows
    end)
  end

  def search(service, level, content) do
    exec_search(Traceify.Services.db_path(service), level, content)
  end

end
