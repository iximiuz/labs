#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} crane
install -m 755 ${TMP_DIR}/crane ${ARKADE_BIN_DIR}/crane
crane completion bash > /etc/bash_completion.d/crane

rm -rf ${TMP_DIR}