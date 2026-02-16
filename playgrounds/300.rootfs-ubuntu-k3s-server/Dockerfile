# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG K3S_VERSION
ARG K3S_KUBECTL_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts \
    INSTALL_K3S_EXEC_EXTRA="--tls-san 172.16.0.2" /tmp/scripts/get-k3s.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECTL_VERSION=${K3S_KUBECTL_VERSION} \
    /tmp/scripts/get-kubectl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh

COPY 300.rootfs-ubuntu-k3s-server/kubeconfig-setup.sh /opt/iximiuz-labs/kubeconfig-setup.sh
COPY 300.rootfs-ubuntu-k3s-server/kubeconfig-setup.service /etc/systemd/system/kubeconfig-setup.service

RUN <<EOR
set -eu

envsubst < /etc/systemd/system/kubeconfig-setup.service > /tmp/kubeconfig-setup.service.tmp
mv /tmp/kubeconfig-setup.service.tmp \
    /etc/systemd/system/kubeconfig-setup.service

ln -s /etc/systemd/system/kubeconfig-setup.service \
    /etc/systemd/system/multi-user.target.wants/kubeconfig-setup.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN rm -f $HOME/.welcome || true

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh