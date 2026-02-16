# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG K8S_OMNI_VERSION
ARG K9S_VERSION
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECTL_VERSION=${K8S_OMNI_VERSION} \
    /tmp/scripts/get-kubectl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-helm.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k9s.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-kubectx.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 300.rootfs-k8s-omni-dev-machine/welcome $HOME/.welcome

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-krew-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECONFIG=$HOME/.kube/config \
    /tmp/scripts/get-kexp.sh