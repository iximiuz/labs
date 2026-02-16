#!/bin/sh
set -eu

GOOS=linux
GOARCH=amd64
DIR=$(mktemp -d)

curl -Ls https://github.com/iximiuz/cdebug/releases/latest/download/cdebug_${GOOS}_${GOARCH}.tar.gz | tar xvzC ${DIR}
mv ${DIR}/cdebug /usr/local/bin && rm -rf ${DIR}
cdebug completion bash > /etc/bash_completion.d/cdebug
