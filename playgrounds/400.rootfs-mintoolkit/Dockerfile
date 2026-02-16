# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:golang-${ROOTFS_RELEASE}

ARG LAB_USER

USER root
ENV HOME=/root

ARG MINTOOLKIT_VERSION

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-mintoolkit.sh

COPY 400.rootfs-mintoolkit/image-importer.sh /opt/iximiuz-labs/image-importer.sh
COPY 400.rootfs-mintoolkit/image-importer.service /etc/systemd/system/image-importer.service

RUN <<EOR
set -eu

mkdir -p /opt/iximiuz-labs/images
crane pull docker.io/library/nginx:latest /opt/iximiuz-labs/images/nginx-latest.tar
crane pull ghcr.io/iximiuz/labs/mintoolkit/nuxt-web-app:v1.0.0 /opt/iximiuz-labs/images/nuxt-web-app-v1.0.0.tar

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /etc/systemd/system/image-importer.service /etc/systemd/system/multi-user.target.wants/image-importer.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 400.rootfs-mintoolkit/welcome $HOME/.welcome

RUN <<EOR
set -eu

mkdir $HOME/mintoolkit

git clone https://github.com/mintoolkit/mint $HOME/mintoolkit/mint
git clone https://github.com/mintoolkit/examples $HOME/mintoolkit/examples

sudo sed -i -r "s/^ExecStart=(.+\s)\/.+$/ExecStart=\1\/home\/$LAB_USER\/mintoolkit\/mint/" /lib/systemd/system/code-server.service
EOR
