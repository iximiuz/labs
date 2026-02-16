#!/bin/bash
set -eu

if ! [ -f /var/lib/k0s/pki/admin.conf ]; then
  echo "KUBECONFIG file not found"
  exit 1
fi

chmod go-r /var/lib/k0s/pki/admin.conf

mkdir /root/.kube
ln -s /var/lib/k0s/pki/admin.conf /root/.kube/config

mkdir /home/$LAB_USER/.kube
cp /var/lib/k0s/pki/admin.conf /home/$LAB_USER/.kube/config
chown -R $LAB_USER:$LAB_USER /home/$LAB_USER/.kube