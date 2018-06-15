defmodule TraceifyWeb.Admin.ServiceView do
  use TraceifyWeb, :view
  alias TraceifyWeb.Admin.ServiceView

  # def render("index.json", %{users: users}) do
  #  render_many(users, __MODULE__, "user.json", as: :user)
  # end

  #def render("user.json", %{user: user}) do
  #  %{
  #    id: user.id,
  #    email: user.email,
  #    inserted_at: user.inserted_at,
  #    updated_at: user.updated_at
  #  }
  #end

  def render("create.json", %{service: service}) do
    %{
      id: service.id
    }
  end
end
