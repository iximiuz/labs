# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-24-04-${ROOTFS_RELEASE}

ARG LAB_USER

USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 300.rootfs-mini-lan-ubuntu/welcome $HOME/.welcome