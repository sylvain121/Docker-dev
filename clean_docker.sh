docker rm $(docker ps -a -q)
docker rmi -f $(docker images -q)
exit 0
