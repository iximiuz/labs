---
title: How to Forward Local Ports

name: forward-local-ports
kind: unit
---

You can securely expose any service (HTTP, TCP, UDP, etc) running in the playground to your local machine using the `labctl port-forward` command:

```sh
labctl port-forward <playground-id> -L <local-port>:<remote-port>
```

The above command is an equivalent of the standard local SSH tunnel.
