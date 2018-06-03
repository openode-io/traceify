defmodule Traceify.StorageAreasTest do
  use Traceify.DataCase

  alias Traceify.StorageAreas

  describe "storage_areas" do
    alias Traceify.StorageAreas.StorageArea

    @valid_attrs %{host: "some host", name: "some name", root_path: "some root_path"}
    @update_attrs %{host: "some updated host", name: "some updated name", root_path: "some updated root_path"}
    @invalid_attrs %{host: nil, name: nil, root_path: nil}

    def storage_area_fixture(attrs \\ %{}) do
      {:ok, storage_area} =
        attrs
        |> Enum.into(@valid_attrs)
        |> StorageAreas.create_storage_area()

      storage_area
    end

    test "list_storage_areas/0 returns all storage_areas" do
      storage_area = storage_area_fixture()
      assert StorageAreas.list_storage_areas() == [storage_area]
    end

    test "get_storage_area!/1 returns the storage_area with given id" do
      storage_area = storage_area_fixture()
      assert StorageAreas.get_storage_area!(storage_area.id) == storage_area
    end

    test "create_storage_area/1 with valid data creates a storage_area" do
      assert {:ok, %StorageArea{} = storage_area} = StorageAreas.create_storage_area(@valid_attrs)
      assert storage_area.host == "some host"
      assert storage_area.name == "some name"
      assert storage_area.root_path == "some root_path"
    end

    test "create_storage_area/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = StorageAreas.create_storage_area(@invalid_attrs)
    end

    test "update_storage_area/2 with valid data updates the storage_area" do
      storage_area = storage_area_fixture()
      assert {:ok, storage_area} = StorageAreas.update_storage_area(storage_area, @update_attrs)
      assert %StorageArea{} = storage_area
      assert storage_area.host == "some updated host"
      assert storage_area.name == "some updated name"
      assert storage_area.root_path == "some updated root_path"
    end

    test "update_storage_area/2 with invalid data returns error changeset" do
      storage_area = storage_area_fixture()
      assert {:error, %Ecto.Changeset{}} = StorageAreas.update_storage_area(storage_area, @invalid_attrs)
      assert storage_area == StorageAreas.get_storage_area!(storage_area.id)
    end

    test "delete_storage_area/1 deletes the storage_area" do
      storage_area = storage_area_fixture()
      assert {:ok, %StorageArea{}} = StorageAreas.delete_storage_area(storage_area)
      assert_raise Ecto.NoResultsError, fn -> StorageAreas.get_storage_area!(storage_area.id) end
    end

    test "change_storage_area/1 returns a storage_area changeset" do
      storage_area = storage_area_fixture()
      assert %Ecto.Changeset{} = StorageAreas.change_storage_area(storage_area)
    end
  end
end
