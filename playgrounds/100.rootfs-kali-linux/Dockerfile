# syntax=docker/dockerfile:1
FROM kalilinux/kali-rolling

ARG ARKADE_BIN_DIR
ARG BTOP_VERSION
ARG CFSSL_VERSION
ARG LAB_USER
ARG WEBSOCAT_VERSION

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
RUN <<EOF
set -eu

apt-get update
apt-get install -y wget

wget http://http.kali.org/kali/pool/main/k/kali-archive-keyring/kali-archive-keyring_2025.1_all.deb
dpkg -i kali-archive-keyring_2025.1_all.deb
rm kali-archive-keyring_2025.1_all.deb

apt-get upgrade -y

apt-get install -y \
  bash-completion \
  bzip2 \
  ca-certificates \
  curl \
  dbus \
  dnsutils \
  file \
  gettext-base \
  git \
  gnupg \
  htop \
  iproute2 \
  iptables \
  iputils-ping \
  kali-linux-core \
  kmod \
  locales \
  lsb-release \
  lsof \
  make \
  man \
  mtr \
  net-tools \
  nftables \
  psmisc \
  ripgrep \
  socat \
  sudo \
  systemd \
  traceroute \
  tree \
  udev \
  unzip \
  vim

# Doesn't seem to be needed and produces extra noise in journald.
systemctl mask networkd-dispatcher.service

rm -rf /etc/update-motd.d/*
rm -rf /etc/motd
rm -f /.dockerenv

touch ~/.hushlogin

# Create the following files, but unset them.
echo "" > /etc/machine-id && echo "" > /var/lib/dbus/machine-id

echo "root:root" | chpasswd
EOF

RUN <<EOF
set -eu

apt-get update
apt-get install -y openssh-server

echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config
echo "PrintLastLog no" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "MaxAuthTries 50" >> /etc/ssh/sshd_config

systemctl mask sshd-keygen@.service
systemctl mask sshd-keygen.target
systemctl enable ssh.service

# mkdir -p /etc/systemd/system/sshd@.service.d
# cat > /etc/systemd/system/sshd@.service.d/override.conf <<EOT
# [Socket]
# ListenStream=vsock::22
# Accept=yes
# EOT

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

COPY 100.rootfs-kali-linux/welcome $HOME/.welcome
RUN touch $HOME/.hushlogin

# User-specific tools - $LAB_USER
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-code-server.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts USER=$LAB_USER /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh
