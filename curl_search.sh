
curl -H "x-auth-token: my-very-secret-token" -H "Content-Type: application/json" -d '{"search": "toto"}' -X POST http://localhost:4002/api/v1/instances/hello_world/info/search
