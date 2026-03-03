---
title: How to Expose HTTP/HTTPS Ports using the Web UI

name: web-ui
kind: unit
---

To expose a port, simply click the **Expose Port** button in the top right corner of a running playground and select the VM and the port to expose:

::image-box
---
:src: __static__/expose-http-port-dialog.png
:alt: "The **Expose HTTP(S) Ports** dialog."
:border: 'border border-slate-600'
:radius: 'lg'
---

The **Expose HTTP(S) Ports** dialog.
::

The **Expose HTTP(S) Ports** dialog provides a test `curl` command to verify the port is accessible on machine's main interface. Run it **from your playground VM** to verify the port can be reached by the ingress proxy. Example:

```sh
curl http://node-01:8080
```
