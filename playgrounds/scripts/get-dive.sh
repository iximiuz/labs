#!/bin/sh
set -eu

if [ -z "${DIVE_VERSION:-}" ]; then
  echo "DIVE_VERSION must be set"
  exit 1
fi

if [ "$(command -v apt)" != "" ]; then
  FORMAT="deb"
elif [ "$(command -v rpm)" != "" ]; then
  FORMAT="rpm"
else
  echo "apt or rpm must be installed"
  exit 1
fi

wget https://github.com/wagoodman/dive/releases/download/v${DIVE_VERSION}/dive_${DIVE_VERSION}_linux_amd64.${FORMAT}

if [ "${FORMAT}" = "deb" ]; then
  apt install ./dive_${DIVE_VERSION}_linux_amd64.${FORMAT}
elif [ "${FORMAT}" = "rpm" ]; then
  rpm -i dive_${DIVE_VERSION}_linux_amd64.${FORMAT}
fi

rm ./dive_${DIVE_VERSION}_linux_amd64.${FORMAT}
