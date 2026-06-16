---
name: run-playground-command
description: Executes a command on a playground VM via SSH. Use when you need to run commands on a playground for testing, debugging, or verification.
argument-hint: <playground-id> [command]
---

Run a command on playground `$0`.

## Ad-hoc command execution

If a specific command is provided, run it directly:

```sh
labctl ssh $0 -- <command>
```

For example:

```sh
labctl ssh $0 -- curl 127.0.0.1:9000
labctl ssh $0 -- cat /etc/os-release
labctl ssh $0 -- systemctl status nginx
```

To target a specific machine in a multi-machine playground:

```sh
labctl ssh $0 --machine <machine-name> -- <command>
```

## Interactive session

If no specific command is given or multiple commands need to be run interactively,
start an interactive SSH session:

```sh
labctl ssh $0
```

## Tips

- Commands after `--` are executed on the remote VM and their output is returned.
- For long-running commands, consider running them in the background on the VM.
- If a command requires a TTY (e.g., `top`, `vim`), use an interactive session instead.

## SSH tunnel discipline (important)

`labctl ssh` borrows a tunnel slot from a small per-account pool. Misusing it
bricks **all** SSH for the session with a cryptic error:

```
labctl: Couldn't start SSH session: couldn't start tunnel: client.StartTunnel(): retry after 2562047h47m16s.
```

That `2562047h...` is an `int64` overflow meaning "no slots free" - **not** a real
wait time. It is almost always caused by **orphaned `labctl ssh` processes** left
behind by backgrounded retry loops: when the parent shell is killed, the `labctl
ssh` child keeps running and holds its slot.

- **Never** wrap `labctl ssh` in a backgrounded `for ... sleep` retry loop, and
  never launch several `labctl ssh` calls concurrently. Run ssh calls in the
  foreground, one at a time.
- To poll init/verify status, prefer `labctl playground tasks <id>` - it reads via
  the **API and needs no tunnel** (see the `list-playground-tasks` skill). Reserve
  SSH for inspecting a specific task's stdout/stderr or running diagnostics.
- Recovery when you hit the error: `pkill -9 -f 'labctl ssh'`, then retry a single
  foreground call. If it persists, `labctl challenge stop` + `start` (or restart the
  playground) to release server-side slots. Auth and API calls (`content push`,
  `playground tasks`) keep working throughout - only the tunnel is affected.
