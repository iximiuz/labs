#!/bin/sh
set -eu

if [ -z "${K9S_VERSION:-}" ]; then
  echo "K9S_VERSION must be set"
  exit 1
fi

DIR=$(mktemp -d)
curl -Ls https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_amd64.tar.gz | tar xvzC ${DIR}
mv ${DIR}/k9s /usr/local/bin && rm -rf ${DIR}
k9s completion bash > /etc/bash_completion.d/k9s