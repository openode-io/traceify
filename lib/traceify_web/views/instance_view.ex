defmodule TraceifyWeb.InstanceView do
  use TraceifyWeb, :view
  alias TraceifyWeb.InstanceView

  def render("index.json", %{instances: instances}) do
    %{data: render_many(instances, InstanceView, "instance.json")}
  end

  def render("log.json", %{}) do
    %{result: "success"}
  end

  def render("show.json", %{instance: instance}) do
    %{data: render_one(instance, InstanceView, "instance.json")}
  end

  def render("instance.json", %{instance: instance}) do
    %{id: instance.id,
      site_name: instance.site_name,
      token: instance.token}
  end
end
