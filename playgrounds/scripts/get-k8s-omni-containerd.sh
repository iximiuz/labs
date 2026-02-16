#!/usr/bin/env bash
set -eu

for var in K8S_OMNI_CONTAINERD_VERSION K8S_OMNI_RUNC_VERSION; do
  if [ -z "${!var:-}" ]; then
    echo "$var must be set"
    exit 1
  fi
done

ARCH=amd64
URL=https://github.com/containerd/containerd/releases/download/v${K8S_OMNI_CONTAINERD_VERSION}/containerd-${K8S_OMNI_CONTAINERD_VERSION}-linux-${ARCH}.tar.gz

curl -L ${URL} -o containerd-${K8S_OMNI_CONTAINERD_VERSION}-linux-${ARCH}.tar.gz

mkdir -p /opt/iximiuz-labs/containerd

tar Cxvf /opt/iximiuz-labs/containerd containerd-${K8S_OMNI_CONTAINERD_VERSION}-linux-${ARCH}.tar.gz

curl -L \
    https://raw.githubusercontent.com/containerd/containerd/main/containerd.service \
    -o /opt/iximiuz-labs/containerd/containerd.service

curl -L \
    https://github.com/opencontainers/runc/releases/download/v${K8S_OMNI_RUNC_VERSION}/runc.${ARCH} \
    -o /opt/iximiuz-labs/containerd/bin/runc
