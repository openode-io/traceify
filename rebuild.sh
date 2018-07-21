echo "git pull"
git pull

docker rm -f $(docker ps | grep traceify | awk '{print $1}')

bash start.sh
