docker run -d --restart=always -p 127.0.0.1:5000:5000 \
  -v $(pwd):/opt/app -v /traceify:/traceify --net="host" --env-file=.env traceify bash build-and-run.sh
