
curl -H "x-auth-token: my-very-secret-token" -H "Content-Type: application/json" -d '{"coucou": { "toto": "titi" }, "wtf": "ddf" }' -X POST http://localhost:4000/api/v1/instances/hello_world/info/search
