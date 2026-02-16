# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG K3S_KUBECTL_VERSION
ARG K9S_VERSION
ARG LAB_USER
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECTL_VERSION=${K3S_KUBECTL_VERSION} \
    /tmp/scripts/get-kubectl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-helm.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k9s.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-kubectx.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh

COPY 300.rootfs-ubuntu-k3s-dev-machine/kubeconfig-setup.sh /opt/iximiuz-labs/kubeconfig-setup.sh
COPY 300.rootfs-ubuntu-k3s-dev-machine/kubeconfig-setup.service /etc/systemd/system/kubeconfig-setup.service

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

COPY 300.rootfs-ubuntu-k3s-dev-machine/welcome $HOME/.welcome

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECONFIG=$HOME/.kube/config \
    /tmp/scripts/get-kexp.sh