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

1. Enable developer mode: **Settings → Apps & Connectors → Advanced settings**.
2. Back in **Apps & Connectors**, click **Create** (custom connector).
3. Paste the connector URL (`https://labs.iximiuz.com/mcp`) as the MCP server URL and save.
4. Sign in to iximiuz Labs when prompted and approve access.

::remark-box
Custom connectors require a paid ChatGPT plan.
::

## What happens on the first use

Searching and reading the public Labs catalog works right away, even without signing in.
The first time your assistant tries a protected action (starting a playground, running a command, etc.),
you'll be taken to a consent screen listing exactly which permissions are requested -
and you decide which ones to grant.
See [Scopes and Tools](/docs/labs-mcp/scopes-and-tools) for the details.
