---
title: UI tabs

name: ui-tabs
kind: unit
---

Tabs define the panes a user sees on the playground page. If the manifest doesn't mention tabs at all, the defaults are:

- one terminal tab per (SSH-enabled) machine
- an IDE tab (for most base playgrounds except for `flexbox` and `alpine` that default to terminals only)
- a [Kubernetes explorer](https://github.com/iximiuz/kexp) tab for [Kubernetes playgrounds](https://labs.iximiuz.com/playgrounds?category=kubernetes).

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
| `http-port` | An application port of a machine, rendered in an iframe | `machine`, `number` (port), `name` |
| `web-page` | An external web page | `name`, `url` |
| `kexp` | The [Kubernetes Explorer](https://github.com/iximiuz/kexp) | - |

A playground can have from 1 to 10 tabs. A few composition rules:

- `machine` defaults to the first machine of the playground, so single-VM manifests can omit it.
- A bare `- machine: <name>` entry is a shorthand for a terminal tab on that machine.
- Machines with `noSSH: true` never get terminal tabs - a tidy way to keep helper VMs out of the UI.
- Tab IDs are auto-generated as `<kind>-<machine>`; set `id` explicitly only when you need several tabs of the same kind on the same machine (e.g., two terminals side by side).

## HTTP port tabs

An `http-port` tab is a permanent, always-on variant of [exposing HTTP ports](/docs/playgrounds/expose-http-ports),
typically pointing at the main application of the playground - a web UI, a dashboard, an `HTTP GET` REST API endpoint output.
The same rules apply: the application must listen on the machine's main interface (or `0.0.0.0`) for the tab to work,
and users can still expose additional ports ad-hoc while the playground is running.

A few extra knobs for less common backends:

- `tls: true` - the in-VM server speaks HTTPS rather than plain HTTP.
- `hostRewrite` - rewrite the `Host` header for servers that validate it (same idea as the `--host-rewrite` flag of `labctl expose port`).
- `pathRewrite` - prepend/replace the URL path if the app isn't served from `/`.

::remark-box
💡 If the application takes a while to start (e.g., it's launched by an [init task](/docs/custom-playgrounds/init-tasks)), the tab may initially render an error page - a reload once the service is up fixes it.
::
