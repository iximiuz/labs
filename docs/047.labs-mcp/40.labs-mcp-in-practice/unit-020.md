---
title: Playground Builder

name: playground-builder
kind: unit
---

[Preparing a practice environment](/docs/custom-playgrounds) is an interesting exercise in itself,
but more often than not you don't have time for such a detour and want to jump straight to the target system.
Labs MCP turns environment preparation into a prompt.

## A multi-network topology from one sentence

```
› Create a playground with 5 VMs split into two isolated networks.
  One network should be private (no Internet access), and the other should be public.
  One of the VMs should sit in both networks and act as a router.
  Briefly describe the final setup.
```

This prompt took ChatGPT about three and a half minutes end to end, and the result -
[Dual-Network Router Lab](/playgrounds/dual-network-router-lab-21af0363) - is close to the hand-crafted environment
behind the [NAT gateway challenge](/challenges/networking-configure-nat-gateway).
The agent also wrote a description and a walkthrough, which you can find on the playground's page.

Under the hood, the agent picks a base with `search_playgrounds`, studies its manifest with `get_playground`,
and calls `create_playground` with a [multi-network manifest](/docs/custom-playgrounds/multi-network-playgrounds) -
the same manifest language you would write by hand.

## Deploying a demo app

Another frequent need is a demo application to poke at while learning a technology -
Istio's Bookinfo, Grafana's QuickPizza, Jaeger's HotROD, etc.:

```
› Deploy the https://github.com/jaegertracing/jaeger HotROD app to a k3s playground and write a brief walkthrough.
```

Claude (in cowork mode, launched from the web interface) spent about ten minutes on this and delivered a running K3s playground
with a few microservices deployed and Jaeger collecting and visualizing traces.
The flow is: `start_play` (the official `k3s` playground), a series of `write_file` and `run_shell_command` calls
to apply manifests and wait for the rollout, and `expose_port` to hand you the UI URLs.

## Saving the result as a reusable playground

A running play expires; a custom playground does not. When you like what the agent built, ask it to persist the result:

```
› Stop the playground run and save the snapshot as a reusable custom playground.
  Update the playground manifest to expose the demo app and Jaeger as UI tabs.
  Place the walkthrough into the playground's description.
```

That's `stop_play` → `save_play_as_playground` → `update_playground` (adding [UI tabs](/docs/custom-playgrounds/ui-tabs)
and the `markdown` description).
Here is the playground produced by the above follow-up: [HotROD + Jaeger on K3s](/playgrounds/hotrod-jaeger-k3s-86f66967).
Like the dual-network one, it has a helpful walkthrough on its front page.

## Larger, longer tasks

The HotROD app is already non-trivial, but the same approach scales to much bigger targets:

```
› Deploy https://github.com/open-telemetry/opentelemetry-demo to a k3s playground and write a brief walkthrough.
```

The OpenTelemetry demo needs over 15 GB of container images, and it takes an agent roughly 30 minutes
to set everything up end to end - including some debugging along the way.
Both Claude and ChatGPT managed to produce a working setup, unattended.
Long-running tasks like this one are what Labs MCP is designed for: the agent launches heavy steps detached in the VM
and polls their progress with quick follow-up calls (see [Playground Tools](/docs/labs-mcp/scopes-and-tools#playground-tools)).

## Which AI tool mode to use

Playground building is an agentic, multi-step job. Use:

- The **work/cowork (agent) mode** of ChatGPT or Claude - via the web interface or the desktop app
- A **CLI coding agent** - Claude Code, Codex, OpenCode, and the like - connected as described in
  [Coding Agents and IDEs](/docs/labs-mcp/connecting-your-ai-tool#coding-agents-and-ides)

Plain chat mode usually won't cut it: a single context window fills up quickly when the model has to keep
large Kubernetes and playground manifests in it while debugging a rollout.

::remark-box
---
kind: tip
---
Everything an agent builds is a regular [custom playground](/docs/custom-playgrounds/building-blocks):
you can inspect its manifest, tweak it by hand, and share it (or ask the agent to do so via `set_playground_access`).
::

## Prompts to try

```
› Start the K3s playground, helm-install Argo CD, and give me the UI URL and the admin password.

› Deploy a demo microservice app on K0s and break it in three subtle ways. Don't tell me what you broke.

› Set up a 3-tier app across five VMs - an LB, two instances of the API service, and a replicated DB.

› Save this setup as a private playground named 'my-argocd-lab' and share it with github user octocat.
```
