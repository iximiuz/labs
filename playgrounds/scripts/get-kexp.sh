#!/bin/sh
set -eu

if [ -z "${KUBECONFIG:-}" ]; then
  echo "KUBECONFIG must be set"
  exit 1
fi

GOOS=linux
GOARCH=amd64

TMP_DIR=$(mktemp -d)
curl -Ls https://github.com/iximiuz/kexp/releases/latest/download/kexp_${GOOS}_${GOARCH}.tar.gz | tar xvzC ${TMP_DIR}
sudo install -m 755 ${TMP_DIR}/kexp /usr/local/bin
rm -rf ${TMP_DIR}


sudo tee /lib/systemd/system/kexp.service <<EOF
[Unit]
Description=kexp

[Service]
Type=exec
Environment="PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/go/bin" "HOME=$HOME" "KUBECONFIG=${KUBECONFIG}"
User=$LAB_USER
ExecStart=/usr/local/bin/kexp --host 0.0.0.0 --port 55173
Restart=on-failure
EOF

sudo tee /etc/systemd/system/kexp-proxy.service <<EOF
[Unit]
Description=kexp proxy
After=kexp.service
Requires=kexp.service

[Service]
ExecStart=/lib/systemd/systemd-socket-proxyd 127.0.0.1:55173
EOF

sudo tee /lib/systemd/system/kexp-proxy.socket <<EOF
[Unit]
Description=kexp proxy socket
PartOf=kexp-proxy.service

[Socket]
ListenStream=0.0.0.0:55174
NoDelay=true
Accept=no

[Install]
WantedBy=sockets.target
EOF

sudo ln -s /lib/systemd/system/kexp-proxy.socket /etc/systemd/system/multi-user.target.wants/kexp-proxy.socket