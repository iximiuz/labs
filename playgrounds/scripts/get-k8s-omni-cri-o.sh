#!/usr/bin/env bash
set -eu

for var in K8S_OMNI_CRI_O_VERSION; do
  if [ -z "${!var:-}" ]; then
    echo "$var must be set"
    exit 1
  fi
done

CRO_O_REPO_VERSION=${K8S_OMNI_CRI_O_VERSION%.*}

curl -fsSL https://pkgs.k8s.io/addons:/cri-o:/stable:/v$CRO_O_REPO_VERSION/deb/Release.key |
    gpg --dearmor -o /etc/apt/keyrings/cri-o-apt-keyring.gpg

echo "deb [signed-by=/etc/apt/keyrings/cri-o-apt-keyring.gpg] https://pkgs.k8s.io/addons:/cri-o:/stable:/v$CRO_O_REPO_VERSION/deb/ /" |
    tee /etc/apt/sources.list.d/cri-o.list

apt-get update
apt-cache policy cri-o
apt-get install --download-only -y cri-o=${K8S_OMNI_CRI_O_VERSION}-* podman

mkdir -p /opt/iximiuz-labs/apt-cache
cp -r /var/cache/apt/archives/cri-o* /opt/iximiuz-labs/apt-cache/
cp -r /var/cache/apt/archives/podman* /opt/iximiuz-labs/apt-cache/
