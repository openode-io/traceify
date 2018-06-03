defmodule Traceify.Repo.Migrations.CreateStorageAreas do
  use Ecto.Migration

  def change do
    create table(:storage_areas) do
      add :name, :string
      add :host, :string
      add :root_path, :string

      timestamps()
    end

  end
end
