---
name: start-challenge
description: "Launches an iximiuz Labs challenge playground session using labctl, provisioning a sandboxed VM environment with pre-configured tools. Runs init tasks, then provides a playground ID for SSH access and command execution. Use when starting a challenge, launching a practice problem, beginning a hands-on exercise, or testing challenge content."
argument-hint: <challenge-name>
---

Start the challenge `$0` (e.g., `docker-101-container-exec`).

Run the following command in the background — it blocks while init tasks provision the VM:

```sh
labctl challenge start $0 --no-open --no-ssh &
```

- `--no-open` — prevents opening the browser.
- `--no-ssh` — prevents starting an interactive SSH session.

Immediately use the `list-running-playgrounds` skill to find the playground ID for further operations (SSH, running commands, inspecting tasks).

If the command fails or the playground does not appear in the running list, check `labctl` output for errors (e.g., authentication, challenge name not found).
