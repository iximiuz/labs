#!/bin/bash
set -eu

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" == "inactive" ]; then
  while [ ! -f /tmp/worker_token.txt ]; do
    sleep 1
  done

  WORKER_TOKEN=$(cat /tmp/worker_token.txt)
  docker swarm join --token $WORKER_TOKEN 172.16.0.2:2377

  rm -f /tmp/worker_token.txt
fi