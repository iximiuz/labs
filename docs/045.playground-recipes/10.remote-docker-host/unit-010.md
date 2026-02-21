---
title: Using a Playground VM as a Remote Docker Context

name: remote-docker-context
kind: unit
---

## Motivation

Sometimes, you may want to run containers on a remote VM without having to SSH into it.
It may be useful when your local machine lacks sufficient resources to run the containers,
sits in a slow network, or you just want to keep your local machine clean and free of Docker-related clutter.

## Prerequisites

- `docker` CLI (via [Docker Desktop](https://docs.docker.com/desktop/), [Docker Engine](https://docs.docker.com/engine/install/), or standalone installation)
- [SSH access to the Docker playground](/docs/playgrounds/how-to-ssh) via an `ssh some-alias` command

## Adding a remote Docker context

1. Start a new [Docker playground](/playgrounds/docker):

```sh
PLAY_ID=$(labctl playground start docker)
```

2. Start an SSH proxy:

```sh
labctl ssh-proxy $PLAY_ID --address localhost:2222
```

3. Configure an SSH alias for the playground VM by adding the following to your `~/.ssh/config`:

```text
Host localhost 127.0.0.1 ::1
  IdentityFile ~/.ssh/iximiuz_labs_user
  AddKeysToAgent yes
  # UseKeychain yes  # <--- macOS-only option
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null

Host remote-docker
  HostName localhost
  Port 2222
  User laborant
  IdentityFile ~/.ssh/iximiuz_labs_user
```

Verify that the SSH alias works by running the following command:

```sh
ssh remote-docker
```

4. Add a remote Docker context by running the following command:

```sh
docker context create remote-docker --docker "host=ssh://remote-docker"
```

5. Verify that the remote Docker context works:

```sh
docker --context remote-docker \
    run -d --restart always -p 8080:80 nginx:alpine
```

::remark-box
The above command uses a local `docker` CLI to access the remote Docker engine running on the playground VM
(i.e., the playground VM acts as a Docker host).
::

Since the container is running on the playground VM, its port will be published only remotely.
To access it from your local machine, you need to additionally forward it using the following command:

```sh
labctl port-forward $PLAY_ID -L 8080:8080
```

Finally, you can access the container from your local machine using the following command:

```sh
curl http://localhost:8080
```

Additionally, you can verify that there is no `nginx` process running on your local machine:

```sh
pgrep nginx
```

The output of the above command should be empty, because the container is running on the playground VM.

## Making the setup permanent

By default, playgrounds started with `labctl playground start` are ephemeral (destroyed on termination).
To preserve the remote Docker host, you can either explicitly stop the playground (while it's still running) with:

```sh
labctl playground stop $PLAY_ID
```

...or make the running playground persistent (meaning its state will be preserved on termination):

```sh
labctl playground persist $PLAY_ID
```

After that, you can restart the playground with the same port forwards as before using its stable ID:

```sh
labctl playground restart --with-port-forwards $PLAY_ID
```

```sh
Restarting playground 6999c1a5099b162ab1290861...
Waiting for playground to restart... Done.
Playground has been restarted.
Restoring 2 port forward(s)...
6999c1a5099b162ab1290861
Forwarding 127.0.0.1:8080 -> :8080 (machine: docker-01)
Forwarding localhost:2222 -> :22 (machine: docker-01)
```

All containers started with the a restart policy will be automatically restarted on playground restart.
