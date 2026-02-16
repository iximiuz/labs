#!/bin/sh
set -eu

if [ -z "${MINTOOLKIT_VERSION:-}" ]; then
  echo "MINTOOLKIT_VERSION must be set"
  exit 1
fi

curl -L -o ds.tar.gz https://github.com/mintoolkit/mint/releases/download/${MINTOOLKIT_VERSION}/dist_linux.tar.gz
tar -xvf ds.tar.gz
mv  dist_linux/mint /usr/local/bin/
mv  dist_linux/mint-sensor /usr/local/bin/
rm -rf dist_linux ds.tar.gz

ln -s /usr/local/bin/mint /usr/local/bin/docker-slim
ln -s /usr/local/bin/mint-sensor /usr/local/bin/docker-slim-sensor
