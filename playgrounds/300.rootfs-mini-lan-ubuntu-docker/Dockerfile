# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER

USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 300.rootfs-mini-lan-ubuntu-docker/welcome $HOME/.welcome