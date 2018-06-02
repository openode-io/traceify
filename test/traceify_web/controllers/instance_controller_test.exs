defmodule TraceifyWeb.InstanceControllerTest do
  use TraceifyWeb.ConnCase

  alias Traceify.Instances
  alias Traceify.Instances.Instance

  @create_attrs %{site_name: "some site_name", token: "some token"}
  @update_attrs %{site_name: "some updated site_name", token: "some updated token"}
  @invalid_attrs %{site_name: nil, token: nil}

  def fixture(:instance) do
    {:ok, instance} = Instances.create_instance(@create_attrs)
    instance
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all instances", %{conn: conn} do
      conn = get conn, instance_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create instance" do
    test "renders instance when data is valid", %{conn: conn} do
      conn = post conn, instance_path(conn, :create), instance: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, instance_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "site_name" => "some site_name",
        "token" => "some token"}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, instance_path(conn, :create), instance: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update instance" do
    setup [:create_instance]

    test "renders instance when data is valid", %{conn: conn, instance: %Instance{id: id} = instance} do
      conn = put conn, instance_path(conn, :update, instance), instance: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, instance_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "site_name" => "some updated site_name",
        "token" => "some updated token"}
    end

    test "renders errors when data is invalid", %{conn: conn, instance: instance} do
      conn = put conn, instance_path(conn, :update, instance), instance: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete instance" do
    setup [:create_instance]

    test "deletes chosen instance", %{conn: conn, instance: instance} do
      conn = delete conn, instance_path(conn, :delete, instance)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, instance_path(conn, :show, instance)
      end
    end
  end

  defp create_instance(_) do
    instance = fixture(:instance)
    {:ok, instance: instance}
  end
end
