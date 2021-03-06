defmodule Traceify.ServicesTest do
  use Traceify.DataCase

  alias Traceify.Services

  describe "services" do
    alias Traceify.Services.Service

    @valid_attrs %{site_name: "some site_name", token: "some token"}
    @update_attrs %{site_name: "some updated site_name", token: "some updated token"}
    @invalid_attrs %{site_name: nil, token: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Services.create_service()

      service
    end

    @tag :skip
    test "list_services/0 returns all services" do
      service = service_fixture()
      assert Services.list_services() == [service]
    end

    @tag :skip
    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert Services.get_service!(service.id) == service
    end

    @tag :skip
    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = Services.create_service(@valid_attrs)
      assert service.site_name == "some site_name"
      assert service.token == "some token"
    end

    @tag :skip
    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Services.create_service(@invalid_attrs)
    end

    @tag :skip
    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, service} = Services.update_service(service, @update_attrs)
      assert %Service{} = service
      assert service.site_name == "some updated site_name"
      assert service.token == "some updated token"
    end

    @tag :skip
    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = Services.update_service(service, @invalid_attrs)
      assert service == Services.get_service!(service.id)
    end

    @tag :skip
    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = Services.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> Services.get_service!(service.id) end
    end

    @tag :skip
    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = Services.change_service(service)
    end
  end
end
