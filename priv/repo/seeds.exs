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
alias Traceify.Repo

Repo.query!("delete from services", [])
Repo.query!("delete from storage_areas", [])

localhost_storage = Repo.insert! %StorageArea{
    url: "http://localhost:4002",
    name: "the_writer",
    root_path: "/home/martin/works/dump"
  }

service_hello_world = Repo.insert! %Service{
    site_name: "hello_world",
    token: "my-very-secret-token",
    storage_area_id: localhost_storage.id
  }
