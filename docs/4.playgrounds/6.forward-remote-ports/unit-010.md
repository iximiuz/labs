---
title: How to Forward Remote Ports

name: forward-remote-ports
kind: unit
---

You can expose a service running on your local machine to the playground VM using the standard **SSH remote port forwarding**.

First, start an SSH proxy:

```sh
labctl ssh-proxy --address <local-proxy-address> <playground-id>
```

Then, forward a remote port to the local machine as follows:

```sh
ssh -i ~/.ssh/iximiuz_labs_user \
  -R <remote-host>:<remote-port>:<local-host>:<local-port> \
  ssh://root@<local-proxy-address>
```

::image-box
---
:src: __static__/ssh-remote-tunnel.png
:alt: "Exposing a local service to the playground VM using SSH remote tunnel."
---

Exposing a local web server to the playground VM using SSH remote tunnel.
The Gateway box on the diagram corresponds to the playground VM and the Client box corresponds to your local machine.
::