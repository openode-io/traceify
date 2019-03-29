defmodule Traceify.DistributedAction.LocalStatsTest do

  use ExUnit.Case, async: true

  alias Traceify.DistributedAction.LocalStats

  describe "LocalStats > exec_stats - base" do

    test "exec_stats/1 basic" do
      result = LocalStats.exec_stats(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3")

      assert result["size_in_mb"] == 36864 / 1000000
    end
  end
end
