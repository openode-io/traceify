defmodule Traceify.StorageAreas do
  @moduledoc """
  The StorageAreas context.
  """

  import Ecto.Query, warn: false
  alias Traceify.Repo

  alias Traceify.StorageAreas.StorageArea

  @doc """
  Returns the list of storage_areas.

  ## Examples

      iex> list_storage_areas()
      [%StorageArea{}, ...]

  """
  def list_storage_areas do
    Repo.all(StorageArea)
  end

  def first_storage_areas do
    Repo.one(StorageArea)
  end

  @doc """
  Gets a single storage_area.

  Raises `Ecto.NoResultsError` if the Storage area does not exist.

  ## Examples

      iex> get_storage_area!(123)
      %StorageArea{}

      iex> get_storage_area!(456)
      ** (Ecto.NoResultsError)

  """
  def get_storage_area!(id), do: Repo.get!(StorageArea, id)

  @doc """
  Creates a storage_area.

  ## Examples

      iex> create_storage_area(%{field: value})
      {:ok, %StorageArea{}}

      iex> create_storage_area(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_storage_area(attrs \\ %{}) do
    %StorageArea{}
    |> StorageArea.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a storage_area.

  ## Examples

      iex> update_storage_area(storage_area, %{field: new_value})
      {:ok, %StorageArea{}}

      iex> update_storage_area(storage_area, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_storage_area(%StorageArea{} = storage_area, attrs) do
    storage_area
    |> StorageArea.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a StorageArea.

  ## Examples

      iex> delete_storage_area(storage_area)
      {:ok, %StorageArea{}}

      iex> delete_storage_area(storage_area)
      {:error, %Ecto.Changeset{}}

  """
  def delete_storage_area(%StorageArea{} = storage_area) do
    Repo.delete(storage_area)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking storage_area changes.

  ## Examples

      iex> change_storage_area(storage_area)
      %Ecto.Changeset{source: %StorageArea{}}

  """
  def change_storage_area(%StorageArea{} = storage_area) do
    StorageArea.changeset(storage_area, %{})
  end
end
