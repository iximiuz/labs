#!/usr/bin/env bash
set -eu

for var in K8S_OMNI_CNI_PLUGINS_VERSION; do
  if [ -z "${!var:-}" ]; then
    echo "$var must be set"
    exit 1
  fi
done

# https://github.com/containernetworking/plugins/releases
ark system install cni --version=${K8S_OMNI_CNI_PLUGINS_VERSION}
