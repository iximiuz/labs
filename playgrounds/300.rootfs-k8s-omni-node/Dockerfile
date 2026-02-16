# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG ARKADE_BIN_DIR
ARG K8S_OMNI_VERSION
ARG K8S_OMNI_CNI_PLUGINS_VERSION
ARG K8S_OMNI_CONTAINERD_VERSION
ARG K8S_OMNI_CRI_O_VERSION
ARG K8S_OMNI_CRICTL_VERSION
ARG K8S_OMNI_RUNC_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-crane.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k8s-omni-containerd.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k8s-omni-cri-o.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k8s-omni-cni-plugins.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-k8s-omni-kubernetes.sh

RUN --mount=type=bind,source=scripts,target=/tmp/scripts CRICTL_VERSION=${K8S_OMNI_CRICTL_VERSION} /tmp/scripts/get-crictl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts KUBECTL_VERSION=${K8S_OMNI_VERSION} /tmp/scripts/get-kubectl.sh
RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN rm -f $HOME/.welcome || true

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/add-kubectl-alias.sh