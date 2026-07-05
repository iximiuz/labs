---
title: Tabs

name: tabs
kind: unit
---

Tabs define the panes a user sees on the playground page. If the manifest doesn't mention tabs at all, the defaults are sensible:
an IDE tab (for most base playgrounds; `flexbox` defaults to terminals only) plus one terminal per (SSH-enabled) machine, and a [Kubernetes explorer](https://github.com/iximiuz/kexp) for [Kubernetes playgrounds](https://labs.iximiuz.com/playgrounds?category=kubernetes).

Declaring your own `tabs` list **replaces the defaults entirely**, giving you full control over the layout and order:

```yaml [manifest.yaml]
kind: playground
name: web-dev-lab
title: Web Dev Lab
playground:
  tabs:
    - kind: ide
      machine: dev-01
    - kind: http-port
      name: Web UI
      machine: dev-01
      number: 8080
    - kind: terminal
      machine: dev-01
    - kind: web-page
      name: Docs
      url: https://docs.example.com
  machines:
    - name: dev-01
      users:
        - name: laborant
          default: true
      drives:
        - source: golang
          mount: /
      network:
        interfaces:
          - network: local
  accessControl:
    canList:
      - owner
    canRead:
      - owner
    canStart:
      - owner
```

The available tab kinds:

| Kind | What it shows | Key fields |
|---|---|---|
| `terminal` | A shell on a machine (the default kind) | `machine` |
| `ide` | A web-based VS Code-style IDE | `machine` |
| `http-port` | An application port of a machine, rendered in an iframe | `machine`, `number` (port), `name`, optional `tls: true` for HTTPS backends |
| `web-page` | An external web page | `name`, `url` |
| `kexp` | The [Kubernetes Explorer](https://github.com/iximiuz/kexp) | - |

A playground can have from 1 to 10 tabs. Machines with `noSSH: true` never get terminal tabs.

::remark-box
💡 An `http-port` tab is a convenient permanent variant of [exposing HTTP ports](/docs/playgrounds/expose-http-ports): the application must listen on the machine's main interface (or `0.0.0.0`) for the tab to work. Users can still expose additional ports ad-hoc while the playground is running.
::
