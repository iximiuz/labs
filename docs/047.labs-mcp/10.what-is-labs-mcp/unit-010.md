---
title: What is Labs MCP

name: what-is-labs-mcp
kind: unit
---

::highlight
**Labs MCP** is the official iximiuz Labs MCP server.
It connects AI tools - Claude, ChatGPT, Claude Code, Codex, Cursor, and any other MCP-capable client -
to the platform, where they can:

- Coach you through hands-on learning materials
- Build custom playgrounds from plain-text prompts
- Use Linux VMs as fully-featured server-side sandboxes
- Help you author your own learning and training materials
::

## MCP in a nutshell

[Model Context Protocol](https://modelcontextprotocol.io) (MCP) is an open standard that gives AI applications
a uniform way to discover and call **tools** exposed by external systems.
In the case of a SaaS like iximiuz Labs, if a service speaks MCP, any MCP-capable AI tool can work with it -
no bespoke plugins or CLI tools required.

MCP servers come in two flavors:

- **Local** servers run on the same machine as the AI tool (distributed as executables - e.g., a binary or an `npx` command)
- **Remote** (HTTP) servers are hosted by the external system itself (there is nothing to install - you only add a single URL to your AI tool).

**[Labs MCP](/labs-mcp) is a remote MCP server** that exposes tools to work with iximiuz Labs playgrounds and browse learning materials.
It lives at:

```
https://labs.iximiuz.com/mcp
```

The same URL works for every client - from chat assistants like Claude and ChatGPT to coding agents like Claude Code, Codex, or OpenCode.
See [Connecting Your AI Tool](/docs/labs-mcp/connecting-your-ai-tool) for per-client instructions.

## Four Reasons to Use Labs MCP

While the possibilities are endless, there are four main use cases for Labs MCP:

## 1. Your AI coach

Tell your assistant what you're trying to learn, and it will search the entire Labs catalog -
tutorials, challenges, courses, skill paths - and pick the materials that match your level.
There's no one-size-fits-all approach to learning: tell it where you are and where you want to get to,
and it will assemble a personal learning path from the materials available on the platform.

And when you get stuck mid-challenge, your coach can check your task state, run diagnostics
in the same VM, and nudge you toward the next step.

```
› Build me a two-week plan to get comfortable with Kubernetes - one hour a day, hands-on only.

› I'm stuck on the NAT challenge - the container pings the host but nothing outside. Hint please.
```

::remark-box
Progress is recorded server-side - attempts, completions, and daily practice stay in sync
whether you learn in the browser or through your assistant.
::

## 2. Playground builder

[Preparing a practice environment](/docs/custom-playgrounds) can be a challenge in itself:
writing init scripts, baking rootfs images, debugging the failing boot.
It's a great way to learn by doing, but sometimes you don't really have time for it
and need to jump straight to the problem you wanted to practice in that environment.

With Labs MCP, creating a practice environment becomes a sentence: name the machines (how many, which Linux distro to use),
the software, even the failure you want to simulate - and your agent assembles the playground for you.
Liked a setup? Ask the agent to save it as a reusable [custom playground](/docs/custom-playgrounds/building-blocks)
and start it again with one call.

```
› Start the K3s playground, helm-install Argo CD, and give me the UI URL and the admin password.

› Deploy a demo microservice app on K0s and break it in three subtle ways. Don't tell me what you broke.
```

## 3. Agent sandbox

Coding agents are great at both writing and running code - but a typical agent sandbox you get is a locked-down container,
which is only good for a limited subset of workloads.
And even the most powerful of sandbox solutions usually offer just a single black-box VM per agent.

What if you want your agent to build a fully-featured Docker Compose app while _keeping an eye_ on what it's doing (browsing files, listing processes, etc.)?
Or what if you want your agent to debug a Kubernetes deployment in a real multi-node cluster?

A Labs playground gives your agent up to five real Linux VMs, connected into whatever network topology
the task requires - sized for real server-side and DevOps work, not just code snippets.

And unlike black-box cloud sandboxes, you see - and keep - everything:
[SSH in](/docs/playgrounds/how-to-ssh) any time to watch your agent work or take over mid-task,
[expose ports](/docs/playgrounds/expose-http-ports) as public HTTPS URLs to demo what it built,
and [persist the environment](/docs/playgrounds/persistent-playgrounds) to resume tomorrow.

```
› My install script works on Ubuntu but dies on Alpine. Start both VMs and find where they diverge.

› Set up a 3-tier app across five VMs - an LB, two instances of the API service, and a replicated DB.
```

## 4. Create and teach (pro)

iximiuz Labs isn't just for learners - authors publish hands-on tutorials and challenges here,
and trainers run whole courses and workshops. Labs MCP brings an assistant into that workflow, too:
draft tutorials, challenges, courses, and blog posts straight from your AI tool.
The author tools act on your real author profile, and drafts land in your usual review flow.

```
› Draft a challenge where the student fixes a crashing systemd service - write the description and tasks, I'll review.
```

::remark-box
Instructor assistance - course scaffolding, per-student environments, progress digests - is coming soon.
See [Content Authoring](/docs/content-authoring/how-to-publish-content) for more on creating content on iximiuz Labs.
::
