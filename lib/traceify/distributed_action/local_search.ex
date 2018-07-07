defmodule Traceify.DistributedAction.LocalSearch do

  # content
  #  - search: keyword
  #  - per_page: number of items per page
  #  - page: page #
  #  - from: unix timestamp
  #  - to: unix timestamp
  def exec_search(db_path, levels, content) do
    limit = content["per_page"] || 30
    page = content["page"] || 0
    offset = page * limit
    from = content["from"] || (Timex.shift(DateTime.utc_now, days: -31) |> DateTime.to_unix)
    to = content["to"] || (DateTime.utc_now |> DateTime.to_unix)

    stripped_levels = Enum.map(levels, &(String.replace(&1, ~r/[^a-z0-9-]/, "")))

    level_cond = cond do
      stripped_levels == [] -> ""
      true -> " AND level \
        IN(#{Enum.map(stripped_levels, &("'#{&1}'")) |> Enum.join(", ")}) "
    end

    Sqlitex.with_db(db_path, fn(db) ->
      {:ok, rows} = Sqlitex.query(db,
        "SELECT * FROM logs \
        WHERE content LIKE ?1 #{level_cond} AND \
        created_at BETWEEN DATETIME(?2, 'unixepoch') AND DATETIME(?3, 'unixepoch') \
        LIMIT ?4 OFFSET ?5 ",
        bind: ["%#{content["search"]}%", from, to, limit, offset]
      )

      rows
    end)
  end

  def search(service, level, content) do
    Traceify.Services.ensure_db(service)
    
    exec_search(Traceify.Services.db_path(service), level, content)
  end

end
