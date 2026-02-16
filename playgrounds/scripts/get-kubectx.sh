#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} kubectx
install -m 755 ${TMP_DIR}/kubectx ${ARKADE_BIN_DIR}/kubectx

ark get --path ${TMP_DIR} kubens
install -m 755 ${TMP_DIR}/kubens ${ARKADE_BIN_DIR}/kubens

rm -rf ${TMP_DIR}