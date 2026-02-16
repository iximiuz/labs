#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} kubectl --version v${KUBECTL_VERSION}
install -m 755 ${TMP_DIR}/kubectl ${ARKADE_BIN_DIR}/kubectl
kubectl completion bash > /etc/bash_completion.d/kubectl

rm -rf ${TMP_DIR}
