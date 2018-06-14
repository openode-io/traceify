defmodule Traceify.Repo.Migrations.CreateServices do
  use Ecto.Migration

  def change do
    create table(:services) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :site_name, :string
      add :storage_area_id, references(:storage_areas, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:services, [:site_name])
    create index(:services, [:storage_area_id])
    create index(:services, [:user_id])
  end
end
