---
name: ssh-into-playground
description: Opens an interactive SSH session to a running playground VM. Use when you need hands-on access to a playground.
argument-hint: <playground-id>
disable-model-invocation: true
---

Open an interactive SSH session to playground `$0`.

```sh
labctl ssh $0
```

To target a specific machine in a multi-machine playground:

```sh
labctl ssh $0 --machine <machine-name>
```

Note: This opens an **interactive** session. It is meant for the user to use directly.
For running commands programmatically, use the `run-playground-command` skill instead.
