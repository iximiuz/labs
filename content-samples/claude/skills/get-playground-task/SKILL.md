---
name: get-playground-task
description: Gets detailed status and output of a specific examiner task on a playground. Use to debug why a task is failing.
argument-hint: <playground-id> <task-name>
---

Get detailed information about examiner task `$1` on playground `$0`.

```sh
labctl ssh $0 -- examinerctl task get $1
```

This shows the task's status and the stdout/stderr of the last execution,
which is useful for understanding why a task is passing or failing.
