#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} helm
install -m 755 ${TMP_DIR}/helm ${ARKADE_BIN_DIR}/helm
helm completion bash > /etc/bash_completion.d/helm

rm -rf ${TMP_DIR}
