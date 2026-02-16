# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG LAB_USER
ARG TETRAGON_VERSION

USER root
ENV HOME=/root

RUN <<EOR
set -eu

curl -LO https://github.com/cilium/tetragon/releases/download/v${TETRAGON_VERSION}/tetragon-v${TETRAGON_VERSION}-amd64.tar.gz
tar -xvf tetragon-v${TETRAGON_VERSION}-amd64.tar.gz
cd tetragon-v${TETRAGON_VERSION}-amd64/
./install.sh || true  # last steps fail because systemd is not running
rm -rf tetragon-v${TETRAGON_VERSION}-amd64.tar.gz tetragon-v${TETRAGON_VERSION}-amd64/

tetra completion bash > /etc/bash_completion.d/tetra

ln -s /etc/systemd/system/tetragon.service /etc/systemd/system/multi-user.target.wants/tetragon.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 400.rootfs-tetragon-linux/welcome $HOME/.welcome