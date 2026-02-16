#!/bin/bash
set -eu

if [ "$(docker info --format '{{.Swarm.LocalNodeState}}')" == "inactive" ]; then
  # Initialize the swarm
  docker swarm init --advertise-addr 172.16.0.2
fi

WORKER_TOKEN=$(docker swarm join-token worker -q)
echo $WORKER_TOKEN > /tmp/worker_token.txt

ssh-keyscan 172.16.0.3 >> $HOME/.ssh/known_hosts
ssh-keyscan 172.16.0.4 >> $HOME/.ssh/known_hosts

scp /tmp/worker_token.txt 172.16.0.3:/tmp/
scp /tmp/worker_token.txt 172.16.0.4:/tmp/

rm -f /tmp/worker_token.txt