# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG DIVE_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

COPY 200.rootfs-incus/incus.yaml /opt/iximiuz-labs/incus.yaml
COPY 200.rootfs-incus/incus-init.sh /opt/iximiuz-labs/incus-init.sh
COPY 200.rootfs-incus/incus-init.service /etc/systemd/system/incus-init.service

RUN <<EOR
set -eu

mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.zabbly.com/key.asc -o /etc/apt/keyrings/zabbly.asc

sh -c 'cat <<EOF > /etc/apt/sources.list.d/zabbly-incus-stable.sources
Enabled: yes
Types: deb
URIs: https://pkgs.zabbly.com/incus/stable
Suites: $(. /etc/os-release && echo ${VERSION_CODENAME})
Components: main
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/zabbly.asc

EOF'

apt-get update
apt-get install -y incus

systemctl enable incus

adduser $LAB_USER incus-admin

ln -s /etc/systemd/system/incus-init.service \
    /etc/systemd/system/multi-user.target.wants/incus-init.service
EOR

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-dive.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-regctl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 200.rootfs-incus/welcome $HOME/.welcome
