defmodule Traceify.Instances.DistributedLogger do

  alias Traceify.Instances.LocalLogger

  def log(sitename, level, content) do

    service = Traceify.Services.get_service_by_site_name!(sitename)

    logger_type = cond do
      service.storage_area.host == System.get_env("CURRENT_HOST") ->
        "local"
      true ->
        "remote"
    end

    # IO.inspect logger_type("Elixir.Module")

    Module.concat(Traceify.Instances, "#{String.capitalize(logger_type)}Logger")
      |> apply(:log, [service, level, content])

    #write_to_dir = prepare_log_dir(sitename)
    #File.write!("#{write_to_dir}/#{level}.log", "#{inspect(content)}\n", [:append])
  end

end
