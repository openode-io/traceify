defmodule TraceifyWeb.Admin.ServiceView do
  use TraceifyWeb, :view
  alias TraceifyWeb.Admin.ServiceView

  def render("create.json", %{service: service}) do
    %{
      id: service.id
    }
  end

  def render("exists.json", %{service: service}) do
    %{
      id: service.id,
      site_name: service.site_name
    }
  end

  def render("destroy.json", %{service: service}) do
    %{
      id: service.id
    }
  end

  def render("default.json", %{}) do
    %{
      result: "success"
    }
  end
end
