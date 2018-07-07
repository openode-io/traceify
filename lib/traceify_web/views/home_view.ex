defmodule TraceifyWeb.HomeView do
  use TraceifyWeb, :view

  alias Traceify.Mixfile

  def render("index.json", %{}) do
    %{
      welcome_to: "traceify"
    }
  end

  def render("version.json", %{}) do
    %{
      version: Traceify.Mixfile.project[:version]
    }
  end
end
