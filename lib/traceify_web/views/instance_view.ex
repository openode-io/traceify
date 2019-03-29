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
    %{
      "total_nb_entries": result["total_nb_entries"],
      "nb_pages": result["nb_pages"],
      "results": render_many(result["results"], __MODULE__, "log-entry.json", as: :log)
    }
  end

  def render("stats.json", %{result: result}) do
    %{
      "size_in_mb": result["size_in_mb"]
    }
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
