#!/bin/sh
set -eu

curl -sLS https://raw.githubusercontent.com/alexellis/arkade/master/get.sh | sh

ark completion bash > /etc/bash_completion.d/arkade
