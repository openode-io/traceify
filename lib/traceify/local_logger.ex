defmodule Traceify.Instances.LocalLogger do

  def prepare_log_dir(sitename) do
    # LOCAL CASE
    db_root_location = "/home/martin/works/dump"

    t = DateTime.utc_now()
    t_date = DateTime.to_date(t)
    write_to_dir = "#{db_root_location}/#{Date.to_string(t_date)}/#{sitename}"
    File.mkdir_p!(write_to_dir)

    write_to_dir
  end

  def log(service, level, content) do
    # write_to_dir = prepare_log_dir(sitename)
    # File.write!("#{write_to_dir}/#{level}.log", "#{inspect(content)}\n", [:append])
    IO.puts "local loggerrr"
    IO.inspect service
  end

end
