---
name: edit-shell-gym
description: Edit-and-test loop for a Shell Gym's learning path. Use when iterating on a Shell Gym's units and you need the running gym to pick up the changes.
argument-hint: <shell-gym-name>
---

Iterate on the Shell Gym `$0` (rules: `rules/shell-gym-authoring.md`).

## 1. Push the changes

Detect the local folder with the `detect-local-content-folder` skill (`shell-gym $0`), then keep it pushed:

```sh
labctl content push shell-gym $0 --dir <folder> --force --watch
```

`labctl` rebuilds `__static__/path.tar.gz` from the `path/` folder before every push (and on every change in `--watch` mode) - driven by the `source: __static__/path.tar.gz` startup file entry in `index.md`, exactly as for challenges - so the archive is never edited by hand.

## 2. Get the changes into a running gym - pick one

A Shell Gym session provisions the VM at start: the path archive is extracted into the startup file's `path` (`/opt/shellgym/path` by default; the same value as `shellgym.path` in `index.md`) and the `shellgym` daemon is started as a service. A push alone does not touch a running VM. Choose, per iteration, between:

### Option A - restart the whole Shell Gym (clean, heavier)

```sh
labctl shell-gym stop $0
labctl shell-gym start $0 --no-open --no-ssh
```

Pros: a pristine VM, the exact provisioning a student gets (archive, service, `/var/lib/shellgym` state all fresh); the only way to verify `index.md` changes (playground, `shellgym.version`/`port`, init tasks). Cons: a full playground start (tens of seconds to minutes); any manual setup on the VM is lost.

Use it after editing `index.md`, after adding modules/units that depend on a clean scene, and always for the final verification before publishing.

### Option B - copy the files and restart the daemon (fast, may be spoiled by leftovers)

With the session's playground ID (`labctl playground list`, or the ID printed by `shell-gym start`):

```sh
labctl cp -r <folder>/path <playground-id>:/tmp/path
labctl ssh <playground-id> -- sudo sh -c 'rm -rf /opt/shellgym/path && mv /tmp/path /opt/shellgym/path && systemctl restart shellgym'
```

(On OpenRC-based playgrounds such as Alpine, use `rc-service shellgym restart`.)

Pros: seconds, keeps the VM and whatever you set up in it. Cons: leftovers from the previous reps - files, processes, listening ports created by earlier `init:` scripts or by your own test runs - stay behind, and the daemon's saved progress in `/var/lib/shellgym/<path-id>` may mark units as already completed. If a unit behaves oddly after a hot swap, reset it in the gym UI (or wipe `/var/lib/shellgym` before the restart) - and confirm with Option A before trusting the result.

Use it for text tweaks and quick check-script fixes while iterating on a single unit.

## 3. Validate and auto-solve in the VM

The daemon binary is at `/opt/shellgym/shellgym` in the VM:

```sh
labctl ssh <playground-id> -- sudo /opt/shellgym/shellgym validate --path /opt/shellgym/path
labctl ssh <playground-id> -- sudo /opt/shellgym/shellgym solve --path /opt/shellgym/path
```

`validate` lints and renders the path; `solve` types every unit's `solve:` script into a real shell and reports PASS/FAIL per unit (`--unit <id>` for one unit). Run `solve` on a fresh VM (Option A) - it depends on the scene being clean. Note that a student session runs the daemon with `--live`, which strips `solve:` scripts from the on-disk files; sessions started by the gym's author run without it.

Follow the SSH tunnel discipline from the `run-playground-command` skill: one foreground `labctl ssh` at a time, never backgrounded retry loops.
