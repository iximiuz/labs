# syntax=docker/dockerfile:1
FROM archlinux:base

ARG ARKADE_BIN_DIR
ARG BTOP_VERSION
ARG CFSSL_VERSION
ARG LAB_USER
ARG WEBSOCAT_VERSION

RUN <<EOF
set -eu

pacman -Syu --noconfirm

pacman -Sy --noconfirm --needed \
  base-devel \
  bash-completion \
  bind-tools \
  bzip2 \
  ca-certificates \
  curl \
  dbus \
  file \
  gettext \
  git \
  gnupg \
  htop \
  iproute2 \
  iptables \
  iputils \
  kmod \
  lsb-release \
  lsof \
  make \
  man-db \
  mtr \
  netcat \
  net-tools \
  nftables \
  psmisc \
  ripgrep \
  socat \
  sudo \
  systemd \
  systemd-libs \
  traceroute \
  tree \
  vim \
  wget \
  which

mkdir -p /etc/systemd/system/multi-user.target.wants
rm -f /.dockerenv

# Create the following files, but unset them.
echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id

echo "root:root" | chpasswd
EOF

RUN <<EOF
set -eu

pacman -Syu --noconfirm
pacman -Sy --noconfirm openssh

echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config
echo "PrintLastLog no" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "MaxAuthTries 50" >> /etc/ssh/sshd_config

systemctl mask sshd-keygen@.service
systemctl mask sshd-keygen.target

# mkdir -p /etc/systemd/system/sshd@.service.d
# cat > /etc/systemd/system/sshd@.service.d/override.conf <<EOT
# [Socket]
# ListenStream=vsock::22
# Accept=yes
# EOT

systemctl enable sshd.service

rm -f /etc/ssh/ssh_host_*
EOF


COPY examiner* /usr/local/bin
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/set-up-systemd-examiner-service.sh


# System-wide user tools.
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-arkade.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-common-tools.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-btop.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-cfssl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-websocat.sh
RUN curl https://fx.wtf/install.sh | sh


# User-specific tools - root
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh


# Add the lab user.
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-lab-user.sh

USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 100.rootfs-archlinux/welcome $HOME/.welcome

# User-specific tools - $LAB_USER
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-code-server.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts USER=$LAB_USER /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh