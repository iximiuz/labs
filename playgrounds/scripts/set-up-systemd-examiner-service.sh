#!/bin/sh
set -eu

cat <<EOF > /etc/systemd/system/examiner.service
[Unit]
Description=Examiner
After=network.target

[Service]
Type=simple
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin" "HOME=/root" "LAB_USER=$LAB_USER"
ExecStart=/usr/local/bin/examiner
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

ln -s /etc/systemd/system/examiner.service /etc/systemd/system/multi-user.target.wants/examiner.service
