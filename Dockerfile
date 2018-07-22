FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
EXPOSE 5000
ENV PORT=5000 MIX_ENV=prod

# main build and run script
ADD build-and-run.sh ./

# crontab
RUN echo '* * * * * sh /opt/app/scripts/crunch.sh' >> /etc/crontabs/root

CMD ["mix", "phx.server"]
