# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER

USER root
ENV HOME=/root

COPY 400.rootfs-docker-swarm-manager/swarm-manager-setup.sh \
    /opt/iximiuz-labs/swarm-manager-setup.sh

COPY 400.rootfs-docker-swarm-manager/swarm-manager-setup.service \
    /etc/systemd/system/swarm-manager-setup.service

RUN ln -s /etc/systemd/system/swarm-manager-setup.service \
    /etc/systemd/system/multi-user.target.wants/swarm-manager-setup.service


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 400.rootfs-docker-swarm-manager/welcome $HOME/.welcome