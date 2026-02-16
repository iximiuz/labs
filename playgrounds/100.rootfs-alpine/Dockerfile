# syntax=docker/dockerfile:1
ARG ALPINE_VERSION=3

FROM alpine:${ALPINE_VERSION}

ARG ARKADE_BIN_DIR
ARG WEBSOCAT_VERSION

COPY scripts/mount-pts.sh /etc/init.d/devpts
COPY scripts/mount-sys.sh /etc/init.d/sysfs

RUN <<EOF
set -eu

apk update
apk upgrade

apk add openrc

# Make sure the image doesn't look like a "docker" container.
sed -Ei 's/^#?rc_sys=.*/rc_sys=""/' /etc/rc.conf
sed -Ei 's/^rc_sys=.*/rc_sys=""/' /etc/rc.conf

rm -f /.dockerenv
echo 'rm -f /.dockerenv' >> /etc/local.d/rm-dockerenv.start
chmod +x /etc/local.d/rm-dockerenv.start
EOF

RUN <<EOF
set -eu

apk add \
  bash \
  bash-completion \
  bind-tools \
  ca-certificates \
  curl \
  file \
  git \
  htop \
  iproute2 \
  iputils \
  netcat-openbsd \
  net-tools \
  socat \
  sudo \
  procps \
  udev \
  vim \
  wget

rc-update add root boot

rc-update add devfs   sysinit
rc-update add procfs  sysinit
rc-update add sysfs   sysinit
rc-update add devpts  sysinit
rc-update add udev    sysinit

rc-update add local default

echo 'mount -a' >> /etc/local.d/mount-all.start
chmod +x /etc/local.d/mount-all.start

echo 'hostname -F /etc/hostname' >> /etc/local.d/hostname.start
chmod +x /etc/local.d/hostname.start

rm -f /etc/motd

# Hack to calm down Bender playground generation logic.
mkdir /boot

echo "root:root" | chpasswd
EOF

RUN <<EOR
set -eu

cat <<EOF > /etc/network/interfaces
auto lo
iface lo inet loopback
EOF

apk add ifupdown-ng ifupdown-ng-openrc
rc-update add networking boot
EOR

RUN <<EOF
set -eu

apk add openssh

rc-update add sshd

echo "HostKey /etc/ssh/ssh_host_ed25519_key" >> /etc/ssh/sshd_config
echo "AuthenticationMethods publickey" >> /etc/ssh/sshd_config
echo "PrintLastLog no" >> /etc/ssh/sshd_config
echo "AddressFamily inet" >> /etc/ssh/sshd_config
echo "UseDNS no" >> /etc/ssh/sshd_config
echo "MaxAuthTries 50" >> /etc/ssh/sshd_config

rm -f /etc/ssh/ssh_host_*
EOF

# Examiner section
COPY examiner* /usr/local/bin

RUN <<EOR
set -eu

cat <<EOF > /etc/init.d/examiner
#!/sbin/openrc-run

name="examiner"
command="/usr/local/bin/examiner"
command_args=""
command_user="root:root"
command_background="yes"
pidfile="/run/examiner.pid"
output_log="/var/log/examiner.log"
error_log="/var/log/examiner.log"

depend() {
  need net
}
EOF

chmod +x /etc/init.d/examiner

rc-update add examiner default
EOR

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-arkade.sh
RUN printf "\nexport PATH=\$PATH:/root/.arkade/bin\n" >> /root/.profile
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-common-tools.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-websocat.sh
RUN curl https://fx.wtf/install.sh | sh
