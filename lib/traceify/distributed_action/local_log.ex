defmodule Traceify.DistributedAction.LocalLog do

  def prepare_log_dir(service, t) do
    db_root_location = service.storage_area.root_path

    write_to_dir = "#{db_root_location}/#{service.site_name}"
    File.mkdir_p!(write_to_dir)

    write_to_dir
  end

  def log(service, level, content) do

    ctbl = "todo" #"CREATE TABLE contacts (contact_id integer PRIMARY KEY, first_name text NOT NULL, last_name text NOT NULL, email text NOT NULL UNIQUE, phone text NOT NULL UNIQUE);"

    t = DateTime.utc_now()
    t_date = DateTime.to_date(t)
    write_to_dir = prepare_log_dir(service, t)

    Sqlitex.with_db("#{write_to_dir}/test.sqlite3", fn(db) ->
      Sqlitex.query(db, ctbl)
    end)

    line_2_log = "#{DateTime.to_string(t)} - [#{level}] - #{inspect(content)}\n"

    File.write!("#{write_to_dir}/#{Date.to_string(t_date)}.log", line_2_log, [:append])

    "success"
  end

end
