---
title: How to Forward Local Ports

name: forward-local-ports
kind: unit
---

You can securely expose HTTP/TCP/UDP services running in the playground VM to your local machine using the `labctl port-forward` command -
a simplified equivalent of the standard `ssh -L` command:

```sh
labctl port-forward PLAYGROUND_ID -L [[LOCAL_HOST:]LOCAL_PORT:][REMOTE_HOST:]REMOTE_PORT
```

Below are a few practical examples of how to use the `labctl port-forward -L` command.

## Exposing a service listening on the external interface

1. Start a new playground:

```sh
PLAY_ID=$(labctl playground start docker)
```

2. Start a new Nginx container making it available on the playground VM's `0.0.0.0:8080` address:

```sh
labctl ssh $PLAY_ID -- docker run -d -p 8080:80 nginx:alpine
```

3. Forward the published port 8080 to the local machine's `127.0.0.1:8080` address with a simple `-L 8080:8080` flag:

```sh
labctl port-forward $PLAY_ID -L 8080:8080
```

```text
Forwarding 127.0.0.1:8080 -> :8080
```

4. Verify that the Nginx server is running on the local machine:

```sh
curl http://localhost:8080
```

The output should be the Nginx welcome page.

## Exposing a service listening on an internal address

1. Start a new playground:

```sh
PLAY_ID=$(labctl playground start docker)
```

2. Start a new Nginx container but **do not publish its port 80 to the external interface**:

```sh
labctl ssh $PLAY_ID -- docker run -d --name nginx-1 nginx:alpine
```

3. Find the container's IP address using the following command:

```sh
labctl ssh $PLAY_ID -- docker inspect \
    -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' nginx-1
```

```text
172.17.0.2
```

4. Forward the container's port 80 to the local machine's `127.0.0.1:8080` address using the complete local and remote addresses:

```sh
labctl port-forward $PLAY_ID -L 127.0.0.1:8080:172.17.0.2:80
```

5. Verify that the Nginx server is running on the local machine:

```sh
curl http://localhost:8080
```

The output should be the Nginx welcome page.

## Restoring previously forwarded ports with ease

The `labctl port-forward` command starts a foreground process that forwards all connections to the local port to the remote port.
If such a foreground process is terminated, the port forwarding will be interrupted,
which is especially annoying if you're forwarding several ports at once.

Luckily, the `labctl port-forward` command keeps track of the previously forwarded ports.
If you (accidentally or on purpose) terminate the forwarding process(es), you can easily restore port forwarding with:

```sh
labctl port-forward PLAYGROUND_ID --restore
```

This capability is particularly useful when combined with [Persistent Playgrounds](/docs/playgrounds/persistent-playgrounds) -
you can restore all previously forwarded ports on a playground restart automatically with:

```sh
labctl playground restart --with-port-forwards PLAYGROUND_ID
```

You can also list all previously forwarded ports with:

```sh
labctl port-forward PLAYGROUND_ID --list
```

And remove a previously forwarded port with:

```sh
labctl port-forward PLAYGROUND_ID --remove POSITION_IN_LIST
```
