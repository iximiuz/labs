---
title: Exposing a Kubernetes application via `kubectl port-forward`

name: exposing-kubernetes-application-via-kubectl-port-forward
kind: unit
---

1. Start a new [Kubernetes playground](/playgrounds/k3s):

```sh
PLAY_ID=$(labctl playground start k3s)
```

2. Deploy a sample Kubernetes application (a single Pod would do the trick):

```sh
labctl ssh $PLAY_ID -- kubectl run nginx-01 --image=nginx:alpine
```

3. Forward the application's port 80 to the `dev-machine` VM of the playground using the `kubectl port-forward` command:

```sh
labctl ssh -m dev-machine $PLAY_ID -- \
    kubectl port-forward --address 0.0.0.0 pod/nginx-01 8080:80
```

```text
Forwarding from 0.0.0.0:8080 -> 80
```

::remark-box
---
:kind: warning
---

Note that the `kubectl port-forward` command must use the `--address 0.0.0.0` flag to forward the port to all interfaces on the `dev-machine` VM. Otherwise, the forwarded port will only be accessible on the VM's localhost, which will make it impossible to expose with a generated URL.
::

4. Expose the forwarded port with a generated URL:

```sh
labctl expose port $PLAY_ID 8080 --machine dev-machine --public
```

```text
HTTP port dev-machine:8080 exposed as https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
```

5. Verify that the Nginx server is accessible by opening the generated URL in a browser.
