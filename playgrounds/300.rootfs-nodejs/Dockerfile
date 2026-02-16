# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION
ARG NVM_VERSION

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN <<EOR
#!/bin/bash
set -eu

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install node
EOR

RUN <<EOF
set -eu

code-server --install-extension christian-kohler.npm-intellisense
code-server --install-extension dbaeumer.vscode-eslint
code-server --install-extension esbenp.prettier-vscode
EOF

COPY 300.rootfs-nodejs/welcome $HOME/.welcome