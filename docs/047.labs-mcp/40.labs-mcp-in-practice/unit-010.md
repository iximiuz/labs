---
title: Personalized Tutor

name: personalized-tutor
kind: unit
---

This section walks through the [main use cases](/docs/labs-mcp/what-is-labs-mcp) with prompts
that were actually run against Labs MCP from ChatGPT, Claude, and CLI coding agents.
Every prompt below is copy-paste ready - the only prerequisite is a
[connected AI tool](/docs/labs-mcp/connecting-your-ai-tool).

::remark-box
---
kind: tip
---
The tutor scenarios work fine in the plain **chat mode** of ChatGPT or Claude (web, desktop, or mobile).
The [playground builder](/docs/labs-mcp/labs-mcp-in-practice#playground-builder) and
[remote infrastructure](/docs/labs-mcp/labs-mcp-in-practice#remote-infrastructure-for-agents) scenarios
are longer-running and usually need an agentic mode - more on that in each section.
::

## Finding what to practice

Paired with the site-wide search, Labs MCP lets you request learning paths tailored to your current needs.
The simplest form is a filtered catalog query in plain English:

```
› Find me Linux troubleshooting scenarios to practice on iximiuz Labs. No containers or Kubernetes yet, please.
```

Behind the scenes, the assistant calls `search_content` with the right facets (categories, kinds, difficulty)
and returns a short list of matches with links.
You could achieve the same by playing with the filters in the [catalog](/challenges),
but it's handy to just say what you want.

Search becomes noticeably more useful when the request needs judgment on top of full-text matching:

```
› Find me a few Kubernetes challenges on advanced ConfigMap use cases.
```

Not every challenge that mentions ConfigMaps is *about* ConfigMap manipulation,
so the assistant has to read the candidates (`get_content`) and filter out the false positives -
something the plain catalog search cannot do.
In practice, Claude and ChatGPT both produce a solid short list for prompts like this.

::remark-box
The discovery tools work without signing in.
Sign in (via the OAuth consent screen) to also filter by your own completion status -
e.g., *"official networking challenges I haven't solved yet"*.
::

## Getting unstuck

The tutor is not limited to search. When you get stuck in a challenge, a tutorial, or a course lesson,
ask for help without even naming the material:

```
› I'm stuck with this iximiuz Labs challenge. Help me out.
```

A well-behaved assistant then works it out on its own:

1. `list_plays` - find your currently running playgrounds
2. Spot which one corresponds to a challenge
3. `get_content` and `get_play_tasks` - read the challenge text and your per-task status
4. `assist_with_content` (and, if needed, read-only `run_shell_command` diagnostics in your VM)
5. Give you a hint for the task you're stuck on - **without revealing the solution**

The spoiler-free behavior is part of the tool descriptions: the assistant is instructed to coach,
not to solve. If you still want the full solution after an honest attempt, ask for it explicitly.

## Prompts to try

```
› Build me a two-week plan to get comfortable with Kubernetes - one hour a day, hands-on only.

› Which medium-difficulty networking challenges haven't I solved yet? Start the easiest one.

› I'm on task 2 of the NAT challenge and iptables looks right to me - what am I missing?

› Explain the 'Reproduce a Docker Bridge Network' challenge to me before I start it.
```
