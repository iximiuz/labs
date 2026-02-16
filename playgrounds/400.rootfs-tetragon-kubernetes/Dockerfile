# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-k3s-bare-${ROOTFS_RELEASE}

ARG LAB_USER
ARG TETRAGON_VERSION

USER root
ENV HOME=/root

RUN <<EOR
set -eu

mkdir -p /opt/iximiuz-labs/images

crane pull quay.io/cilium/tetragon:v${TETRAGON_VERSION} /opt/iximiuz-labs/images/tetragon
crane pull quay.io/cilium/tetragon-operator:v${TETRAGON_VERSION} /opt/iximiuz-labs/images/tetragon-operator

cat <<EOF > /opt/iximiuz-labs/tetragon-setup.sh
#!/bin/bash

set -eu

if ! mount | grep -q /sys/fs/bpf; then
  mount bpffs /sys/fs/bpf -t bpf -o rw,nosuid,nodev,noexec,relatime,mode=700
fi

mount --make-shared /sys/fs/bpf

for i in \$(ls /opt/iximiuz-labs/images/); do
  echo "Loading \$i"
  ctr i import /opt/iximiuz-labs/images/\$i
  rm -rf /opt/iximiuz-labs/images/\$i
done

helm repo add cilium https://helm.cilium.io
helm repo update
if ! helm list -n kube-system | grep -q tetragon; then
  helm install tetragon cilium/tetragon --version v${TETRAGON_VERSION} -n kube-system
fi
kubectl rollout status -n kube-system ds/tetragon -w
EOF

chmod +x /opt/iximiuz-labs/tetragon-setup.sh

cat <<'EOF' > /etc/systemd/system/tetragon-setup.service
[Unit]
Description=Tetragon setup
After=k3s.service
Requires=k3s.service
Wants=sys-fs-bpf.mount

[Service]
Type=oneshot
Environment="PATH=$PATH:/usr/bin:/usr/local/bin" "KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
ExecStart=/opt/iximiuz-labs/tetragon-setup.sh
Restart=on-failure
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF

ln -s /etc/systemd/system/tetragon-setup.service /etc/systemd/system/multi-user.target.wants/tetragon-setup.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

COPY 400.rootfs-tetragon-kubernetes/welcome $HOME/.welcome