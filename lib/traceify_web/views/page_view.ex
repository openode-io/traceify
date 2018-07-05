defmodule TraceifyWeb.PageView do
  use TraceifyWeb, :view

  alias Traceify.Mixfile

  def render("index.json", %{}) do
    %{
      welcome_to: "traceify",
      version: Traceify.Mixfile.project[:version]
    }
  end
end
