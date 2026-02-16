# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:rockylinux-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG DIVE_VERSION
ARG LAB_USER

USER root

RUN <<EOF
set -eu

setcap cap_setuid+ep /usr/bin/newuidmap
setcap cap_setgid+ep /usr/bin/newgidmap

# TODO: install buildah - for some reason it started making the VM hang since 5.10.199
dnf install -y \
  podman podman-compose fuse-overlayfs
EOF

RUN podman completion bash > /etc/bash_completion.d/podman

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-cdebug.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-dive.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-regctl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 200.rootfs-podman/welcome $HOME/.welcome
