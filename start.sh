docker run -d --restart unless-stopped -p 127.0.0.1:5000:5000 \
  -v $(pwd):/opt/app --env-file=.env traceify bash build-and-run.sh 
