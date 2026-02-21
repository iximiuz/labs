---
title: How to Forward Remote Ports

name: forward-remote-ports
kind: unit
---

You can expose a service running on your local machine to the playground VM using the standard **SSH remote port forwarding**.
Since the `labctl port-forward -R` flag is not supported yet,
a workaround via `labctl ssh-proxy` and the standard `ssh -R` command should be used.

**Terminal 1:** Start an SSH proxy to the playground VM:

```sh
labctl ssh-proxy --address LOCAL_HOST:LOCAL_PORT PLAYGROUND_ID
```

**Terminal 2:** Forward a remote port using the standard `ssh -R` command:

```sh
ssh -i ~/.ssh/iximiuz_labs_user \
  -R [REMOTE_HOST:]REMOTE_PORT:[LOCAL_HOST:]LOCAL_PORT \
  ssh://laborant@LOCAL_HOST:LOCAL_PORT
```

Below are a few practical examples of how to use remote port forwarding.

## Exposing a local web server to the playground VM

1. Start a simple HTTP server on your local machine:

```sh
python3 -m http.server 4000
```

2. Start a new playground:

```sh
PLAY_ID=$(labctl playground start docker)
```

3. In a new terminal, start an SSH proxy to the playground:

```sh
labctl ssh-proxy --address 127.0.0.1:2222 $PLAY_ID
```

4. In yet another terminal, create a remote port forward so that the playground VM's `0.0.0.0:8080` points to your local machine's `127.0.0.1:4000`:

```sh
ssh -i ~/.ssh/iximiuz_labs_user \
  -R 0.0.0.0:8080:127.0.0.1:4000 \
  ssh://laborant@127.0.0.1:2222
```

5. Verify that the local web server is now accessible **from inside the playground VM**:

```sh
labctl ssh $PLAY_ID -- curl -s http://localhost:8080
```

The output should be the directory listing produced by the Python HTTP server running on your local machine.

## How it works

The above technique works by creating a reverse SSH tunnel between your local machine and the playground VM,
similar to the one on the following diagram:

::image-box
---
:src: __static__/ssh-remote-tunnel.png
:alt: "Exposing a local service to the playground VM using SSH remote tunnel."
---

Exposing a local web server to the playground VM using SSH remote tunnel.
The Gateway box on the diagram corresponds to the playground VM and the Client box corresponds to your local machine.
::