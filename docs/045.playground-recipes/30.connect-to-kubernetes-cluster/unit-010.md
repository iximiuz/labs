---
title: Connect to a Playground Kubernetes Cluster from Your Local Machine

name: connect-to-kubernetes-cluster
kind: unit
---

## Motivation

Playground Kubernetes clusters run inside remote VMs, so `kubectl` on your local machine can't reach the API server directly.
This recipe shows how to forward the Kubernetes API port and patch the kubeconfig so that your local `kubectl` talks to the cluster as if it were local.

## Prerequisites

- [`labctl`](https://github.com/iximiuz/labctl) installed and authenticated
- `kubectl` installed locally
- `sed` or [`yq`](https://github.com/mikefarah/yq) for editing the kubeconfig

## Steps

**1. Start a Kubernetes playground:**

```sh
PLAY_ID=$(labctl playground start k3s)
```

::remark-box
Substitute `k3s` with [`k8s-omni`](/playgrounds/k8s-omni) or the name of your own custom Kubernetes playground.
::

**2. Forward the Kubernetes API port to localhost:**

```sh
labctl port-forward -L 6443:6443 -m cplane-01 $PLAY_ID
```

Keep this command running - it holds open the tunnel.

::remark-box
`cplane-01` is the control plane machine name in the standard `k3s` and `k8s-omni` playgrounds.
If you're using a custom playground, substitute it with the actual name of your control plane VM.
::

**3. In a new terminal, copy the remote kubeconfig:**

```sh
labctl cp $PLAY_ID:~/.kube/config ./config-$PLAY_ID
```

::remark-box
If your playground stores the kubeconfig at a different path, adjust the source accordingly (e.g., `/etc/kubernetes/admin.conf` for kubeadm-based clusters).
::

**4. Replace the API server address in the kubeconfig:**

The copied kubeconfig points to the cluster's internal IP, which isn't reachable from your machine.
Rewrite it to `127.0.0.1` so traffic goes through the forwarded port:

Using `sed`:

```sh
sed -i 's|https://[^:]*:6443|https://127.0.0.1:6443|g' ./config-$PLAY_ID
```

Or using `yq`:

```sh
yq e '.clusters[].cluster.server = "https://127.0.0.1:6443"' -i ./config-$PLAY_ID
```

**5. Point `kubectl` at the patched config and verify access:**

```sh
export KUBECONFIG=$(pwd)/config-$PLAY_ID

kubectl get all
```

You should see the cluster's resources listed, confirming that your local `kubectl` is talking to the playground Kubernetes API through the forwarded port.
