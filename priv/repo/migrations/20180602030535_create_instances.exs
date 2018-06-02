defmodule Traceify.Repo.Migrations.CreateInstances do
  use Ecto.Migration

  def change do
    create table(:instances) do
      add :site_name, :string
      add :token, :string

      timestamps()
    end

  end
end
