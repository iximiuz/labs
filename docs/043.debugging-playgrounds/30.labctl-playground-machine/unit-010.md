---
title: labctl playground machine
name: labctl-playground-machine
kind: unit
---

The per-machine `labctl` commands used throughout the [debugging scenarios](/docs/debugging-playgrounds/debugging-scenarios), in detail.
All of them take a **play ID** - the instance ID printed by `labctl playground start` (also visible in the play's URL and in `labctl playground list`) -
and a **machine name** from the playground manifest.

`labctl playground machine --help` lists the per-machine operations:

```text
Operate on a single machine of a playground session

Usage:
  labctl playground machine [command]

Available Commands:
  console     Print all serial console files of a machine (one per boot)
  journal     Stream a machine's systemd journal (journalctl --follow)
  reboot      Reboot a machine of a running playground session
  restart     Restart a previously stopped machine of a running playground session
  stop        Stop a machine of a running playground session
```

Run `labctl playground machine <command> --help` for the details of each subcommand. Shell completion works for both play IDs and machine names.

## Listing machines and their state

`labctl playground machines <play-id>` (note the plural) shows the machines of a play and their current state -
`STARTING`, `RUNNING`, `REBOOTING`, `STOPPING`, `STOPPED`, or one of the pre-boot states (`CREATED`, `WARMING_UP`, `WARMED_UP`):

```sh
$ labctl playground machines 68b5a8f2d1c3a4e5f6a7b8c9
MACHINE NAME  STATE
cplane-01     RUNNING
node-01       RUNNING
node-02       STOPPED
```

`labctl playground status <play-id>` gives the play-level summary - state, expiration, machines, and task counters (`-o json` / `-o yaml` for a machine-readable version) -
and `labctl playground tasks <play-id>` lists the init and helper tasks.

## Reading the boot logs

`labctl playground machine console <play-id> <machine>` prints **all** serial console files of a machine, one section per boot:

```sh
$ labctl playground machine console 68b5a8f2d1c3a4e5f6a7b8c9 node-01
===== console.log =====
[    0.000000] Linux version 6.x.y ...
[    0.000000] Command line: console=ttyS0 reboot=k panic=1 ...
...
[  OK  ] Reached target Multi-User System.

Ubuntu 24.04 LTS node-01 ttyS0

node-01 login:
```

The sections mirror the **File** dropdown of the debug console's **Boot Logs** tab: `console.log` is the current (or the latest) boot,
`console.log.0`, `console.log.1`, ... are the earlier ones, oldest first.
The command works for running and stopped plays alike, so it's the go-to tool for the post-mortem of a machine that didn't boot:

```sh
labctl playground machine console $PLAY_ID node-01 | grep -iE 'panic|failed|error' | head
```

## Streaming the systemd journal

The boot logs end where the serial console goes quiet; for everything that happens afterwards there is
`labctl playground machine journal <play-id> <machine>`, which streams the machine's systemd journal - essentially `journalctl --follow` executed inside the VM,
with the output printed in your terminal until you press `Ctrl-C`:

```text
Usage:
  labctl playground machine journal <playground-id> <machine> [flags]

Flags:
      --cursor string   Show entries after the given journal cursor
  -n, --lines int       Number of past journal lines to show before following (0 = server default)
      --since string    Show entries not older than the given time (e.g. -1h, "2021-01-01 12:00")
  -u, --unit string     Systemd unit to follow (default: the whole journal)
      --until string    Show entries not newer than the given time
```

By default, the stream starts with the last 1000 lines of the whole journal (timestamps in the `short-iso` format) and then follows new entries as they arrive.
The flags map to the corresponding `journalctl` options:

```sh
# Follow a single service - the classic "why isn't my app up?" case:
labctl playground machine journal $PLAY_ID node-01 -u docker.service

# Show more history, or only a time window:
labctl playground machine journal $PLAY_ID node-01 -n 5000
labctl playground machine journal $PLAY_ID node-01 --since -15m
labctl playground machine journal $PLAY_ID node-01 --since "2026-09-01 10:00" --until "2026-09-01 10:30"

# Continue from where a previous stream stopped (the cursor comes from `journalctl --show-cursor`):
labctl playground machine journal $PLAY_ID node-01 --cursor 's=...;i=...;b=...'
```

A few things to keep in mind:

- The command reads the journal **from the inside** of the VM (through the platform's in-VM agent, with root privileges), so the play must be **running**;
  for a stopped or failed play, the [boot logs](#reading-the-boot-logs) are what you have.
- The machine needs systemd - which is the case for all official rootfs images except the Alpine-based ones (OpenRC has no journal).
- Since the journal is streamed as it's produced, it's a great companion for init task debugging: start the stream in one terminal and re-trigger the failing step (or restart the play) in another.

## Rebooting, stopping, and restarting a single machine

In a multi-machine playground, it's often handy to bounce a single VM without touching the rest of the environment.
The three lifecycle commands all require the **play** to be running:

```sh
labctl playground machine reboot  <play-id> <machine>   # reboot a RUNNING machine (guest reboot)
labctl playground machine stop    <play-id> <machine>   # shut down a RUNNING machine
labctl playground machine restart <play-id> <machine>   # boot a STOPPED machine again
```

- `reboot` asks the guest to reboot: the machine goes through `REBOOTING` and comes back as `RUNNING`, its disks intact.
  Every boot gets a fresh `console.log` (the previous one is rotated to the next `console.log.N`), so the new boot's serial output is easy to isolate.
  A reboot is a good way to check that your changes survive a restart - services enabled with `systemctl enable`, persistent network configuration, kernel parameters, etc.
- `stop` performs a graceful shutdown of just that machine; the other machines and the play itself keep running.
  In the browser, the machine's terminal tabs show a "Machine ... is stopped" placeholder with a restart button.
- `restart` is the counterpart of `stop` - it boots the stopped machine back up (the placeholder's restart button does the same).

::remark-box
---
kind: warning
---
Note that `stop`/`restart` here are per-machine operations on a running play; the play-level `labctl playground stop` and `labctl playground restart`
(which stop and later resume the whole [persistent playground](/docs/playgrounds/persistent-playgrounds)) are different commands.
Init tasks are not re-run after machine reboots or restarts - they execute once per play instance.
::

::remark-box
---
kind: tip
---
Testing what happens to your environment when a node goes away is a legitimate use case, too:
stop a Kubernetes worker with `labctl playground machine stop` and watch the control plane react, then bring it back with `restart`.
::
