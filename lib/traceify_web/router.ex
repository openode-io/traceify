defmodule TraceifyWeb.Router do
  use TraceifyWeb, :router
  import TraceifyWeb.Authentication

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :load_user
  end

  pipeline :check_admin do
    plug :force_admin
  end

  scope "/", TraceifyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api/v1", TraceifyWeb do
    pipe_through :api

    scope "/instances"  do
      get "/", InstanceController, :index

      post "/:sitename/:level/log", InstanceController, :log
      post "/:sitename/:level/search", InstanceController, :search

    end

    scope "/admin" do
      pipe_through :check_admin

      scope "/users" do
        get "/", Admin.UserController, :index
        post "/", Admin.UserController, :create
      end
    end
  end
end
