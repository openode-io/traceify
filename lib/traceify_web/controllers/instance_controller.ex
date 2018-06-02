defmodule TraceifyWeb.InstanceController do
  use TraceifyWeb, :controller

  alias Traceify.Instances
  alias Traceify.Instances.Instance
  alias Traceify.Instances.LocalLogger

  action_fallback TraceifyWeb.FallbackController

  def index(conn, _params) do
    instances = Instances.list_instances()
    render(conn, "index.json", instances: instances)
  end


  def log(conn, %{"sitename" => sitename, "level" => level}) do

    try do
      LocalLogger.log(sitename, level, conn.body_params)
    rescue
      e in File.Error -> IO.puts "#{File.Error.message(e)}"
    end

    render(conn, "log.json")
  end

  def create(conn, %{"instance" => instance_params}) do
    with {:ok, %Instance{} = instance} <- Instances.create_instance(instance_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", instance_path(conn, :show, instance))
      |> render("show.json", instance: instance)
    end
  end

  def show(conn, %{"id" => id}) do
    instance = Instances.get_instance!(id)
    render(conn, "show.json", instance: instance)
  end

  def update(conn, %{"id" => id, "instance" => instance_params}) do
    instance = Instances.get_instance!(id)

    with {:ok, %Instance{} = instance} <- Instances.update_instance(instance, instance_params) do
      render(conn, "show.json", instance: instance)
    end
  end

  def delete(conn, %{"id" => id}) do
    instance = Instances.get_instance!(id)
    with {:ok, %Instance{}} <- Instances.delete_instance(instance) do
      send_resp(conn, :no_content, "")
    end
  end
end
