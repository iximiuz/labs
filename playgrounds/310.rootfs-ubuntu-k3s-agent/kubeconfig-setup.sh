#!/bin/bash
set -eu

if ! [ -f /etc/rancher/k3s/k3s.yaml ]; then
  echo "KUBECONFIG file not found"
  exit 1
fi

mkdir /root/.kube
ln -s /etc/rancher/k3s/k3s.yaml /root/.kube/config

mkdir /home/$LAB_USER/.kube
cp /etc/rancher/k3s/k3s.yaml /home/$LAB_USER/.kube/config
chown -R $LAB_USER:$LAB_USER /home/$LAB_USER/.kube