#!/bin/sh
set -eu

TMP_DIR=$(mktemp -d)

ark get --path ${TMP_DIR} jq
install -m 755 ${TMP_DIR}/jq ${ARKADE_BIN_DIR}/jq

ark get --path ${TMP_DIR} yq
install -m 755 ${TMP_DIR}/yq ${ARKADE_BIN_DIR}/yq
yq completion bash > /etc/bash_completion.d/yq

ark get --path ${TMP_DIR} task
install -m 755 ${TMP_DIR}/task ${ARKADE_BIN_DIR}/task
TASK_VER=$(task --version | grep -oE '[0-9]+\.[0-9]+\.[0-9]+')
curl -sSL -o /etc/bash_completion.d/task \
  https://raw.githubusercontent.com/go-task/task/v${TASK_VER}/completion/bash/task.bash

ark get --path ${TMP_DIR} just
install -m 755 ${TMP_DIR}/just ${ARKADE_BIN_DIR}/just
just --completions bash > /etc/bash_completion.d/just

rm -rf ${TMP_DIR}