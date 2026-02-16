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
