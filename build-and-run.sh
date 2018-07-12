echo "getting and compiling dependencies"
mix do deps.get, deps.compile

echo "npm install of assets"
cd assets && npm install

# compile
npm run deploy && \
    cd - && \
    source .sample.without.docker.env && mix do compile, phx.digest

# serve
mix phx.server
