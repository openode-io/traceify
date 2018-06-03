defmodule Traceify.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset


  schema "services" do
    field :site_name, :string
    field :token, :string
    field :storage_area_id, :id

    timestamps()
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:site_name, :token])
    |> validate_required([:site_name, :token])
  end
end
