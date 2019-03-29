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

  pipeline :api_without_auth do
    plug :accepts, ["json"]
  end

  pipeline :check_admin do
    plug :force_admin
  end

  scope "/", TraceifyWeb do
    pipe_through :api_without_auth

    get "/", HomeController, :index
    get "/version", HomeController, :version
  end

  scope "/api/v1", TraceifyWeb do
    pipe_through :api

    scope "/instances"  do
      get "/", InstanceController, :index

      get "/:sitename/stats", InstanceController, :stats
      post "/:sitename/:level/log", InstanceController, :log
      post "/:sitename/search", InstanceController, :search

    end

    scope "/admin" do
      pipe_through :check_admin

      scope "/users" do
        get "/", Admin.UserController, :index
        post "/", Admin.UserController, :create
        post "/exists", Admin.UserController, :exists
        patch "/:id", Admin.UserController, :update
        delete "/:id", Admin.UserController, :destroy
      end

      scope "/services" do
        get "/", Admin.ServiceController, :index
        post "/", Admin.ServiceController, :create
        post "/exists", Admin.ServiceController, :exists
        patch "/:id", Admin.ServiceController, :update
        delete "/:sitename/", Admin.ServiceController, :destroy
      end
    end
  end
end
