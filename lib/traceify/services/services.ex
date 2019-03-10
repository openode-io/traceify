defmodule Traceify.Services do
  @moduledoc """
  The Services context.
  """

  import Ecto.Query, warn: false
  alias Traceify.Repo

  alias Traceify.Services.Service

  @doc """
  Returns the list of services.

  ## Examples

      iex> list_services()
      [%Service{}, ...]

  """
  def list_services do
    Repo.all(Service)
  end

  @doc """
  Gets a single service.

  Raises `Ecto.NoResultsError` if the Service does not exist.

  ## Examples

      iex> get_service!(123)
      %Service{}

      iex> get_service!(456)
      ** (Ecto.NoResultsError)

  """
  def get_service!(id), do: Repo.get!(Service, id)

  def get_service_by_site_name!(name) do
    Repo.one!(from Service, where: [site_name: ^name], preload: [:storage_area, :user])
  end

  @doc """
  Creates a service.

  ## Examples

      iex> create_service(%{field: value})
      {:ok, %Service{}}

      iex> create_service(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_service(attrs \\ %{}) do
    %Service{}
    |> Service.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a service.

  ## Examples

      iex> update_service(service, %{field: new_value})
      {:ok, %Service{}}

      iex> update_service(service, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_service(%Service{} = service, attrs) do
    service
    |> Service.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Service.

  ## Examples

      iex> delete_service(service)
      {:ok, %Service{}}

      iex> delete_service(service)
      {:error, %Ecto.Changeset{}}

  """
  def delete_service(%Service{} = service) do
    destroy_db(service)

    Repo.delete(service)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking service changes.

  ## Examples

      iex> change_service(service)
      %Ecto.Changeset{source: %Service{}}

  """
  def change_service(%Service{} = service) do
    Service.changeset(service, %{})
  end

  def ensure_db(service) do
    if ! db_exists?(service) do
      init_db(service)
    end
  end

  def db_exists?(service) do
    File.exists?(Traceify.Services.db_path(service))
  end

  def init_db(service) do
    ctbl = """
      CREATE VIRTUAL TABLE IF NOT EXISTS logs USING fts3(
        id integer PRIMARY KEY AUTOINCREMENT,
        level VARCHAR(15) NOT NULL,
        content TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    """

    Sqlitex.with_db(Traceify.Services.db_path(service), fn(db) ->
      # to allow read-write in parallel - https://www.sqlite.org/wal.html
      Sqlitex.query(db, "PRAGMA journal_mode=WAL;")

      Sqlitex.query(db, ctbl)

      #Sqlitex.query(db, "CREATE INDEX level_ind ON logs(level)")
      #Sqlitex.query(db, "CREATE INDEX content_ind ON logs(content)")
    end)
  end

  def prepare_log_dir(service) do
    db_root_location = service.storage_area.root_path

    write_to_dir = "#{db_root_location}/#{service.site_name}"
    File.mkdir_p(write_to_dir)

    write_to_dir
  end

  def db_path(service) do
    write_to_dir = prepare_log_dir(service)

    "#{write_to_dir}/db.sqlite3"
  end

  def destroy_db(service) do
    db_path(service)
      |> File.rm

    prepare_log_dir(service)
      |> File.rmdir
  end
end
