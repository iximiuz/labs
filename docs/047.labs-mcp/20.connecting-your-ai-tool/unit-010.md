---
title: Chat Assistants - Claude and ChatGPT

name: chat-assistants
kind: unit
---

Labs MCP is a standard remote MCP server (Streamable HTTP) -
if your AI tool speaks MCP, it can connect. In every client, all you need is the connector URL:

```
https://labs.iximiuz.com/mcp
```

Labs MCP has been tested with:

- ChatGPT (web & desktop)
- Claude (web & desktop)
- Claude Code, Codex, and OpenCode (CLI)

It also works with Gemini, Copilot, Cursor, Warp, Zed, and other MCP-capable clients.
This unit covers the two most popular chat assistants; for Claude Code, Codex, Cursor, and friends,
see the [next unit](/docs/labs-mcp/connecting-your-ai-tool#coding-agents-and-ides).

## Claude

*Works on claude.ai, the desktop apps, and mobile.*

1. Open **Settings → Connectors**.
2. Click **Add custom connector**.
3. Paste the connector URL (`https://labs.iximiuz.com/mcp`) and confirm.
4. Approve access on the iximiuz Labs consent screen.

## ChatGPT

*Works on chatgpt.com, the desktop apps, and mobile.*

1. Enable developer mode: **Settings → [Security and login](https://chatgpt.com/plugins#settings/Security) → Developer mode → Toggle Enabled**.
2. Navigate to **[Plugins](https://chatgpt.com/plugins)** in the sidebar and click the **Plus** button in the top right corner.
3. Enter the name (e.g., `ixlabs`) and paste the connector URL (`https://labs.iximiuz.com/mcp`) as the MCP server URL and save.
4. Sign in to iximiuz Labs when prompted and approve access.

## What happens on the first use

Searching and reading the public Labs catalog works right away, even without signing in.
The first time your assistant tries a protected action (starting a playground, running a command, etc.),
you'll be taken to a consent screen listing exactly which permissions are requested -
and you decide which ones to grant.
See [Scopes and Tools](/docs/labs-mcp/scopes-and-tools) for the details.

## Chat mode vs. work mode

Both assistants offer a plain **chat mode** and an agentic **work/cowork mode** (ChatGPT agent mode, Claude Cowork),
and Labs MCP works in either. Which one to pick depends on the task:

- **Chat mode** is enough for the [personalized tutor](/docs/labs-mcp/labs-mcp-in-practice#personalized-tutor) scenarios:
  searching the catalog, assembling a learning path, getting a hint for a running challenge.
  It works on the web, in the desktop apps, and on your phone.
- **Work/cowork mode** is what you want for [building playgrounds](/docs/labs-mcp/labs-mcp-in-practice#playground-builder)
  and [running workloads](/docs/labs-mcp/labs-mcp-in-practice#remote-infrastructure-for-agents):
  these are long, multi-step tasks (often 5-30 minutes with debugging along the way),
  and a single chat context fills up quickly once large Kubernetes and playground manifests get into it.

CLI coding agents (Claude Code, Codex, OpenCode, ...) are agentic by nature and handle all of the above.
