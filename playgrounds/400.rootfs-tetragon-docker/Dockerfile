# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER
ARG TETRAGON_VERSION

USER root
ENV HOME=/root

RUN <<EOR
set -eu

mkdir -p /opt/iximiuz-labs/images
crane pull quay.io/cilium/tetragon:v${TETRAGON_VERSION} /opt/iximiuz-labs/images/tetragon
crane pull alpine:3 /opt/iximiuz-labs/images/alpine

cat > /opt/iximiuz-labs/setup-tetragon.sh <<EOL
#!/bin/bash

docker load -i /opt/iximiuz-labs/images/tetragon
docker load -i /opt/iximiuz-labs/images/alpine

if ! docker ps -a | grep tetragon; then
  docker run --name tetragon -d \
    --pid=host --cgroupns=host --privileged \
    -v /sys/kernel/btf/vmlinux:/var/lib/tetragon/btf \
    quay.io/cilium/tetragon:v${TETRAGON_VERSION}
fi

if ! docker ps -a | grep sleepy; then
  docker run --name sleepy -d \
    alpine:3 \
    sh -c 'while true; do sleep 2; echo "Zzz..."; done'
fi
EOL

chmod +x /opt/iximiuz-labs/setup-tetragon.sh

cat > /etc/systemd/system/setup-tetragon.service <<EOL
[Unit]
Description=Tetragon setup
After=docker.service
Requires=docker.service

[Service]
Type=oneshot
ExecStart=/opt/iximiuz-labs/setup-tetragon.sh
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOL

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /etc/systemd/system/setup-tetragon.service /etc/systemd/system/multi-user.target.wants/setup-tetragon.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 400.rootfs-tetragon-docker/welcome $HOME/.welcome
