---
title: A playground run is not booting
name: not-booting
kind: unit
---

Symptoms: the "Booting Playground" screen ("Waiting for playground to become ready...") never goes away, machines linger in `STARTING`, or the play ends up on the "It's gone..." page with "The play failed to start".

1. Open the Play Debug Console (from the context menu of the starting play, or right on the failed page) and check the **Play Spec**.
   Look at `status.stateEvents` - the sequence of play states with timestamps (an event flagged with `error` marks where the platform gave up) -
   and at the **conditions**: `status.conditions` for the play as a whole and `status.machines[].conditions` for every machine.
   Conditions flip to `True` as the boot progresses (drive sources pulled, volumes created, rootfs baked, startup files written, users resolved, guest networking configured, sandbox started, ...),
   so the first condition that is still `False`/`Unknown` - together with its `message` - tells you at which stage the boot is stuck or failed.
   For example, a `MachineUsersResolved: False` points at a `users` entry that doesn't exist in the rootfs image, and a `DriveSourcePulled` that stays `False` for a long time
   means a big OCI image is still being pulled.
2. If the platform-side conditions are all `True` but the machine still doesn't become ready, the problem is inside the guest - look at the **Boot Logs** tab
   (or run `labctl playground machine console <play-id> <machine>`). The serial console shows the kernel boot, the init system's unit start-up, and where it stops:
   a kernel panic, a missing `/sbin/init`, a failed root mount, systemd dropping into emergency mode, a unit hanging with "A start job is running for ...", or an `sshd` that never starts.
   This is the typical case for [custom rootfs images](/docs/custom-playgrounds/custom-rootfs) built from a plain distro base - no init system, no `sshd`, missing system files.
3. From the terminal, `labctl playground status <play-id>` and `labctl playground machines <play-id>` show the machine states and readiness at a glance
   (`labctl playground start` itself doesn't return until the machines are `RUNNING` and ready - unless told otherwise with `--skip-wait-running`/`--skip-wait-ready`).
