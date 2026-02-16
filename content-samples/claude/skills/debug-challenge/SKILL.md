---
name: debug-challenge
description: Debugs an existing challenge by starting it, inspecting tasks, troubleshooting over SSH, fixing source files, and restarting. Use when a challenge's tasks are failing or hanging.
argument-hint: <challenge-name>
disable-model-invocation: true
---

Debug the challenge `$0`. Follow these steps in order:

## 1. Start the challenge in the background

Run the challenge start command in the background (it may block waiting for init tasks):

```sh
labctl challenge start $0 --no-open --no-ssh
```

Do **not** wait for it to complete - proceed immediately to the next step.

## 2. Find the playground ID

Use the `list-running-playgrounds` skill (or `labctl playground list`) to find the
playground ID corresponding to this challenge. You'll need this ID for all subsequent steps.

## 3. Inspect examiner tasks

Use the `list-playground-tasks` skill to list all tasks:

```sh
labctl ssh <playID> -- examinerctl task ls
```

Then use the `get-playground-task` skill to inspect individual tasks that are failing or hanging:

```sh
labctl ssh <playID> -- examinerctl task get <task-name>
```

This shows the task status and stdout/stderr from the last execution.

## 4. Troubleshoot over SSH

If the task output is not enough to identify the problem, run commands on the
playground VM using the `run-playground-command` skill:

```sh
labctl ssh <playID> -- <diagnostic-command>
```

Common diagnostics: checking file contents, running scripts manually, inspecting
service status, reviewing logs, testing network connectivity, etc.

**Tip:** If the machine you need to inspect has `noSSH: true`, you won't be able to
`labctl ssh` into it. Temporarily comment out the directive (`#noSSH: true`), push the
change, and restart the challenge. Remember to restore it when done debugging.

## 5. Fix the challenge source

Based on your findings, edit the challenge's local source files (typically `index.md`)
to fix the failing tasks. Common fixes include:
- Adjusting init task scripts
- Fixing verification task conditions
- Correcting expected outputs or paths

## 6. Push changes and restart the challenge

**Important:** After pushing changes, you **must restart the challenge** for the changes
to take effect. The running playground uses the old version of the content.

First, push the changes using the `edit-remote-content` skill:

```sh
labctl content push challenge $0 --dir <folder> --force
```

Then stop the current playground and start a fresh one:

```sh
labctl challenge start $0 --no-open --no-ssh
```

Go back to step 2 and verify that the tasks now pass.

## 7. Repeat if needed

If tasks are still failing, repeat steps 2-6 until all tasks pass.
