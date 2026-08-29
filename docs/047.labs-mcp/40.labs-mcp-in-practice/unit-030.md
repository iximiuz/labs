---
title: Remote Infrastructure for Agents

name: remote-infrastructure-for-agents
kind: unit
---

Agents often run in a tiny container, a constrained runtime, or a full VM - but with the wrong kernel
or Linux distro. Yet you may need that agent to author a shell script that works on all mainstream distros,
deploy and test an application that only reveals its cracks on a real multi-node Kubernetes cluster,
or debug something that simply cannot run in the agent's sandbox (gVisor, Kata Containers, eBPF, ...).

iximiuz Labs is not in the agent-sandboxing business: even with Labs MCP, the agent is expected to run *outside* the playgrounds it controls.
Where playgrounds fit is providing **realistic remote infrastructure** for agents to run and test the software they work on.

::remark-box
---
kind: tip
---
This use case is for CLI coding agents (Claude Code, Codex, OpenCode, Cursor, ...) or the work/cowork mode of ChatGPT and Claude.
If the agent runs headless (CI, a remote box) and cannot complete the OAuth flow,
connect it with an [access token](/docs/labs-mcp/connecting-your-ai-tool#access-tokens)
limited to the `playground:*` scopes.
::

## Cross-distro testing

The simplest form - pair your coding agent with Labs MCP and say:

```
› This script works on Ubuntu but fails on Fedora. Test it across the mainstream Linux playgrounds and make it portable.
```

The agent starts the relevant official playgrounds (`search_playgrounds` → `start_play`), copies the script in (`write_file`),
runs it on each VM, fixes it locally, and repeats until it passes everywhere.

## Real clusters and exotic runtimes

Anything that needs a real kernel, nested virtualization, or a multi-node cluster is a good fit:

```
› Using the K3s playground, clone the https://github.com/kubernetes-sigs/agent-sandbox repo
  and deploy its OpenClaw + gVisor example. Expose OpenClaw with a public URL.
  Briefly explain the final setup and how to use it.
```

The result of this prompt is [OpenClaw on K3s with agent-sandbox + gVisor](/playgrounds/openclaw-gvisor-k3s-6297ee82) -
a 3-node K3s cluster with gVisor's `runsc`, the agent-sandbox controllers, and the example app deployed,
with the OpenClaw UI exposed as a tab.

## One environment per branch (or per agent)

Git worktrees isolate source trees, but not ports, databases, or dev servers. Local containers help to a point,
but the dev machine's capacity quickly becomes the bottleneck. With Labs MCP, different branches - or different agents -
get separate remote environments instead of competing for the same laptop:

```
› Deploy these three feature branches independently and give me a URL for each one.
```

Each branch lands in its own play, and `expose_port` returns a public HTTPS URL per deployment.

## Bug reproduction that outlives the session

Ask the agent to clone a repository, check out the exact commit, reproduce the failure, and preserve the resulting machine state:

```
› Check out commit 8ac21f, reproduce issue #423, and save the working repro as a reusable playground.
```

Such a repro persists beyond the agent session as a [custom playground](/docs/custom-playgrounds) that anyone with access
can start and reopen later - instead of being reduced to a (questionable) list of reproduction steps in an issue comment.

## Keeping an eye on the agent

Unlike black-box sandboxes, you see and keep everything the agent does:

- [SSH into](/docs/playgrounds/how-to-ssh) the VM to watch or take over mid-task
- [Expose ports](/docs/playgrounds/expose-http-ports) as public HTTPS URLs to demo what it built
- [Persist the play](/docs/playgrounds/persistent-playgrounds) to resume tomorrow

And the [grant](/docs/labs-mcp/scopes-and-tools#how-authorization-works) is the hard boundary:
an agent holding only `playground:*` scopes gets its VMs but cannot touch your learning progress, account settings, or author profile.

## Prompts to try

```
› My install script works on Ubuntu but dies on Alpine. Start both VMs and find where they diverge.

› Run the integration test suite of this repo on a 3-node Kubernetes cluster and report what fails.

› Build the Docker Compose app in this repo on a remote VM, expose the frontend, and send me the URL.
```
