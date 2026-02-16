# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER

USER root
ENV HOME=/root

COPY 400.rootfs-docker-swarm-worker/swarm-worker-setup.sh \
    /opt/iximiuz-labs/swarm-worker-setup.sh

COPY 400.rootfs-docker-swarm-worker/swarm-worker-setup.service \
    /etc/systemd/system/swarm-worker-setup.service

RUN ln -s /etc/systemd/system/swarm-worker-setup.service \
    /etc/systemd/system/multi-user.target.wants/swarm-worker-setup.service


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN rm -f $HOME/.welcome