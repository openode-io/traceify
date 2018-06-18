defmodule Traceify.DistributedAction.ActionUtilTest do

  use ExUnit.Case, async: true

  alias Traceify.DistributedAction.ActionUtil

  describe "ActionUtil > token_valid?" do

    test "token_valid?/2 with proper token should return true" do
      result = ActionUtil.token_valid?(%{:req_headers => [
          {"host", "localhost:4002"},
          {"user-agent", "curl/7.47.0"},
          {"accept", "*/*"},
          {"x-auth-token", "my-very-secret-token"},
          {"content-type", "application/json"},
          {"content-length", "45"}
        ]}, "my-very-secret-token")

      assert result == true
    end

    test "token_valid?/2 without token should return false" do
      result = ActionUtil.token_valid?(%{:req_headers => [
          {"host", "localhost:4002"},
          {"user-agent", "curl/7.47.0"},
          {"accept", "*/*"},
          {"content-type", "application/json"},
          {"content-length", "45"}
        ]}, "my-very-secret-token")

      assert result == false
    end

    test "token_valid?/2 with empty token should return false" do
      result = ActionUtil.token_valid?(%{:req_headers => [
          {"host", "localhost:4002"},
          {"user-agent", "curl/7.47.0"},
          {"x-auth-token", ""},
          {"accept", "*/*"},
          {"content-type", "application/json"},
          {"content-length", "45"}
        ]}, "my-very-secret-token")

      assert result == false
    end
  end
end
