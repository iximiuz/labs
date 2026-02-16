#!/bin/sh
set -eu

if [ -z "${WEBSOCAT_VERSION:-}" ]; then
  echo "WEBSOCAT_VERSION must be set"
  exit 1
fi

curl -sLo /usr/local/bin/websocat https://github.com/vi/websocat/releases/download/v${WEBSOCAT_VERSION}/websocat.x86_64-unknown-linux-musl
chmod 755 /usr/local/bin/websocat
