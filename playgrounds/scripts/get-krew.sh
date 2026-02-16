#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} krew
install -m 755 ${TMP_DIR}/krew ${ARKADE_BIN_DIR}/krew

rm -rf ${TMP_DIR}