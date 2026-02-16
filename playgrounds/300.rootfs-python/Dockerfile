# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG PYTHON_VERSION
ARG LAB_USER
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh

RUN <<EOF
set -eu

apt update
apt install -y \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libncursesw5-dev \
  xz-utils \
  tk-dev \
  libxml2-dev \
  libxmlsec1-dev \
  libffi-dev \
  liblzma-dev
EOF


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN <<EOF
set -eu

curl https://pyenv.run | bash

echo >> $HOME/.bashrc
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.bashrc
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.bashrc
echo 'eval "$(pyenv init -)"' >> $HOME/.bashrc
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.bashrc

echo >> $HOME/.profile
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.profile
echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.profile
echo 'eval "$(pyenv init -)"' >> $HOME/.profile
echo 'eval "$(pyenv virtualenv-init -)"' >> $HOME/.profile
EOF

RUN <<EOF
set -eu

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

pyenv install ${PYTHON_VERSION}
pyenv global ${PYTHON_VERSION}
EOF

RUN <<EOF
set -eu

curl -LsSf https://astral.sh/uv/install.sh | sh

echo >> $HOME/.bashrc
echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.bashrc
EOF


RUN <<EOF
set -eu

code-server --install-extension ms-python.python
EOF

COPY 300.rootfs-python/welcome $HOME/.welcome
