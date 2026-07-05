---
title: Tabs

name: tabs
kind: unit
---

`playground.tabs` defines the panes of the playground page (1-10 entries). Omitting it yields the defaults (an IDE tab for most base playgrounds + a terminal per SSH-enabled machine, plus the Kubernetes Explorer for Kubernetes playgrounds); defining it replaces the defaults entirely:

```yaml
  tabs:
    - kind: ide
    - kind: http-port
      name: Web UI
      machine: dev-01
      number: 8080
    - kind: terminal
      machine: dev-01
    - kind: web-page
      name: Docs
      url: https://example.com/docs
```

| Field | Type | Applies to | Notes |
|---|---|---|---|
| `kind` | string | all | `terminal` (default), `ide`, `http-port`, `web-page`, `kexp`. |
| `machine` | string | `terminal`, `ide`, `http-port` | Target machine; defaults to the first machine. |
| `name` | string | all | Tab label; required for `http-port` and `web-page`. |
| `number` | int | `http-port` | The port to render; the app must listen on the machine's main interface or `0.0.0.0` (see [Expose HTTP Ports](/docs/playgrounds/expose-http-ports)). |
| `tls` | bool | `http-port` | Set `true` when the in-VM server speaks HTTPS. |
| `url` | string | `web-page` | The external page to embed. |
| `id` | string | all | Auto-generated (`<kind>-<machine>`); set explicitly only to disambiguate multiple tabs of the same kind on one machine. |

A bare `- machine: <name>` entry is shorthand for a terminal tab on that machine.
