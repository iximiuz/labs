---
name: start-challenge
description: Starts a challenge playground session. Use when you need to launch a challenge for testing or solving.
argument-hint: <challenge-name>
---

Start the challenge `$0`.

Run the following command in the background (it may block waiting for init tasks):

```sh
labctl challenge start $0 --no-open --no-ssh
```

The `--no-open` flag prevents opening the browser.
The `--no-ssh` flag prevents starting an interactive SSH session.

This command may take a long time (it waits for all init tasks to complete).
Once the challenge is started, the command will print the corresponding playground ID,
which you can use for further operations (e.g. `labctl ssh <id> -- <diagnostic>`).
