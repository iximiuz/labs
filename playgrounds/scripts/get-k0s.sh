#!/bin/sh
set -eu

if [ -z "${K0S_VERSION:-}" ]; then
  echo "K0S_VERSION must be set"
  exit 1
fi

if [ -z "${K0S_KUBECTL_VERSION:-}" ]; then
  echo "K0S_KUBECTL_VERSION must be set"
  exit 1
fi

curl -sSLf https://get.k0s.sh | K0S_VERSION=v${K0S_VERSION} sh -

k0s install controller --single
systemctl enable k0scontroller

k0s completion bash > /etc/bash_completion.d/k0s
