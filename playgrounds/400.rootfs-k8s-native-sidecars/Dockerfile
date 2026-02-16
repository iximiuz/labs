# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-k3s-bare-${ROOTFS_RELEASE}

USER root
ENV HOME=/root

RUN <<EOF
set -eu

mkdir -p /opt/iximiuz-labs/images

crane pull ghcr.io/iximiuz/labs/kubernetes-native-sidecars/identity-provider:v1.0.0 /opt/iximiuz-labs/images/identity-provider
crane pull ghcr.io/iximiuz/labs/kubernetes-native-sidecars/announcer:v1.0.0 /opt/iximiuz-labs/images/announcer
crane pull ghcr.io/iximiuz/labs/kubernetes-native-sidecars/sleepy-sidecar:v1.0.0 /opt/iximiuz-labs/images/sleepy-sidecar
crane pull ghcr.io/iximiuz/labs/kubernetes-native-sidecars/app:v1.0.0 /opt/iximiuz-labs/images/app
EOF
