#!/bin/bash
set -eu

cat /opt/iximiuz-labs/incus.yaml | incus admin init --preseed
