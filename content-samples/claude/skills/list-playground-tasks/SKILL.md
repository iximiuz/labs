---
name: list-playground-tasks
description: Lists all examiner tasks (init and regular) for a playground. Use to check the status of challenge/tutorial tasks.
argument-hint: <playground-id>
---

**Default (preferred): list tasks via the API.** This works for single- and
multi-machine playgrounds, shows tasks from **all** machines, and needs **no SSH
tunnel** - so it's the right tool for polling in a loop while waiting on init or
verification:

```sh
labctl playground tasks $0 -o yaml
```

Because this path is tunnel-free, **prefer it over SSH for status polling** - it
avoids exhausting the SSH tunnel slot pool (see the SSH tunnel discipline notes in
the `run-playground-command` skill).

**Tasks are edge-activated (not level-triggered) and their status never regresses:**
the examiner keeps evaluating a task until it *first* observes a success or failure
state, then it settles into its terminal state - `completed` (`40`) or `failed`
(`35`) - and never runs again, even if the world state later changes. The numerical
status only ever increases. So when polling, stop as soon as every non-helper task
has reached `40`; a passed task cannot later flip back or fail.

The SSH-based alternative lists tasks for a single machine only (the one you SSH
into) and is rarely needed now:

```sh
labctl ssh $0 -- examinerctl task ls
# or, for a specific machine:
labctl ssh $0 --machine <machine-name> -- examinerctl task ls
```

Use the `get-playground-task` skill with a specific task name to see detailed output
including stdout/stderr of the last execution.
