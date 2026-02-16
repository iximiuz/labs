#!/bin/sh
set -eu

ln -s / $HOME/.rootfs

curl -fsSL https://code-server.dev/install.sh | sh

mkdir -p $HOME/.local/share/code-server/User
cat <<EOF > $HOME/.local/share/code-server/User/settings.json
{
  "remote.autoForwardPorts": false,
  "telemetry.telemetryLevel": "off",
  "workbench.colorTheme": "Default Dark Modern",
  "workbench.remote.experimental.showStartListEntry": false,
  "workbench.startupEditor": "none",
  "workbench.statusBar.visible": true,
  "workbench.welcome.experimental.dialog": false,
  "workbench.welcomePage.walkthroughs.openOnInstall": false,
  "files.watcherExclude": {
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/*/**": true,
    "**/.hg/store/**": true,
    "$HOME/.rootfs/**": true
  }
}
EOF

sudo -E tee /lib/systemd/system/code-server.service <<EOF
[Unit]
Description=code-server

[Service]
Type=exec
User=$LAB_USER
Restart=on-failure
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin:$HOME/go/bin" "HOME=$HOME" "CODE_SERVER_PATH=$HOME"
EnvironmentFile=-/etc/default/%p
EOF

sudo tee -a /lib/systemd/system/code-server.service <<'EOF'
ExecStart=/usr/bin/code-server --bind-addr=127.0.0.1:50062 --auth none --disable-telemetry --disable-update-check --disable-workspace-trust --disable-getting-started-override --app-name="iximiuz Labs" $CODE_SERVER_PATH
EOF

sudo tee /etc/systemd/system/code-server-proxy.service <<EOF
[Unit]
Description=code-server proxy
After=code-server.service
Requires=code-server.service

[Service]
ExecStart=/lib/systemd/systemd-socket-proxyd 127.0.0.1:50062
EOF

sudo tee /lib/systemd/system/code-server-proxy.socket <<EOF
[Unit]
Description=code-server proxy socket
PartOf=code-server-proxy.service

[Socket]
ListenStream=0.0.0.0:50061
NoDelay=true
Accept=no

[Install]
WantedBy=sockets.target
EOF

sudo ln -s /lib/systemd/system/code-server-proxy.socket /etc/systemd/system/multi-user.target.wants/code-server-proxy.socket

code-server --install-extension redhat.vscode-yaml
