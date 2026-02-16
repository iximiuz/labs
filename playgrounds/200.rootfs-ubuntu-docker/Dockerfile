# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG DIVE_VERSION
ARG LAB_USER

USER root

RUN <<EOR
set -eu

mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list

apt-get update
apt-get install -y \
  containerd.io \
  docker-ce \
  docker-ce-cli \
  docker-buildx-plugin \
  docker-compose-plugin

if [ -f /etc/docker/daemon.json ]; then
  jq '. + { "registry-mirrors": ["https://mirror.gcr.io"] }' /etc/docker/daemon.json > /etc/docker/daemon.json.new
  mv /etc/docker/daemon.json.new /etc/docker/daemon.json
else
  mkdir -p /etc/docker

  cat <<EOF > /etc/docker/daemon.json
  {
    "registry-mirrors": ["https://mirror.gcr.io"]
  }
EOF
fi

systemctl enable docker

docker completion bash > /etc/bash_completion.d/docker

usermod -aG docker $LAB_USER
EOR

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-cdebug.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-dive.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-regctl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN code-server --install-extension ms-azuretools.vscode-docker

COPY 200.rootfs-ubuntu-docker/welcome $HOME/.welcome
