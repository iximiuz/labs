# syntax=docker/dockerfile:1
ARG OPENSUSE_VERSION=latest

FROM opensuse/tumbleweed:${OPENSUSE_VERSION}

ARG ARKADE_BIN_DIR
ARG BTOP_VERSION
ARG CFSSL_VERSION
ARG LAB_USER
ARG WEBSOCAT_VERSION

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
RUN <<EOF
set -eu

zypper ref -s
zypper dup -y

# rpm.install.excludedocs is set to true on the official TW image

zypper -n in --no-recommends \
  awk \
  bash-completion \
  bind-utils \
  bzip2 \
  ca-certificates \
  curl \
  dbus-1 \
  file \
  gettext \
  git \
  gnupg \
  htop \
  iproute \
  iptables \
  iptables-nft \
  iputils \
  kmod \
  lsb-release \
  lsof \
  make \
  man \
  man-pages \
  mtr \
  netcat \
  net-tools \
  nftables \
  psmisc \
  procps \
  ripgrep \
  rng-tools \
  socat \
  sudo \
  system-group-wheel \
  systemd \
  traceroute \
  tree \
  udev \
  unzip \
  vim \
  wget

zypper -n clean

# Unsure if this is needed, copied from the Fedora image
systemctl mask networkd-dispatcher.service

rm -f /.dockerenv

# Create the following files, but unset them.
# Unsure if this is needed as the TW image contains both files and they are empty by default
echo "" > /etc/machine-id && mkdir -p /var/lib/dbus/ && echo "" > /var/lib/dbus/machine-id

echo "root:root" | chpasswd
EOF

RUN <<EOF
set -eu

zypper ref -s
zypper -n in --no-recommends openssh-server

echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "KbdInteractiveAuthentication no" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "PrintLastLog no" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "AddressFamily inet" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "UseDNS no" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "MaxAuthTries 5" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "MaxSessions 10" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf
echo "MaxStartups 10:30:100" >> /etc/ssh/sshd_config.d/iximiuz-playground.conf

systemctl mask sshd-keygen@.service
systemctl mask sshd-keygen.target
systemctl enable sshd

rm -f /etc/ssh/ssh_host_*
EOF

RUN systemctl mask systemd-network-generator.service


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

COPY 100.rootfs-opensuse-tumbleweed/welcome $HOME/.welcome

# User-specific tools - $LAB_USER
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-code-server.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts USER=$LAB_USER /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh
