---
title: Exposing Kubernetes API via direct access

name: exposing-kubernetes-api-via-direct-access
kind: unit
---

The Kubernetes API server usually runs on port 6443 and uses a self-signed certificate. To expose it, you can use the `--https` flag (or the **HTTPS** option in the **Expose HTTP(S) Ports** dialog) to set the target protocol to HTTPS.

1. Start a new [Kubernetes playground](/playgrounds/k3s):

```sh
PLAY_ID=$(labctl playground start k3s)
```

2. Expose the Kubernetes API server with a generated URL **on the control plane node**:

```sh
labctl expose port $PLAY_ID 6443 --https --machine cplane-01 --public
```

```text
HTTP port cplane-01:6443 exposed as https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
https://69a726071fce5dfccd59b97f-026f01.node-eu-d241.iximiuz.com
```

3. Verify that the Kubernetes API server is accessible by opening the generated URL in a browser.
