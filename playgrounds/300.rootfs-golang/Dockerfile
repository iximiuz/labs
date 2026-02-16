# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG GOLANG_VERSION
ARG LAB_USER
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh

RUN <<EOF
set -eu

apt-get update
apt-get install -y \
  build-essential gcc

wget https://go.dev/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go${GOLANG_VERSION}.linux-amd64.tar.gz
rm -r go${GOLANG_VERSION}.linux-amd64.tar.gz

printf "\nexport PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin\n" >> $HOME/.bashrc

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

git clone --depth 1 https://github.com/fatih/vim-go.git $HOME/.vim/pack/plugins/start/vim-go

vim +GoInstallBinaries +qall
EOF


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN <<EOF
set -eu

printf "\nexport PATH=\$PATH:/usr/local/go/bin:\$HOME/go/bin\n" >> $HOME/.bashrc

export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin

git clone --depth 1 https://github.com/fatih/vim-go.git $HOME/.vim/pack/plugins/start/vim-go

vim +GoInstallBinaries +qall
EOF


RUN <<EOF
set -eu

code-server --install-extension golang.go
EOF

COPY 300.rootfs-golang/welcome $HOME/.welcome