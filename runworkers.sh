#!/bin/bash

# Check if the required number of workers (2 per python version) are running
path="/root/docker-python-github-runners"
containers=( "runner-image-py3.4.10" "runner-image-py3.5.3" "runner-image-py3.6.13" "runner-image-py3.7.10" )
minimum=2

startrunners=0
for container in "${containers[@]}"; do
  COUNT=`docker ps | grep -c $container`
  if [ $COUNT -lt $minimum ]; then
    startrunners=1
  fi
done

if [ $startrunners -gt 0 ]; then
  cd $path && make prune > /dev/null
  cd $path && make run > /dev/null
fi

