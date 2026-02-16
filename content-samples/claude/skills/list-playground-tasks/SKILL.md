---
name: list-playground-tasks
description: Lists all examiner tasks (init and regular) for a playground. Use to check the status of challenge/tutorial tasks.
argument-hint: <playground-id>
---

For a single-machine playground, list all examiner tasks for playground `$0` using the following command:

```sh
labctl ssh $0 -- examinerctl task ls
```

This shows all tasks (both init tasks and regular verification tasks) with their current status.

For a multi-machine playground, either add the `--machine <machine-name>` flag to the `labctl ssh` command to list tasks for a specific machine, or use the following command to list tasks from all machines of the playground:

```sh
labctl playground tasks $0
```

Use the `get-playground-task` skill with a specific task name to see detailed output
including stdout/stderr of the last execution.
