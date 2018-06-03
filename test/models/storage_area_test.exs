defmodule Traceify.StorageAreaTest do
  use Traceify.ModelCase

  alias Traceify.StorageArea

  @valid_attrs %{host: "some host", name: "some name", root_path: "some root_path"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StorageArea.changeset(%StorageArea{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StorageArea.changeset(%StorageArea{}, @invalid_attrs)
    refute changeset.valid?
  end
end
