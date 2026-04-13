---
title: How to Forward Remote Ports

name: forward-remote-ports
kind: unit
---

You can securely expose TCP services running on your local machine to the playground VM using the `labctl port-forward` command -
a simplified equivalent of the standard `ssh -R` command:

```sh
labctl port-forward PLAYGROUND_ID -R [[REMOTE_HOST:]REMOTE_PORT:][LOCAL_HOST:]LOCAL_PORT
```

This capability comes in handy when you need to make a service running on your local machine (on intranet) accessible for services running in the remote playground.
For example, you can use it to expose a Chrome's debugging port (9222) to a coding agent running in the sandbox VM (see [Chrome DevTools MCP](https://github.com/ChromeDevTools/chrome-devtools-mcp)). Or you can combine it with [exposing HTTP/HTTPS ports](/docs/playgrounds/expose-http-ports) to make a local web server accessible on a public URL.

::image-box
---
:src: __static__/remote-port-forwarding-rev2.png
:alt: "The `labctl port-forward -R` command starts a foreground process on your machine that forwards all connections from a remote port on the playground VM to the corresponding local address."
---

The `labctl port-forward -R` command starts a foreground process on your machine that forwards all connections from a remote port on the playground VM to the corresponding local address.
::

Below is a practical example of how to use the `labctl port-forward -R` command.

## Exposing a local web server to the playground VM

1. Start a simple HTTP server on your local machine:

```sh
python3 -m http.server 4000
```

2. Start a new playground:

```sh
PLAY_ID=$(labctl playground start docker)
```

3. In a new terminal, forward the playground VM's `0.0.0.0:8080` to your local machine's `127.0.0.1:4000`:

```sh
labctl port-forward $PLAY_ID -R 8080:4000
```

```text
Forwarding 0.0.0.0:8080 (remote) -> 127.0.0.1:4000 (local)
```

4. Verify that the local web server is now accessible **from inside the playground VM**:

```sh
labctl ssh $PLAY_ID -- curl -s http://localhost:8080
```

The output should be the directory listing produced by the Python HTTP server running on your local machine.
