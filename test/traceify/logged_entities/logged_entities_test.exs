defmodule Traceify.LoggedEntitiesTest do
  use Traceify.DataCase

  alias Traceify.LoggedEntities

  describe "storage_areas" do
    alias Traceify.LoggedEntities.StorageArea

    @valid_attrs %{host: "some host", name: "some name", root_path: "some root_path"}
    @update_attrs %{host: "some updated host", name: "some updated name", root_path: "some updated root_path"}
    @invalid_attrs %{host: nil, name: nil, root_path: nil}

    def storage_area_fixture(attrs \\ %{}) do
      {:ok, storage_area} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LoggedEntities.create_storage_area()

      storage_area
    end

    test "list_storage_areas/0 returns all storage_areas" do
      storage_area = storage_area_fixture()
      assert LoggedEntities.list_storage_areas() == [storage_area]
    end

    test "get_storage_area!/1 returns the storage_area with given id" do
      storage_area = storage_area_fixture()
      assert LoggedEntities.get_storage_area!(storage_area.id) == storage_area
    end

    test "create_storage_area/1 with valid data creates a storage_area" do
      assert {:ok, %StorageArea{} = storage_area} = LoggedEntities.create_storage_area(@valid_attrs)
      assert storage_area.host == "some host"
      assert storage_area.name == "some name"
      assert storage_area.root_path == "some root_path"
    end

    test "create_storage_area/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LoggedEntities.create_storage_area(@invalid_attrs)
    end

    test "update_storage_area/2 with valid data updates the storage_area" do
      storage_area = storage_area_fixture()
      assert {:ok, storage_area} = LoggedEntities.update_storage_area(storage_area, @update_attrs)
      assert %StorageArea{} = storage_area
      assert storage_area.host == "some updated host"
      assert storage_area.name == "some updated name"
      assert storage_area.root_path == "some updated root_path"
    end

    test "update_storage_area/2 with invalid data returns error changeset" do
      storage_area = storage_area_fixture()
      assert {:error, %Ecto.Changeset{}} = LoggedEntities.update_storage_area(storage_area, @invalid_attrs)
      assert storage_area == LoggedEntities.get_storage_area!(storage_area.id)
    end

    test "delete_storage_area/1 deletes the storage_area" do
      storage_area = storage_area_fixture()
      assert {:ok, %StorageArea{}} = LoggedEntities.delete_storage_area(storage_area)
      assert_raise Ecto.NoResultsError, fn -> LoggedEntities.get_storage_area!(storage_area.id) end
    end

    test "change_storage_area/1 returns a storage_area changeset" do
      storage_area = storage_area_fixture()
      assert %Ecto.Changeset{} = LoggedEntities.change_storage_area(storage_area)
    end
  end

  describe "services" do
    alias Traceify.LoggedEntities.Service

    @valid_attrs %{site_name: "some site_name", token: "some token"}
    @update_attrs %{site_name: "some updated site_name", token: "some updated token"}
    @invalid_attrs %{site_name: nil, token: nil}

    def service_fixture(attrs \\ %{}) do
      {:ok, service} =
        attrs
        |> Enum.into(@valid_attrs)
        |> LoggedEntities.create_service()

      service
    end

    test "list_services/0 returns all services" do
      service = service_fixture()
      assert LoggedEntities.list_services() == [service]
    end

    test "get_service!/1 returns the service with given id" do
      service = service_fixture()
      assert LoggedEntities.get_service!(service.id) == service
    end

    test "create_service/1 with valid data creates a service" do
      assert {:ok, %Service{} = service} = LoggedEntities.create_service(@valid_attrs)
      assert service.site_name == "some site_name"
      assert service.token == "some token"
    end

    test "create_service/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = LoggedEntities.create_service(@invalid_attrs)
    end

    test "update_service/2 with valid data updates the service" do
      service = service_fixture()
      assert {:ok, service} = LoggedEntities.update_service(service, @update_attrs)
      assert %Service{} = service
      assert service.site_name == "some updated site_name"
      assert service.token == "some updated token"
    end

    test "update_service/2 with invalid data returns error changeset" do
      service = service_fixture()
      assert {:error, %Ecto.Changeset{}} = LoggedEntities.update_service(service, @invalid_attrs)
      assert service == LoggedEntities.get_service!(service.id)
    end

    test "delete_service/1 deletes the service" do
      service = service_fixture()
      assert {:ok, %Service{}} = LoggedEntities.delete_service(service)
      assert_raise Ecto.NoResultsError, fn -> LoggedEntities.get_service!(service.id) end
    end

    test "change_service/1 returns a service changeset" do
      service = service_fixture()
      assert %Ecto.Changeset{} = LoggedEntities.change_service(service)
    end
  end
end
