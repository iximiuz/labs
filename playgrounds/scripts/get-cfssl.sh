#!/bin/sh
set -eu

if [ -z "${CFSSL_VERSION:-}" ]; then
  echo "CFSSL_VERSION must be set"
  exit 1
fi

DIR=$(mktemp -d)
cd "${DIR}"

curl -fsSL --remote-name-all https://github.com/cloudflare/cfssl/releases/download/v${CFSSL_VERSION}/{cfssl-bundle,cfssl-certinfo,cfssl-newkey,cfssl-scan,cfssljson,cfssl,mkbundle,multirootca}_${CFSSL_VERSION}_linux_amd64

for src in *_${CFSSL_VERSION}_linux_amd64; do
  dst="${src%_${CFSSL_VERSION}_linux_amd64}"
  mv "${src}" "${dst}"
  chmod +x "${dst}"
  mv "${dst}" /usr/bin
done

cd ..
rm -rf "${DIR}"