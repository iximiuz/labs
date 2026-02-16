# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG DIVE_VERSION
ARG LAB_USER
ARG NERDCTL_VERSION

USER root

RUN <<EOR
set -eu

wget https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
tar Cxzvvf /usr/local nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
rm nerdctl-full-${NERDCTL_VERSION}-linux-amd64.tar.gz
nerdctl completion bash > /etc/bash_completion.d/nerdctl

mkdir -p /etc/buildkit

cat > /etc/buildkit/buildkitd.toml <<EOF
[worker.oci]
  enabled = false

[worker.containerd]
  enabled = true
  namespace = "default"
EOF

systemctl enable buildkit
systemctl enable containerd
EOR

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-cdebug.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-dive.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-regctl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN printf "\nalias nerdctl='sudo nerdctl'\n" >> $HOME/.bashrc

COPY 200.rootfs-nerdctl/welcome $HOME/.welcome
