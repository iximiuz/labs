---
title: Claude Code Locally with a Remote Kubernetes Cluster

name: kubernetes-mcp-server-locally
kind: unit
---

## Motivation

If you prefer to keep Claude Code on your local machine, you can still point the Kubernetes MCP server at a cluster running in a remote playground using the `labctl kube-proxy` helper.

## Prerequisites

- [`labctl`](https://github.com/iximiuz/labctl) installed and authenticated
- Claude Code installed locally

## Setting up the environment

1. Start a Kubernetes playground and capture its ID:

```sh
PLAY_ID=$(labctl playground start k3s)
```

::remark-box
Substitute `k3s` with [`k8s-omni`](/playgrounds/k8s-omni) or the name of your own custom Kubernetes playground.
::

2. Start a kube-proxy to [connect to the remote Kubernetes cluster from your local machine](/docs/playground-recipes/connect-to-kubernetes-cluster):

```sh
labctl kube-proxy $PLAY_ID
```

Keep this command running - it holds the tunnel open and prints the kubeconfig path you'll need in the next step.

3. In a new terminal, register the MCP server in Claude Code using the kubeconfig path printed by `labctl kube-proxy`:

::tabbed
---
tabs:
  - name: binary
    title: Go Binary
  - name: npx
    title: npx (Node.js required)
---
#binary

Download the MCP server binary for your platform from the [releases page](https://github.com/containers/kubernetes-mcp-server/releases):

```sh
VERSION=0.0.60

curl -sL https://github.com/containers/kubernetes-mcp-server/releases/download/v${VERSION}/kubernetes-mcp-server-linux-amd64 \
    -o ~/.local/bin/kubernetes-mcp-server

chmod +x ~/.local/bin/kubernetes-mcp-server
```

Then register it with Claude Code (assuming `~/.local/bin` is in your `PATH`):

```sh
claude mcp add k8s-$PLAY_ID -- kubernetes-mcp-server \
    --kubeconfig ~/.iximiuz/labctl/plays/$PLAY_ID-cplane-01-laborant/kubeconfig
```

#npx

This method doesn't require downloading the MCP server binary separately (it relies on `npx` - hence Node.js - to run the MCP server):

```sh
claude mcp add k8s-$PLAY_ID -- npx kubernetes-mcp-server@latest \
    --kubeconfig ~/.iximiuz/labctl/plays/$PLAY_ID-cplane-01-laborant/kubeconfig
```
::

4. Test it:

```sh
claude --dangerously-skip-permissions -p 'list all pods in all namespaces'
```
