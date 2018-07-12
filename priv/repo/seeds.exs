# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Traceify.Repo.insert!(%Traceify.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Traceify.StorageAreas.StorageArea
alias Traceify.Services.Service
alias Traceify.Users.User
alias Traceify.Repo

Repo.query!("delete from users", [])
Repo.query!("delete from services", [])
Repo.query!("delete from storage_areas", [])

localhost_storage = Repo.insert! %StorageArea{
    url: "http://localhost:4002",
    name: "the_writer",
    root_path: "/home/martin/works/dump"
  }

Repo.insert! %User{
    token: "my-very-secret-token-to-delete",
    email: "hello-to-delete@gmail.com",
    is_admin: 0
  }

Repo.insert! %User{
    token: "my-very-secret-token-to-update",
    email: "hello-to-update@gmail.com",
    is_admin: 0
  }

normal_user1 = Repo.insert! %User{
    token: "my-very-secret-token",
    email: "hello@gmail.com",
    is_admin: 0
  }

service_hello_world = Repo.insert! %Service{
    site_name: "hello_world",
    user_id: normal_user1.id,
    storage_area_id: localhost_storage.id
  }

Repo.insert! %Service{
    site_name: "hello_world_to_delete",
    user_id: normal_user1.id,
    storage_area_id: localhost_storage.id
  }

Repo.insert! %Service{
    site_name: "hello_world_to_update",
    user_id: normal_user1.id,
    storage_area_id: localhost_storage.id
  }

admin1 = Repo.insert! %User{
    token: "my-very-secret-token-admin",
    email: "admin@gmailll.com",
    is_admin: 1
  }
