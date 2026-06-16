---
name: stop-playground
description: Terminates (destroys) a running playground session. Use when you need to shut down a playground.
argument-hint: <playground-id>
---

Destroy the playground `$0`.

```sh
labctl playground destroy $0
```

This terminates the ephemeral playground for good.

**NEVER use `labctl playground stop` — avoid it by all means.** `stop` does NOT terminate the playground: it suspends it, preserving its state for a later resume, so the session keeps lingering around. The ephemeral playgrounds used for content authoring and testing must always be terminated with `labctl playground destroy`.
