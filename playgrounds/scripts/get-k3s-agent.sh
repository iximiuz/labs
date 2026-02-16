#!/bin/sh
set -eu

if [ -z "${K3S_VERSION:-}" ]; then
  echo "K3S_VERSION must be set"
  exit 1
fi

K3S_TOKEN=mxSuPmn6K4YjEwbPs0yEleC7HxKChWphhKzyDe8eP+tz3KmnVP3rxfHYFC3+97Hd32hwDpdqUXkw82e0eTV35g==

mkdir -p /var/lib/rancher/k3s/agent/images/
curl --fail -sL -o /var/lib/rancher/k3s/agent/images/airgap-images.tar https://github.com/k3s-io/k3s/releases/download/v${K3S_VERSION}/k3s-airgap-images-amd64.tar

# Install k3s. The intermediate container used to run this command does not run systemd, so
# the installer can't automatically enable the k3s service. Instead, we do so manually.
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true K3S_URL=https://172.16.0.2:6443 K3S_TOKEN=${K3S_TOKEN} INSTALL_K3S_VERSION=v${K3S_VERSION} sh -s -

ln -s /etc/systemd/system/k3s-agent.service /etc/systemd/system/multi-user.target.wants/k3s-agent.service
