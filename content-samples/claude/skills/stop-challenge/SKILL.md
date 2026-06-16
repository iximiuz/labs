---
name: stop-challenge
description: Stops the current solution attempt for a challenge. Use when you need to stop a running challenge.
argument-hint: <challenge-name>
---

Stop the challenge `$0`.

```sh
labctl challenge stop $0
```

This stops the current solution attempt and its associated playground.

If the command fails but the challenge's playground is still running, force the teardown with `labctl playground destroy <playground-id>` (find the ID with `labctl playground list --filter challenge=$0`). **NEVER use `labctl playground stop`** — it only suspends the playground instead of terminating it.
