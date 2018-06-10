defmodule Traceify.DistributedAction.LocalLog do

  def prepare_log_dir(service) do
    db_root_location = service.storage_area.root_path

    write_to_dir = "#{db_root_location}/#{service.site_name}"
    File.mkdir_p!(write_to_dir)

    write_to_dir
  end



  defp init_db(write_to_dir) do
    ctbl = """
      CREATE TABLE IF NOT EXISTS logs (
        id integer PRIMARY KEY AUTOINCREMENT,
        level VARCHAR(15) NOT NULL,
        content TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    """

    Sqlitex.with_db("#{write_to_dir}/db.sqlite3", fn(db) ->
      Sqlitex.query(db, ctbl)
    end)
  end

  def log(service, level, content) do
    write_to_dir = prepare_log_dir(service)
    init_db(write_to_dir)
    IO.puts "content=#{inspect(content)}"

    Sqlitex.with_db("#{write_to_dir}/db.sqlite3", fn(db) ->
      Sqlitex.query!(
        db,
        "INSERT INTO logs (level, content) VALUES ($1, $2)",
        bind: [level, inspect(content)]
      )
    end)

    "success"
  end

end
