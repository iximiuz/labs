#!/bin/bash
set -eu

ssh-keyscan 172.16.0.2 >> /root/.ssh/known_hosts

mkdir -p /root/.kube
scp 172.16.0.2:/etc/rancher/k3s/k3s.yaml /root/.kube/config
sed -i 's/127.0.0.1/172.16.0.2/g' /root/.kube/config

mkdir -p /home/$LAB_USER/.kube
cp /root/.kube/config /home/$LAB_USER/.kube/config
chown -R $LAB_USER:$LAB_USER /home/$LAB_USER/.kube
