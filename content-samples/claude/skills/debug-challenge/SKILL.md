---
name: debug-challenge
description: Debugs an existing challenge by starting it, inspecting tasks, troubleshooting over SSH, fixing source files, and restarting. Use when a challenge's tasks are failing or hanging.
argument-hint: <challenge-name>
disable-model-invocation: true
---

Debug the challenge `$0`. Follow these steps in order.

> **Debugging why a *solution* doesn't solve?** Prefer the CI helper path (the
> `solve-challenge` skill / `tests/challenges/main.go --skip-auth`) instead of the manual
> flow below. It starts its own playground and, **while it runs**, you can point ordinary
> `labctl` commands at that playground (`labctl playground tasks <id> -o yaml`,
> `labctl ssh <id> -- <diag>`). Most importantly it writes a per-solution **artifacts
> directory** (path printed at the start of the run) whose files are appended *dynamically
> during the attempt* — `chunk-NN.*.log` (per-chunk output), `tasks-*.txt`
> (`labctl playground tasks -o yaml` snapshots every 15s), and `journal-<machine>.examiner.log`.
> Analyzing those artifacts is the fastest way to find the failing chunk or task. The manual
> flow below is for debugging the challenge *environment/tasks* directly.

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

Get the overview via the **API (no SSH tunnel)** - poll this in a loop while init
tasks are still running:

```sh
labctl playground tasks <playID> -o yaml
```

**Tasks are edge-activated and never regress:** once a task shows `completed`
(`40`) it stays there for the life of the playground, so a single `completed`
observation is authoritative.

**SSH discipline:** run `labctl ssh` calls foreground and one at a time - never in a
backgrounded retry loop. Orphaned `labctl ssh` children exhaust the tunnel pool and
every later ssh then fails with `StartTunnel(): retry after 2562047h47m16s`. If you
hit that, `pkill -9 -f 'labctl ssh'` and retry (see `run-playground-command`).

## 4. Troubleshoot over SSH

If the task output is not enough to identify the problem, run commands on the
playground VM using the `run-playground-command` skill:

```sh
labctl ssh <playID> -- <diagnostic-command>
```

Common diagnostics: checking file contents, running scripts manually, inspecting
service status, reviewing logs, testing network connectivity, etc.

**Tip:** If the machine you need to inspect has `noSSH: true`, you can still read its
task status and last-run output via `labctl playground tasks <playID> -o yaml` (the API
covers hidden machines too). Only when you need to run *live diagnostic commands* on
that machine must you temporarily comment out the directive (`#noSSH: true`), push, and
restart the challenge. Remember to restore it when done debugging.

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

Then stop the current attempt and start a fresh one (the stop is required - a
running attempt keeps serving the old content):

```sh
labctl challenge stop $0
labctl challenge start $0 --no-open --no-ssh
```

Go back to step 2 and verify that the tasks now pass.

## 7. Repeat if needed

If tasks are still failing, repeat steps 2-6 until all tasks pass.
