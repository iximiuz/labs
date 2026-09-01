---
title: The debugging toolbox
name: debugging-toolbox
kind: unit
---

Sooner or later, a playground misbehaves: a machine never becomes ready, an init task hangs or fails,
a custom rootfs image doesn't boot, a service that should be listening isn't, or a run that worked fine for an hour suddenly stops responding.
The advice differs from case to case (the [Debugging Scenarios](/docs/debugging-playgrounds/debugging-scenarios) lesson walks through the typical ones),
but the tools are always the same. Here is the toolbox.

All of the tools operate on a **play** (a.k.a. **playground run**) - a running, stopped, or failed instance of a playground -
and, unless noted otherwise, they are available to the owner of the play (even if the playground itself is owned by someone else of the platform).

## Play Debug Console

The in-browser inspector of a play. How it opens depends on the play's state:

- **Booting or Running play** - open the play's context menu (the `⋮` button in the top-right corner of the playground page) and click **Open debug console**;
  clicking the small connection status dot in the header (green - online, orange - connecting, red - gone) does the same.
  The console opens as a **Debug Console** tab in the right pane, next to your terminals.
- **Stopped play** - click the bug icon in the top-right corner of the stopped playground page; the console slides in as a side panel.
- **Failed or destroyed play** - the "It's gone..." page shows the console right away, in its right half.

The console has three tabs (the refresh button in the tab bar reloads the active one):

- **Play Spec** - the full JSON representation of the play as the platform sees it:
  the `status` with the history of state transitions (`stateEvents`) and the **boot conditions** of the play and of every machine
  (`DriveSourcePulled`, `RootfsBaked`, `StartupFilesBakedIn`, `MachineUsersResolved`, `GuestNetworkingConfigured`, `SandboxStarted`, ... - each `True`, `False`, or `Unknown`,
  with a timestamp and, when something went wrong, a `message`); the effective `machines` list with the resolved drives, network interfaces, users, resources, VM backend and kernel;
  the `tasks` map with the status of every task; the expiration and idle timeouts; the resolved tabs and port forwards.
- **Boot Logs** - the **serial console** output of a machine: kernel messages, the init system's boot sequence, and the early platform bootstrap.
  Pick the machine, and if it has booted more than once, the file: `console.log` is the current (or most recent) boot,
  `console.log.0`, `console.log.1`, ... are the earlier boots, oldest first. The files are captured on the play server, outside of the VM,
  so they remain readable after the machine stops or the play fails.
- **Tasks** - the [init tasks](/docs/custom-playgrounds/init-tasks) (and helper tasks) with their statuses; clicking a task reveals its `run` script,
  machine and user, timeout, last run time and duration, exit code, and the captured **stdout/stderr** (with a short version history for re-run tasks).

::remark-box
---
kind: warning
---
The scripts and the stdout/stderr of init tasks are visible only to the **authors** of the playground
(plays started by the playground owner, or by the author of the content the playground belongs to). Everyone else sees only task names and statuses.
::

## labctl

Everything the Debug Console shows is also available from the command line, plus a few operations the UI doesn't offer.
All commands take the **play ID** - printed by `labctl playground start`, visible in the play's URL, and listed by `labctl playground list`:

```sh
labctl playground list [-a]                       # recent plays; -a includes stopped and recently terminated ones
labctl playground status <play-id>                # play-level summary: state, creation time, machines (+ readiness), task counters, page URL
labctl playground machines <play-id>              # machines and their states (STARTING, RUNNING, REBOOTING, STOPPING, STOPPED, ...)
labctl playground tasks <play-id> [--wait] [-o yaml]  # tasks and their statuses (-o yaml/json adds exit codes and, for authors, stdout/stderr)

labctl playground machine console <play-id> <machine>   # print all serial console files of a machine (one per boot)
labctl playground machine journal <play-id> <machine>   # stream the machine's systemd journal (journalctl --follow), -u <unit> to narrow down
labctl playground machine reboot  <play-id> <machine>   # reboot a running machine
labctl playground machine stop    <play-id> <machine>   # shut down a single machine of a running play
labctl playground machine restart <play-id> <machine>   # boot a stopped machine again
```

The `machine` subcommands are documented in detail in the [labctl playground machine reference](/docs/debugging-playgrounds/labctl-playground-machine).

## Inside the VM

A playground machine is a regular Linux VM, so once you can get a shell - a terminal tab in the browser or `labctl ssh <play-id> [-m <machine>]` -
the usual toolkit applies: `systemctl status`, `journalctl -u <unit>`, `ps`, `top`/`htop`/`btop`, `ss -ltnp`, `curl`, `dmesg`, `df -h`, `free -m`.

Two platform-specific things live inside every machine as well:

- **`examinerctl`** - the CLI of the in-VM agent (the *examiner*) that runs the tasks. `examinerctl task list` prints every task of the machine,
  and `examinerctl task get <name>` a single one - the `run` script, `needs`, `timeout_seconds`, the status (`running`/`completed`/`failed`), `exit_code`,
  `last_run_at`, `last_duration`, and (for authors) the `stdout`/`stderr` of the last run.
  Handy when you're already in the shell and don't want to switch to the browser.
- The **loading screen** ("Warming up playground... Init tasks completed: N/M") that covers the terminals while init tasks run can be closed with the `X` in its top-right corner -
  the machines are already up and you can use the shell while the tasks are still running. The `labctl` equivalent is `labctl playground start --skip-wait-init`
  (or simply `labctl ssh` from another terminal - it doesn't wait for the tasks).
