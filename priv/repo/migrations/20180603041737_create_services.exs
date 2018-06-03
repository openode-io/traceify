defmodule Traceify.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :site_name, :string
      add :token, :string
      add :storage_area_id, references(:storage_areas, on_delete: :nothing)

      timestamps()
    end

    create index(:services, [:storage_area_id])
  end
end
