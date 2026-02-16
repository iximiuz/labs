#!/bin/sh
set -eu

curl -L https://github.com/regclient/regclient/releases/latest/download/regctl-linux-amd64 > /usr/local/bin/regctl
chmod 755 /usr/local/bin/regctl
regctl completion bash > /etc/bash_completion.d/regctl
