---
title: A playground run becomes unresponsive after being reachable for some time
name: unresponsive
kind: unit
---

Symptoms: everything worked for a while, then the terminals froze, new SSH sessions hang, the services stopped answering.

1. **Confirm the play hasn't simply run out of time.** Every play has a lifetime (the countdown in the header; `labctl playground lifetime <play-id>`) and an idle timeout,
   and an expired play is stopped (if persistent) or destroyed. `labctl playground list` and `labctl playground status <play-id>` show the current state;
   the Play Spec has `expiresIn` and `maxIdleTime`. If it's still running, read on.
2. Check what the machines are up to: `labctl playground machines <play-id>` for the states, then `labctl playground machine journal <play-id> <machine>` (or `--since -10m`)
   for the systemd journal around the time things went south - the OOM killer ("Out of memory: Killed process ..."), a full disk ("No space left on device"), a crash-looping unit, and runaway processes all leave traces there.
   `labctl playground machine console <play-id> <machine>` catches what the journal can't - a kernel panic or oops is printed to the serial console.
   If the machine still accepts commands, `labctl ssh <play-id> -m <machine> -- uptime` and `free -m`/`df -h` give the quick picture.
3. Recover: `labctl playground machine reboot <play-id> <machine>` restarts a wedged guest with its disks intact (init tasks are not re-run); a machine that shut itself down (`STOPPED`) comes back with `labctl playground machine restart`.
   If the play is persistent, `labctl playground stop` + `labctl playground restart` is the heavier hammer that recreates the whole play from its saved state.

Resource exhaustion is the usual reason for this scenario - the machines have as much RAM and disk as the manifest gives them, and a `docker build`, a database import, or a memory leak eventually hits the ceiling.
Bump `resources` in the manifest or bake heavy artifacts into a [custom rootfs image](/docs/custom-playgrounds/custom-rootfs).
