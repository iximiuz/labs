---
title: Tabs

name: tabs
kind: unit
---

`playground.tabs` defines the panes of the playground page (1-10 entries (see [the UI tabs lesson](/docs/custom-playgrounds/ui-tabs) for more). Omitting it yields the defaults (an IDE tab for most base playgrounds + a terminal per SSH-enabled machine, plus the Kubernetes Explorer for Kubernetes playgrounds); defining it replaces the defaults entirely:

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
| `hostRewrite` | string | `http-port` | Rewrite the `Host` header for servers that validate it. |
| `pathRewrite` | string | `http-port` | Rewrite the URL path when the app isn't served from `/`. |
| `url` | string | `web-page` | The external page to embed. |
| `pane` | string | all | `left` (default) or `right` - which pane of the split-screen view the tab lives in. Must be omitted when `target` is `window`. |
| `target` | string | `http-port`, `web-page` | `pane` (default) renders the tab in an embedded pane; `window` opens it in a new browser tab on click (for pages that can't be framed). |
| `id` | string | all | Auto-generated (`<kind>-<machine>`); set explicitly only to disambiguate multiple tabs of the same kind on one machine. |

A bare `- machine: <name>` entry is shorthand for a terminal tab on that machine.
