defmodule Traceify.DistributedAction.LocalSearch do

  defp do_search_with_results(db_path, opts) do
    Sqlitex.with_db(db_path, fn(db) ->
      query = "SELECT * FROM logs \
      WHERE #{opts["search"]} #{opts["level_cond"]} AND \
      created_at BETWEEN DATETIME(#{opts["from"]}, 'unixepoch') AND DATETIME(#{opts["to"]}, 'unixepoch') \
      ORDER BY created_at DESC \
      LIMIT #{opts["limit"]} OFFSET #{opts["offset"]}  "

      {:ok, results} = Sqlitex.query(db, query, bind: [])

      results
    end)

  end

  defp gen_level_cond(levels) do
    stripped_levels = Enum.map(levels, &(String.replace(&1, ~r/[^a-z0-9-]/, "")))

    cond do
      stripped_levels == [] -> ""
      true -> " AND level \
        IN(#{Enum.map(stripped_levels, &("'#{&1}'")) |> Enum.join(", ")}) "
    end
  end

  defp gen_search_cond(search) do
    case search do
      "" -> " 1 = 1 "
      nil -> " 1 = 1 "
      _ -> " logs MATCH '*#{search}*' "
    end
  end

  defp calculate_total_nb_entries(db_path, opts) do
    Sqlitex.with_db(db_path, fn(db) ->
      {:ok, resCnt} = Sqlitex.query(db,
        "SELECT COUNT(*) as cnt FROM logs \
        WHERE ?1 #{opts["level_cond"]} AND \
        created_at BETWEEN DATETIME(?2, 'unixepoch') AND DATETIME(?3, 'unixepoch')",
        bind: [opts["search"], opts["from"], opts["to"]]
      )

      (Enum.at(resCnt, 0))[:cnt]
    end)
  end

  defp prepare_options(content, level_cond) do
    limit = content["per_page"] || 30
    page = content["page"] || 0
    offset = page * limit
    from = content["from"] || (Timex.shift(DateTime.utc_now, days: -31) |> DateTime.to_unix)
    to = content["to"] || (DateTime.utc_now |> DateTime.to_unix)
    search = gen_search_cond(content["search"])

    %{
      "limit" => limit,
      "page" => page,
      "offset" => offset,
      "from" => from,
      "to" => to,
      "search" => search,
      "level_cond" => level_cond
    }
  end

  # content
  #  - search: keyword
  #  - per_page: number of items per page
  #  - page: page #
  #  - from: unix timestamp
  #  - to: unix timestamp
  def exec_search(db_path, levels, content) do
    level_cond = gen_level_cond(levels)
    opts = prepare_options(content, level_cond)

    results = do_search_with_results(db_path, opts)
    total_nb_entries = calculate_total_nb_entries(db_path, opts)
    nb_pages = Kernel.trunc(Float.ceil(total_nb_entries / opts["limit"]))

    %{
      "results" => results,
      "total_nb_entries" => total_nb_entries,
      "nb_pages" => nb_pages
    }
  end

  def search(service, level, content) do
    Traceify.Services.ensure_db(service)

    exec_search(Traceify.Services.db_path(service), level, content)
  end

end
