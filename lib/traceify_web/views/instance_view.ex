defmodule TraceifyWeb.InstanceView do
  use TraceifyWeb, :view
  alias TraceifyWeb.InstanceView

  def render("index.json", %{}) do
    %{result: "success"}
  end

  def render("log.json", %{}) do
    %{result: "success"}
  end
end
