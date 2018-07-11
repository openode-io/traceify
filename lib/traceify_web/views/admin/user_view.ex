defmodule TraceifyWeb.Admin.UserView do
  use TraceifyWeb, :view
  alias TraceifyWeb.Admin.UserView

  def render("index.json", %{users: users}) do
    render_many(users, __MODULE__, "user.json", as: :user)
  end

  def render("exists.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email
    }
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      email: user.email,
      inserted_at: user.inserted_at,
      updated_at: user.updated_at
    }
  end

  def render("create.json", %{user: user}) do
    %{
      id: user.id
    }
  end

  def render("default.json", %{}) do
    %{
      result: "success"
    }
  end
end
