#!/bin/sh
set -eu

if [ -z "${K3S_VERSION:-}" ]; then
  echo "K3S_VERSION must be set"
  exit 1
fi

INSTALL_K3S_EXEC_EXTRA="${INSTALL_K3S_EXEC_EXTRA:-}"
K3S_TOKEN=mxSuPmn6K4YjEwbPs0yEleC7HxKChWphhKzyDe8eP+tz3KmnVP3rxfHYFC3+97Hd32hwDpdqUXkw82e0eTV35g==

mkdir -p /var/lib/rancher/k3s/agent/images/
curl --fail -sL -o /var/lib/rancher/k3s/agent/images/airgap-images.tar https://github.com/k3s-io/k3s/releases/download/v${K3S_VERSION}/k3s-airgap-images-amd64.tar

# Install k3s. The intermediate container used to run this command does not run systemd, so
# the installer can't automatically enable the k3s service. Instead, we do so manually.
curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_ENABLE=true INSTALL_K3S_EXEC="server ${INSTALL_K3S_EXEC_EXTRA}" INSTALL_K3S_VERSION=v${K3S_VERSION} K3S_TOKEN=${K3S_TOKEN} sh -s -

mkdir -p /etc/rancher/k3s/config.yaml.d

cat <<EOF > /etc/rancher/k3s/config.yaml.d/00-features.yaml
kubelet:
  - feature-gates=SidecarContainers=true
kube-apiserver-arg:
  - feature-gates=SidecarContainers=true
kube-controller-manager:
  - feature-gates=SidecarContainers=true
kube-scheduler:
  - feature-gates=SidecarContainers=true
EOF

ln -s /etc/systemd/system/k3s.service /etc/systemd/system/multi-user.target.wants/k3s.service
