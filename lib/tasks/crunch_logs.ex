defmodule Traceify.Task.CrunchLogs do
  alias Traceify.Services.Service
  alias Traceify.MyLogWorker
  alias Traceify.RedixPool, as: Redis

  def ts_from_ids(ids) do
    items = String.split(ids, "_")

    [ timestamp | [_] ] = items

    {res_convrt, _} = Integer.parse(timestamp)
    {:ok, converted_date} = DateTime.from_unix(res_convrt)

    converted_date
  end

  def perform do
    t1 = DateTime.utc_now

    {:ok, traceify_pending_logs} = Redis.command(["KEYS", "#{MyLogWorker.prefix_pending_logs}*"])

    sitenames_logs =
      Enum.map(traceify_pending_logs, fn(key) -> String.split(key, MyLogWorker.pending_logs_delimiter) end)
      |> Enum.sort
      |> Enum.map(fn([begin, sitename, level, ids]) ->
        key_to_find = Enum.join([begin, sitename, level, ids], "=")

        {:ok, content} = Redis.command(["GET", key_to_find])

        %{
          "sitename" => sitename,
          "content" => content,
          "level" => level,
          "key" => key_to_find,
          "ts" => DateTime.to_string(ts_from_ids(ids))
        }
      end)
      # with pairs sitename -> content, build back a Map
      |> Enum.reduce(%{}, fn(element, acc) ->
          cur_logs = Map.get(acc, element["sitename"], [])

          Map.put(acc, element["sitename"], cur_logs ++ [element])
        end)

    # create a task for each given sitename
    tasks = for sitename <- Map.keys(sitenames_logs) do
      try do
        service = Traceify.Services.get_service_by_site_name!(sitename)

        Task.async(fn ->
          MyLogWorker.perform(service, Map.get(sitenames_logs, sitename))
        end)
      rescue
        e in _ -> nil
      end
    end

    # execute them in parallel - wait for the results
    Task.yield_many(Enum.filter(tasks, fn(t) -> t != nil end), 45000)

    t2 = DateTime.utc_now
    took = Timex.diff(t2, t1, :milliseconds)

    IO.puts "took -> #{took} ms"
  end
end
