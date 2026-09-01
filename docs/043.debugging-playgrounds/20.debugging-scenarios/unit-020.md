---
title: One or more init tasks are failing
name: failing-init-tasks
kind: unit
---

Symptoms: the "Warming up playground..." screen shows `Init tasks completed: N/M` and never reaches `M/M`, a task badge turns red, or the environment lacks something the task was supposed to install.

1. Look at the tasks' statuses and output. Open the **Tasks** tab of the Play Debug Console and click the failing (or the never-completing) task -
   its exit code and stdout/stderr almost always explain the problem. From the command line: `labctl playground tasks <play-id> -o yaml`
   (or `--wait --fail-fast` to follow the tasks live), and from inside the VM: `examinerctl task list` / `examinerctl task get <name>`.
2. To get a shell while the tasks are still running, **close the loading screen** with the `X` in its top-right corner - the machines are already booted.
   With `labctl`, start the play with `--skip-wait-init` (or just `labctl ssh` it from another terminal).
3. Reproduce the failing step interactively: copy the `run` script from the task details, run it as the same `user` (tasks run as `root` unless the manifest says otherwise), and iterate.
4. Fix the manifest, `labctl playground update`, and start a **new** play - init tasks execute once per play instance and are not re-run on restarts or reboots.

Common culprits: the default `timeout_seconds` of 60 (too short for `apt-get`, `pip install`, `docker pull`); a missing `needs` dependency (the task runs before another task has provided a file or started a service);
running as `root` while preparing files for `laborant` (or the other way around); relying on shell profiles that only load in login shells.

::remark-box
---
kind: warning
---
Only **authors** of the playground can see the `run` scripts and the stdout/stderr of the tasks - in the Debug Console, in `labctl playground tasks -o yaml`, and in `examinerctl` alike.
Anyone else gets task names and statuses only.
::
