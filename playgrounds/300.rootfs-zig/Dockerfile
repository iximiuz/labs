# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-docker-${ROOTFS_RELEASE}

ARG LAB_USER
ARG NERDCTL_VERSION
ARG NERDCTL_CNI_VERSION
ARG ZIG_VERSION

USER root
ENV HOME=/root

RUN --mount=type=bind,source=scripts,target=/tmp/scripts /tmp/scripts/get-nerdctl.sh


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 300.rootfs-zig/welcome $HOME/.welcome

RUN mkdir $HOME/hello-world
COPY 300.rootfs-zig/launch.json $HOME/hello-world/.vscode/launch.json

RUN <<'EOR'
#!/bin/bash
set -eu

curl -vL https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz -o /tmp/zig.tar.xz

mkdir -p $HOME/zig
tar -xvf /tmp/zig.tar.xz -C $HOME/zig
mv $HOME/zig/zig-x86_64-linux-${ZIG_VERSION}/* $HOME/zig
rm -rf $HOME/zig/zig-x86_64-linux-${ZIG_VERSION}
rm /tmp/zig.tar.xz

printf "\nexport PATH=\$PATH:\$HOME/zig\n" >> $HOME/.bashrc
export PATH=$PATH:$HOME/zig

cd $HOME/hello-world
zig init
zig build run

code-server --install-extension ziglang.vscode-zig
code-server --install-extension vadimcn.vscode-lldb

jq -s '.[0] * .[1]' $HOME/.local/share/code-server/User/settings.json - <<EOF > $HOME/.local/share/code-server/User/settings.json.tmp
{
  "zig.path": "$HOME/zig/zig",
  "zig.zls.path": "$HOME/.local/share/code-server/User/globalStorage/ziglang.vscode-zig/zls_install/zls",
  "zig.initialSetupDone": true
}
EOF

mv $HOME/.local/share/code-server/User/settings.json.tmp $HOME/.local/share/code-server/User/settings.json

sudo sed -i -r "s/^ExecStart=(.+\s)\/.+$/ExecStart=\1\/home\/$LAB_USER\/hello-world/" /lib/systemd/system/code-server.service
EOR