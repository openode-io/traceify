defmodule Traceify.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :is_admin, :integer
    field :token, :string
    field :email, :string

    has_many :services, Traceify.Services.Service

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:token, :email, :is_admin])
    |> validate_required([:token, :email, :is_admin])
  end
end
