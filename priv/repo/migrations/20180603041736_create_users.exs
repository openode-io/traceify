defmodule Traceify.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :token, :string
      add :is_admin, :integer

      timestamps()
    end

    create unique_index(:users, [:token])

  end
end
