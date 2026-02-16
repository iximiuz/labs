# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG DIVE_VERSION
ARG K0S_VERSION
ARG K0S_KUBECTL_VERSION
ARG K9S_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k0s.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECTL_VERSION=${K0S_KUBECTL_VERSION} \
    /tmp/scripts/get-kubectl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-helm.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k9s.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-kubectx.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-cdebug.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-dive.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-regctl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh

COPY 200.rootfs-ubuntu-k0s/kubeconfig-setup.sh /opt/iximiuz-labs/kubeconfig-setup.sh
COPY 200.rootfs-ubuntu-k0s/kubeconfig-setup.service /etc/systemd/system/kubeconfig-setup.service

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

COPY 200.rootfs-ubuntu-k0s/welcome $HOME/.welcome

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECONFIG=$HOME/.kube/config \
    /tmp/scripts/get-kexp.sh