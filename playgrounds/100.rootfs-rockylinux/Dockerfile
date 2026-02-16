# syntax=docker/dockerfile:1
ARG ROCKYLINUX_VERSION=9

FROM rockylinux:${ROCKYLINUX_VERSION}

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

dnf -y install epel-release

dnf -y install \
  bash-completion \
  bzip2 \
  ca-certificates \
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
  lsof \
  make \
  man \
  man-db \
  man-pages \
  man-pages-overrides \
  mtr \
  netcat \
  net-tools \
  nftables \
  psmisc \
  procps-ng \
  ripgrep \
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

rm -f /.dockerenv

# Hack to calm down Bender playground generation logic.
mkdir -p /boot

echo "" > /etc/machine-id && mkdir -p /var/lib/dbus/ && echo "" > /var/lib/dbus/machine-id

echo "root:root" | chpasswd
EOF

RUN <<EOF
set -eu

dnf update -y
dnf install -y openssh-server

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

rm -f /etc/ssh/ssh_host_*
EOF

RUN if [ -f /etc/selinux/config ]; then sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config; fi

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

COPY 100.rootfs-rockylinux/welcome $HOME/.welcome

# User-specific tools - $LAB_USER
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-code-server.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-fzf.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-bashrc.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts USER=$LAB_USER /tmp/scripts/customize-git.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/customize-vimrc.sh