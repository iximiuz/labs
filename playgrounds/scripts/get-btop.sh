#!/bin/sh
set -eu

if [ -z "${BTOP_VERSION:-}" ]; then
  echo "BTOP_VERSION must be set"
  exit 1
fi

DIR=$(mktemp -d)

curl -Ls "https://github.com/aristocratos/btop/releases/download/v${BTOP_VERSION}/btop-x86_64-linux-musl.tbz" | tar -xjf - -C "${DIR}"

cd "${DIR}/btop"
make install
cd /

rm -rf "${DIR}"
