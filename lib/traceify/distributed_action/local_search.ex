defmodule Traceify.DistributedAction.LocalSearch do

  # content
  #  - search: keyword
  #  - per_page: number of items per page
  #  - page: page #
  #  - from: unix timestamp
  #  - to: unix timestamp
  def exec_search(db_path, level, content) do
    limit = content["per_page"] || 30
    page = content["page"] || 0
    offset = page * limit
    from = content["from"] || (Timex.shift(DateTime.utc_now, days: -31) |> DateTime.to_unix)
    to = content["to"] || (DateTime.utc_now |> DateTime.to_unix)

    if level == "" do
      level = "%"
    end

    Sqlitex.with_db(db_path, fn(db) ->
      {:ok, rows} = Sqlitex.query(db,
        "SELECT * FROM logs \
        WHERE content LIKE ?1 AND level LIKE ?2 AND \
        created_at BETWEEN DATETIME(?3, 'unixepoch') AND DATETIME(?4, 'unixepoch') \
        LIMIT ?5 OFFSET ?6 ",
        bind: ["%#{content["search"]}%", level, from, to, limit, offset]
      )

      rows
    end)
  end

  def search(service, level, content) do
    exec_search(Traceify.Services.db_path(service), level, content)
  end

end
