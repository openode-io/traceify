defmodule Traceify.DistributedAction.LocalSearchTest do

  use ExUnit.Case, async: true

  alias Traceify.DistributedAction.LocalSearch

  describe "LocalSearch > exec_search - base" do

    test "exec_search/3 basic info search" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        ["info"],
        %{"search" => "coucou", "from" => 0}
        )

      [first | [ second | [] ]] = result["results"]

      assert first[:id] == 2
      assert first[:level] == "info"
      assert first[:content] == ~s(%{"coucou" => %{"toto" => "titi"}, "wtf" => "ddf"})
      assert second[:id] == 1
      assert second[:level] == "info"
      assert second[:content] == ~s(%{"coucou" => %{"toto" => "titi"}, "wtf" => "ddf"})
    end

    test "exec_search/3 search empty returns all" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{"search" => "", "from" => 0}
        )

      assert length(result["results"]) == 15
    end

  end

  describe "LocalSearch > exec_search - pagination" do
    test "exec_search/3 per_page = 2, page = 0" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{"search" => "", "per_page" => 2, "page" => 0, "from" => 0}
        )

      [first | [ second | [] ]] = result["results"]

      assert length(result["results"]) == 2
      assert first[:id] == 15
      assert second[:id] == 12
    end

    test "exec_search/3 per_page = 2, page = 1" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{"search" => "", "per_page" => 2, "page" => 1, "from" => 0}
        )

      [first | [ second | [] ]] = result["results"]

      assert length(result["results"]) == 2
      assert first[:id] == 13
      assert second[:id] == 14
    end

    test "exec_search/3 per_page = 2, page = 6" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{"search" => "", "per_page" => 2, "page" => 6, "from" => 0}
        )

      [first | [ second | [] ]] = result["results"]

      assert length(result["results"]) == 2
      assert first[:id] == 3
      assert second[:id] == 2
    end

    test "exec_search/3 per_page = 2, page = 7" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{"search" => "", "per_page" => 2, "page" => 7, "from" => 0}
        )

      [first | [ ]] = result["results"]

      assert length(result["results"]) == 1
      assert first[:id] == 1
    end
  end

  describe "LocalSearch > exec_search - level" do
    test "exec_search/3 with type error" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        ["error"],
        %{"search" => "", "from" => 0}
        )

      assert length(result["results"]) == 7
    end

    test "exec_search/3 with type error and info" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        ["error", "debug"],
        %{"search" => "", "from" => 0}
        )
        
      assert length(result["results"]) == 12
    end
  end

  describe "LocalSearch > exec_search - from - to" do
    test "exec_search/3 get on 21" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-06-20 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-06-22 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result["results"]) == 13
    end

    test "exec_search/3 get on 18" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-06-17 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-06-19 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result["results"]) == 2
    end

    test "exec_search/3 without result" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-05-17 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-05-19 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        [],
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result["results"]) == 0
    end
  end
end
