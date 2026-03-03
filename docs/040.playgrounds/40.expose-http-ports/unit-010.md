---
title: How and Why to Expose HTTP/HTTPS Ports

name: introduction
kind: unit
---

You can expose HTTP and HTTPS applications running in a playground VM to the public internet.
An exposed application becomes accessible via a unique URL that can be used either by you (from a browser or another device) or shared with others.

Typical use cases are:

- Experimenting with ~~Kubernetes Dashboard~~ Headlamp, Grafana, or any other web application deployed in a playground
- Sharing a web application you're working on with friends or colleagues
- Exposing an API service running in a playground to the public internet
- Running a (graphical) remote desktop in a playground VM ([example](https://labs.iximiuz.com/playgrounds/ubuntu-desktop-on-web-df04797f))

::image-box
---
:src: __static__/expose-http-ports.png
:alt: "The `labctl expose port` command generates a unique URL that can be used to access the application from anywhere in the world."
---

The `labctl expose port` command generates a unique URL that can be used to access the application from anywhere in the world.
::

## What ports can be exposed?

::remark-box
---
:kind: warning
---

⚠️&nbsp;&nbsp;**Only applications listening on the machine's main network interface (usually `eth1` with an IP address in the `172.16.0.0/24` subnet) or all interfaces (`0.0.0.0`) can be exposed.**
::

Applications listening on the VM's localhost or internal interfaces (e.g., created by a Kubernetes networking plugin) cannot be exposed directly. As a workaround, you can forward such ports from a local to the main interface using `socat` or a similar tool and then expose the forwarded port instead.

## Private vs. public exposed ports

Exposed HTTP(S) ports are **private** by default, meaning only the playground owner can access them.
If you want to share an exposed port with others, you need to set the access control to **public** before exposing the port.
Note that public exposed ports are visible to everyone, including anonymous users, so be mindful and avoid exposing sensitive ports to the public.

## HTTP vs. HTTPS ports

Generated URLs always use the HTTPS protocol. However, the exposed application can be either HTTP or HTTPS (defaults to HTTP). If the target application serves traffic over HTTPS, you need to set the **HTTPS** option to **Yes** in the **Expose HTTP(S) Ports** dialog. This will inform the ingress proxy to access the application using the HTTPS protocol. The target application MAY use a self-signed certificate or a certificate from a private CA.
