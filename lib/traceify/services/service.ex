defmodule Traceify.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset


  schema "services" do
    field :site_name, :string

    belongs_to :storage_area, Traceify.StorageAreas.StorageArea
    belongs_to :user, Traceify.Users.User

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:site_name])
    |> validate_required([:site_name])
  end
end
