defmodule Traceify.Instances.Instance do
  use Ecto.Schema
  import Ecto.Changeset


  schema "instances" do
    field :site_name, :string
    field :token, :string

    timestamps()
  end

  @doc false
  def changeset(instance, attrs) do
    instance
    |> cast(attrs, [:site_name, :token])
    |> validate_required([:site_name, :token])
  end
end
