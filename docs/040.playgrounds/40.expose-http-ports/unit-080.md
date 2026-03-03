---
title: Exposing Kubernetes API via `kubectl proxy`

name: exposing-kubernetes-api-via-kubectl-proxy
kind: unit
---

If you want to bypass the API server's authentication, you can use the `kubectl proxy` command to forward the API server's port to the `dev-machine` VM of the playground **combined with the `--host-rewrite localhost` flag** of the `labctl expose port` command.

1. Start a new [Kubernetes playground](/playgrounds/k3s):

```sh
PLAY_ID=$(labctl playground start k3s)
```

2. Forward the API server's port 6443 to the `dev-machine` VM of the playground using the `kubectl proxy` command:

```sh
labctl ssh -m dev-machine $PLAY_ID -- \
    kubectl proxy --address 0.0.0.0 --port 8080
```

```text
Starting to serve on [::]:8080
```

3. Expose the forwarded port with a generated URL:

```sh
labctl expose port $PLAY_ID 8080 --public \
    --machine dev-machine --host-rewrite localhost
```

```text
HTTP port dev-machine:8080 exposed as https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
```

4. Verify that the Kubernetes API server is accessible:

```sh
curl https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com/version
```

```text
{
  "major": "1",
  "minor": "35",
  ...
}
```
