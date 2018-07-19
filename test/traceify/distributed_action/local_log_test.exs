defmodule Traceify.DistributedAction.LocalLogTest do

  use ExUnit.Case, async: true

  describe "LocalLog > MyLogWorker" do

    test "stringify_log_content - with empty json" do
      result = MyLogWorker.stringify_log_content(%{})
      assert result == "{}"
    end

    test "stringify_log_content - with json" do
      result = MyLogWorker.stringify_log_content(%{ "titi" => 1234})
      assert result == "{\"titi\":1234}"
    end

    test "stringify_log_content - with special case, empty value" do
      result = MyLogWorker.stringify_log_content(%{ "titi" => nil})
      assert result == "titi"
    end

    test "stringify_log_content - with special case, empty value with long key" do
      result = MyLogWorker.stringify_log_content(%{ "titi asf asdf asfd af fa \n asfdasdfasdf" => nil})
      assert result == "titi asf asdf asfd af fa \n asfdasdfasdf"
    end

    test "stringify_log_content - with special case, empty value with several keys" do
      result = MyLogWorker.stringify_log_content(%{ "titi" => nil, "tata": 1234})
      assert result == "{\"titi\":null,\"tata\":1234}"
    end

  end
end
