echo "getting and compiling dependencies"
mix do deps.get, deps.compile

echo "npm install of assets"
cd assets && npm install

# compile
npm run deploy && \
    cd - && \
    source .sample.without.docker.env && mix do compile, phx.digest

# crontab !!!
echo "setting up the crontab"
echo '* * * * * sh /opt/app/scripts/crunch.sh' >> /etc/crontabs/root

# serve
mix phx.server
