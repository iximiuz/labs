# syntax=docker/dockerfile:1
ARG ROOTFS_RELEASE
FROM ghcr.io/iximiuz/labs/rootfs:ubuntu-k3s-bare-${ROOTFS_RELEASE}

ARG DAGGER_VERSION
ARG LAB_USER

USER root
ENV HOME=/root

RUN <<EOR
set -eu

curl -L https://dl.dagger.io/dagger/install.sh | BIN_DIR=/usr/local/bin DAGGER_VERSION=${DAGGER_VERSION} sh

dagger completion bash > /etc/bash_completion.d/dagger

printf "\nexport DAGGER_NO_NAG=1\n\n" >> $HOME/.bashrc

cat >> $HOME/.bashrc <<'EOL'

function dagger() {
  if [ "$(kubectl get pod --selector=name=dagger-dagger-helm-engine --namespace=dagger --output=name)" == "" ]; then
    echo "Dagger is not ready yet. Waiting..."

    sleep 5

    kubectl wait --for condition=Ready --timeout=60s pod --selector=name=dagger-dagger-helm-engine --namespace=dagger || {
      echo "Dagger engine pod is not ready in time."
      echo 'See "kubectl describe daemonset/dagger-dagger-helm-engine --namespace=dagger" for more.'
      return 1
    }
  fi

  local DAGGER_ENGINE_POD_NAME="$(kubectl get pod \
    --selector=name=dagger-dagger-helm-engine --namespace=dagger \
    --output=jsonpath='{.items[0].metadata.name}')"

  _EXPERIMENTAL_DAGGER_RUNNER_HOST="kube-pod://$DAGGER_ENGINE_POD_NAME?namespace=dagger" /usr/local/bin/dagger "$@"
}
EOL

mkdir -p /opt/iximiuz-labs/images
crane pull registry.dagger.io/engine:v${DAGGER_VERSION} /opt/iximiuz-labs/images/dagger-engine

cat > /opt/iximiuz-labs/image-loader.sh <<EOL
#!/bin/bash

ctr i import /opt/iximiuz-labs/images/dagger-engine
rm -rf /opt/iximiuz-labs/images

helm upgrade --install --namespace=dagger --create-namespace \
  dagger oci://registry.dagger.io/dagger-helm
EOL

chmod +x /opt/iximiuz-labs/image-loader.sh

cat > /etc/systemd/system/image-loader.service <<EOL
[Unit]
Description=Image Loader
After=network.target

[Service]
Type=oneshot
Environment="PATH=$PATH:/usr/bin:/usr/local/bin" "KUBECONFIG=/etc/rancher/k3s/k3s.yaml"
ExecStart=/opt/iximiuz-labs/image-loader.sh
Restart=on-failure
RestartSec=1s

[Install]
WantedBy=multi-user.target
EOL

mkdir -p /etc/systemd/system/multi-user.target.wants/
ln -s /etc/systemd/system/image-loader.service /etc/systemd/system/multi-user.target.wants/image-loader.service
EOR


USER $LAB_USER
ENV HOME=/home/$LAB_USER

RUN <<EOF
set -eu

printf "\nexport DAGGER_NO_NAG=1\n\n" >> $HOME/.bashrc

cat >> $HOME/.bashrc <<'EOL'

function dagger() {
  if [ "$(kubectl get pod --selector=name=dagger-dagger-helm-engine --namespace=dagger --output=name)" == "" ]; then
    echo "Dagger is not ready yet. Waiting..."

    sleep 5

    kubectl wait --for condition=Ready --timeout=60s pod --selector=name=dagger-dagger-helm-engine --namespace=dagger || {
      echo "Dagger engine pod is not ready in time."
      echo 'See "kubectl describe daemonset/dagger-dagger-helm-engine --namespace=dagger" for more.'
      return 1
    }
  fi

  local DAGGER_ENGINE_POD_NAME="$(kubectl get pod \
    --selector=name=dagger-dagger-helm-engine --namespace=dagger \
    --output=jsonpath='{.items[0].metadata.name}')"

  _EXPERIMENTAL_DAGGER_RUNNER_HOST="kube-pod://$DAGGER_ENGINE_POD_NAME?namespace=dagger" /usr/local/bin/dagger "$@"
}
EOL
EOF

COPY 400.rootfs-dagger-kubernetes/welcome $HOME/.welcome