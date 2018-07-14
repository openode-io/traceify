defmodule TraceifyWeb.NormalUserConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common datastructures and query the data layer.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest
      import TraceifyWeb.Router.Helpers

      # The default endpoint for testing
      @endpoint TraceifyWeb.Endpoint
    end
  end


  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Traceify.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Traceify.Repo, {:shared, self()})
    end

    conn = Phoenix.ConnTest.build_conn()
      |> Plug.Conn.put_req_header("x-auth-token", "my-very-secret-token")

    {:ok, conn: conn}
  end

end
