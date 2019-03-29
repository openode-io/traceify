defmodule Traceify.DistributedAction.LocalStats do

  def exec_stats(db_path) do
    size_in_bytes = case File.stat db_path do
      {:ok, %{size: size}} -> size
      {:error, _} -> 0
    end

    %{
      "size_in_mb" => size_in_bytes / 1000000
    }
  end

  def stats(service, [], %{}) do
    Traceify.Services.ensure_db(service)

    exec_stats(Traceify.Services.db_path(service))
  end

end
