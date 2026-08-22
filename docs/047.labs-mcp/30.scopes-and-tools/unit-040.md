---
title: Playground Tools

name: playground-tools
kind: unit
---

The largest group - and the one that powers both the
[playground builder and the agent sandbox](/docs/labs-mcp/what-is-labs-mcp#four-reasons) use cases:
starting VMs, running commands, exposing ports, and authoring custom playgrounds.

::remark-box
A note on terminology: a **playground** is a reusable environment definition (like `docker` or `k3s`),
while a **play** is a running (or stopped-but-kept) instance of one.
Shell commands run only in plays **you own**.
::

**Read** (`playground:read`):

| Tool | What it does |
| --- | --- |
| `list_playgrounds` | Browse official, community, or your own custom playgrounds. |
| `get_playground_manifest` | Inspect a playground's machines, networks, and setup. |
| `list_plays` | List your running and stopped plays, or recent runs. |
| `get_play` | A running play's live status: machines, conditions, expiry. |
| `get_play_tasks` | Your task progress in a running challenge (spoiler-free). |
| `list_kernel_sources` | List the VM kernels you can pick for custom machines. |
| `list_rootfs_sources` | List the base OS images available for custom machines. |
| `scan_ports` | Scan a VM for listening ports without exposing them. |

**Write** (`playground:write`):

| Tool | What it does |
| --- | --- |
| `start_play` | Spin up a fresh playground VM (or VMs) with internet access. |
| `run_shell_command` | Run a shell command inside your VM. |
| `write_file` | Write a config, manifest, or script into your VM. |
| `expose_port` | Publish a port on a VM as a public HTTPS URL. |
| `expose_shell` | Share a browser terminal into your VM via a URL. |
| `persist_play` | Keep a play's state instead of destroying it at expiry. |
| `stop_play` | Stop a play, preserving its state. |
| `restart_play` | Restart a stopped play, resuming from its preserved state. |
| `destroy_play` | Permanently delete a play and its state (irreversible). |
| `set_play_title` | Rename a play. |
| `set_play_lifetime` | Extend how long a play runs before expiring. |
| `create_playground` | Create a reusable custom playground from a base and a manifest. |
| `update_playground` | Replace a custom playground's manifest. |
| `remove_playground` | Delete a custom playground. |
| `save_play_as_playground` | Snapshot a stopped play into a new reusable playground. |

A few things worth knowing about how agents use these tools in practice:

- **Long-running commands** (builds, downloads, servers) outlast a single `run_shell_command` call's timeout.
  Agents are instructed to launch them detached (`nohup ... &`) and poll the output with follow-up calls.
- **Exposing a port or a shell creates a public URL.** Agents are instructed to confirm with you
  what they're about to expose and why - but remember that the hard boundary is always
  the [grant](/docs/labs-mcp/scopes-and-tools#how-authorization-works), not the agent's manners.
- The custom-playground tools speak the same manifest language you may know from
  the [Custom Playgrounds](/docs/custom-playgrounds/building-blocks) module -
  everything an agent builds, you can inspect, tweak, and share like any other custom playground.

```
› Give me a clean Ubuntu 24.04 VM.

› Run kubectl get pods -A and tell me what's crashlooping.

› Expose port 3000 so I can open the app on my phone.

› Snapshot this setup as a playground so my study group can start from it.
```
