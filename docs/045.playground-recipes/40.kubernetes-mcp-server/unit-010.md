---
title: Claude Code and Kubernetes MCP Server in the Playground

name: kubernetes-mcp-server-in-playground
kind: unit
---

::remark-box
This recipe shows how to use [Red Hat's Kubernetes MCP server](https://github.com/containers/kubernetes-mcp-server) with Claude Code to manage Kubernetes clusters running in playgrounds.
However, the instructions should be applicable to most mainstream coding agents and IDEs (Codex, Cursor, VS Code etc.) and alternative Kubernetes MCP servers.
::

## Motivation

This is the recommended setup since it makes things much more secure (compared to running the agent and the MCP server on your local machine).
Running Claude Code and the Kubernetes MCP server inside the playground VM means neither the agent nor the MCP server can access your local filesystem or credentials.
The agent talks to the in-cluster Kubernetes API server directly without any port forwarding.

## Prerequisites

- [`labctl`](https://github.com/iximiuz/labctl) installed and authenticated

## Setting up the environment

1. Start a Kubernetes playground and capture its ID:

```sh
PLAY_ID=$(labctl playground start k3s)
```

::remark-box
Substitute `k3s` with [`k8s-omni`](/playgrounds/k8s-omni) or the name of your own custom Kubernetes playground.
::

2. SSH into the playground:

```sh
labctl ssh $PLAY_ID
```

3. Install Claude Code and log in:

```sh
curl -fsSL https://claude.ai/install.sh | bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

claude login
```

4. Install the [Kubernetes MCP server](https://github.com/containers/kubernetes-mcp-server) and register it with Claude Code:

::tabbed
---
tabs:
  - name: binary
    title: Go Binary
  - name: npx
    title: npx (Node.js required)
---
#binary

Download the MCP server binary from GitHub:

```sh
VERSION=0.0.60

curl -sL https://github.com/containers/kubernetes-mcp-server/releases/download/v${VERSION}/kubernetes-mcp-server-linux-amd64 \
    -o ~/.local/bin/kubernetes-mcp-server

chmod +x ~/.local/bin/kubernetes-mcp-server
```

Register the MCP server in Claude Code (assumes `~/.local/bin` is in your `PATH`):

```sh
claude mcp add k8s -- kubernetes-mcp-server \
    --kubeconfig $HOME/.kube/config
```

#npx

This method is simpler since it doesn't require downloading the MCP server binary, but it requires Node.js to be preinstalled in the playground (it relies on `npx` to run the MCP server):

```sh
claude mcp add k8s -- npx kubernetes-mcp-server@latest \
    --kubeconfig $HOME/.kube/config
```
::

5. Test it:

```sh
claude --dangerously-skip-permissions -p 'list all pods in all namespaces'
```
