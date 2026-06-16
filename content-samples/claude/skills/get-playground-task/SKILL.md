---
name: get-playground-task
description: Gets detailed status and output of a specific examiner task on a playground. Use to debug why a task is failing.
argument-hint: <playground-id> <task-name>
---

Get detailed information about examiner task `$1` on playground `$0`.

## Inspecting a task's status and last-run output (preferred: tunnel-free)

Use the **API** path — it needs no SSH tunnel, covers **all** machines at once
(including `noSSH` ones), and includes each task's status plus the stdout/stderr
(and `hintcheck`/`failcheck` output) of its **last** execution:

```sh
labctl playground tasks $0 -o yaml
```

Grep for `$1` in that output to find the specific task. This reports the last run
only; it does **not** trigger a fresh run. Prefer this over `labctl ssh $0 --
examinerctl task get $1` — the SSH form shows a single machine and burns a tunnel
slot, whereas the YAML API form gives the same per-task output for every machine
without SSH.

## Waiting (blocking) until a task reaches a terminal state (needs SSH)

`examinerctl task wait` **does not trigger, start, or re-run anything** — there is no
`task start`/`task run`, and you cannot manually fire a task. The examiner evaluates
the task on its own; `task wait` just **blocks** until it reaches a terminal state
(pass/fail) or the timeout expires. This is the one task operation the API can't do:

```sh
labctl ssh $0 -- examinerctl task wait $1 --timeout 120s
```

Use it to block after setting up a task's preconditions — e.g. a `.solution-NN.sh`
ends with `examinerctl task wait <verify-task>` so applying the solution blocks until
that task has settled.

## Notes

- **Tasks are edge-activated, not level-triggered, and their status never regresses:**
  the examiner keeps evaluating a task until it *first* observes a success or failure
  state, then the task settles into its terminal state (`completed` `40` or `failed`
  `35`) and **never runs again**, even if the world state later changes. The status
  only ever goes up — a passed task cannot later fail — so a single `completed`
  observation is authoritative.
- **Avoid SSH churn.** Each `examinerctl ...` call opens an SSH tunnel. Use the
  tunnel-free `labctl playground tasks $0 -o yaml` for inspection and polling, and
  **never** put `labctl ssh -- examinerctl task wait` inside a backgrounded retry
  loop — orphaned ssh children exhaust the tunnel pool (see the SSH tunnel
  discipline notes in `run-playground-command`).
