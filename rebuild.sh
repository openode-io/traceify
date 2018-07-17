echo "git pull"
git pull

docker rm -f $(docker ps --filter="image=traceify" -q)

bash start.sh
