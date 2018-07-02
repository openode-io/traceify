FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
ADD assets/package.json assets/
RUN cd assets && \
    npm install

ADD . /opt/app

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    source .sample.env && mix do compile, phx.digest


CMD ["mix", "phx.server"]
