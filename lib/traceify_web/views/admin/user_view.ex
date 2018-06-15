defmodule TraceifyWeb.Admin.UserView do
  use TraceifyWeb, :view
  alias TraceifyWeb.Admin.UserView

  def render("index.json", %{users: users}) do
    render_many(users, __MODULE__, "user.json", as: :user)
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end
end
