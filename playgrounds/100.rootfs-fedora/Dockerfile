# syntax=docker/dockerfile:1
ARG FEDORA_VERSION=latest

FROM fedora:${FEDORA_VERSION}

ARG ARKADE_BIN_DIR
ARG BTOP_VERSION
ARG CFSSL_VERSION
ARG LAB_USER
ARG WEBSOCAT_VERSION

# udev is needed for booting a "real" VM, setting up the ttyS0 console properly
# kmod is needed for modprobing modules
RUN <<EOF
set -eu

dnf update -y
dnf upgrade -y

sed -i -e 's/^tsflags=nodocs$/#tsflags=nodocs/' /etc/dnf/dnf.conf

dnf -y install \
  awk \
  bash-completion \
  bzip2 \
  ca-certificates \
  curl \
  dbus \
  dnsutils \
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
  man-db \
  man-pages \
  mtr \
  netcat \
  net-tools \
  nftables \
  psmisc \
  procps-ng \
  ripgrep \
  rng-tools \
  socat \
  sudo \
  systemd \
  traceroute \
  tree \
  udev \
  unzip \
  vim \
  wget

dnf clean all

update-alternatives --set iptables /usr/sbin/iptables-nft

# Doesn't seem to be needed and produces extra noise in journald.
systemctl mask networkd-dispatcher.service

rm -f /.dockerenv

# Create the following files, but unset them.
echo "" > /etc/machine-id && mkdir -p /var/lib/dbus/ && echo "" > /var/lib/dbus/machine-id

echo "root:root" | chpasswd
EOF

RUN <<EOF
set -eu

dnf update -y
dnf install -y openssh-server

echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config
echo "KbdInteractiveAuthentication no" >> /etc/ssh/sshd_config
echo "PrintLastLog no" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "MaxAuthTries 5" >> /etc/ssh/sshd_config
echo "MaxSessions 10" >> /etc/ssh/sshd_config
echo "MaxStartups 10:30:100" >> /etc/ssh/sshd_config

sed -i -e 's/^RestartSec=42s/RestartSec=1s/' /usr/lib/systemd/system/sshd.service

systemctl mask sshd-keygen@.service
systemctl mask sshd-keygen.target

# mkdir -p /etc/systemd/system/sshd@.service.d
# cat > /etc/systemd/system/sshd@.service.d/override.conf <<EOT
# [Socket]
# ListenStream=vsock::22
# Accept=yes
# EOT

rm -f /etc/ssh/ssh_host_*
EOF

RUN echo "SELINUX=disabled" >> /etc/selinux/config
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

COPY 100.rootfs-fedora/welcome $HOME/.welcome

# User-specific tools - $LAB_USER
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-code-server.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts USER=$LAB_USER /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh