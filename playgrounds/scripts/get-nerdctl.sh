#!/bin/sh
set -eu

if [ -z "${NERDCTL_VERSION:-}" ]; then
  echo "NERDCTL_VERSION must be set"
  exit 1
fi

if [ -z "${NERDCTL_CNI_VERSION:-}" ]; then
  echo "NERDCTL_CNI_VERSION must be set"
  exit 1
fi

wget https://github.com/containerd/nerdctl/releases/download/v${NERDCTL_VERSION}/nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz
tar Cxzvvf /usr/local/bin nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz
rm nerdctl-${NERDCTL_VERSION}-linux-amd64.tar.gz
nerdctl completion bash > /etc/bash_completion.d/nerdctl

wget https://github.com/containernetworking/plugins/releases/download/v${NERDCTL_CNI_VERSION}/cni-plugins-linux-amd64-v${NERDCTL_CNI_VERSION}.tgz
mkdir -p /usr/libexec/cni

# Other possible CNI locations (see https://github.com/containerd/nerdctl/blob/main/docs/faq.md#how-to-change-the-cni-binary-path):
# ~/.local/libexec/cni
# ~/.local/lib/cni
# ~/opt/cni/bin
# /usr/local/libexec/cni
# /usr/local/lib/cni
# /usr/libexec/cni
# /usr/lib/cni
# /opt/cni/bin
tar -xvf cni-plugins-linux-amd64-v${NERDCTL_CNI_VERSION}.tgz -C /usr/libexec/cni
rm cni-plugins-linux-amd64-v${NERDCTL_CNI_VERSION}.tgz

if [ -n "${LAB_USER:-}" ]; then
  printf "\nalias nerdctl='sudo nerdctl'\n" >> /home/${LAB_USER}/.bashrc
fi
