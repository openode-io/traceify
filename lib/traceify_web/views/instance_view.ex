defmodule TraceifyWeb.InstanceView do
  use TraceifyWeb, :view
  alias TraceifyWeb.InstanceView

  def render("index.json", %{}) do
    %{result: "success"}
  end

  def render("log.json", %{}) do
    %{result: "success"}
  end

  def render("search.json", %{result: result}) do
    render_many(result, __MODULE__, "log-entry.json", as: :log)
  end

  def render("log-entry.json", %{log: log}) do
    %{
      id: log[:id],
      level: log[:level],
      content: log[:content],
      created_at: log[:created_at]
    }
  end

end
