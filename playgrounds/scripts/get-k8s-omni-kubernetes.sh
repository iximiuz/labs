#!/usr/bin/env bash
set -eu

for var in K8S_OMNI_VERSION; do
  if [ -z "${!var:-}" ]; then
    echo "$var must be set"
    exit 1
  fi
done

cat <<EOF > /etc/modules-load.d/containerd.conf
overlay
br_netfilter
EOF

cat <<EOF > /etc/sysctl.d/99-kubernetes-cri.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

K8S_REPO_VERSION=${K8S_OMNI_VERSION%.*}

mkdir -p /etc/apt/keyrings/
curl -fsSL https://pkgs.k8s.io/core:/stable:/v${K8S_REPO_VERSION}/deb/Release.key | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v${K8S_REPO_VERSION}/deb/ /" >> /etc/apt/sources.list.d/kubernetes.list
apt-get update

apt-get install -y \
  kubeadm=${K8S_OMNI_VERSION}-* \
  kubelet=${K8S_OMNI_VERSION}-*

mkdir -p /opt/iximiuz-labs/images
for image in $(kubeadm config images list --kubernetes-version=v${K8S_OMNI_VERSION}); do
  crane pull $image /opt/iximiuz-labs/images/$(echo ${image##*/} | cut -d: -f1 | awk -F/ '{print $NF}')
done
