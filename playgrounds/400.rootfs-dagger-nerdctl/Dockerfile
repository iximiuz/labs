# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:nerdctl-${ROOTFS_RELEASE}

ARG DAGGER_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN <<EOR
set -eu

curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=/usr/bin DAGGER_VERSION=${DAGGER_VERSION} sh

dagger completion bash > /etc/bash_completion.d/dagger

printf "\nexport DAGGER_NO_NAG=1\n\n" >> $HOME/.bashrc

ln -s $(which nerdctl) /usr/bin/docker

mkdir -p /opt/iximiuz-labs/images
crane pull registry.dagger.io/engine:v${DAGGER_VERSION} /opt/iximiuz-labs/images/dagger-engine

cat > /opt/iximiuz-labs/image-loader.sh <<EOL
#!/bin/bash

docker load -i /opt/iximiuz-labs/images/dagger-engine
EOL

chmod +x /opt/iximiuz-labs/image-loader.sh

cat > /etc/systemd/system/image-loader.service <<EOL
[Unit]
Description=Image Loader
After=network.target

[Service]
Type=oneshot
ExecStart=/opt/iximiuz-labs/image-loader.sh
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOL

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /etc/systemd/system/image-loader.service /etc/systemd/system/multi-user.target.wants/image-loader.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN printf "\nexport DAGGER_NO_NAG=1\n\n" >> $HOME/.bashrc

COPY 400.rootfs-dagger-nerdctl/welcome $HOME/.welcome