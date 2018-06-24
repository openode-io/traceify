defmodule Traceify.DistributedAction.LocalSearchTest do

  use ExUnit.Case, async: true

  alias Traceify.DistributedAction.LocalSearch

  describe "LocalSearch > exec_search - base" do

    test "exec_search/3 basic info search" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "info",
        %{"search" => "coucou"}
        )

      [first | [ second | [] ]] = result

      assert first[:id] == 1
      assert first[:level] == "info"
      assert first[:content] == ~s(%{"coucou" => %{"toto" => "titi"}, "wtf" => "ddf"})
      assert second[:id] == 2
      assert second[:level] == "info"
      assert second[:content] == ~s(%{"coucou" => %{"toto" => "titi"}, "wtf" => "ddf"})
    end

    test "exec_search/3 search empty returns all" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{"search" => ""}
        )

      assert length(result) == 15
    end

  end

  describe "LocalSearch > exec_search - pagination" do
    test "exec_search/3 per_page = 2, page = 0" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{"search" => "", "per_page" => 2, "page" => 0}
        )

      [first | [ second | [] ]] = result

      assert length(result) == 2
      assert first[:id] == 1
      assert second[:id] == 2
    end

    test "exec_search/3 per_page = 2, page = 1" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{"search" => "", "per_page" => 2, "page" => 1}
        )

      [first | [ second | [] ]] = result

      assert length(result) == 2
      assert first[:id] == 3
      assert second[:id] == 4
    end

    test "exec_search/3 per_page = 2, page = 6" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{"search" => "", "per_page" => 2, "page" => 6}
        )

      [first | [ second | [] ]] = result

      assert length(result) == 2
      assert first[:id] == 13
      assert second[:id] == 14
    end

    test "exec_search/3 per_page = 2, page = 7" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{"search" => "", "per_page" => 2, "page" => 7}
        )

      [first | [ ]] = result

      assert length(result) == 1
      assert first[:id] == 15
    end
  end

  describe "LocalSearch > exec_search - level" do
    test "exec_search/3 with type error" do
      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "error",
        %{"search" => ""}
        )

      assert length(result) == 7
    end
  end

  describe "LocalSearch > exec_search - from - to" do
    test "exec_search/3 get on 21" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-06-20 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-06-22 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result) == 13
    end

    test "exec_search/3 get on 18" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-06-17 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-06-19 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result) == 2
    end

    test "exec_search/3 without result" do
      {_, from_dt, _} = DateTime.from_iso8601("2018-05-17 01:47:55+0000")
      {_, to_dt, _} = DateTime.from_iso8601("2018-05-19 01:47:55+0000")

      result = LocalSearch.exec_search(
        "test/traceify/distributed_action/fixtures/db_basic_logs.sqlite3",
        "",
        %{
          "search" => "",
          "from" => from_dt |> DateTime.to_unix,
          "to" => to_dt |> DateTime.to_unix
        }
        )

      assert length(result) == 0
    end
  end
end
