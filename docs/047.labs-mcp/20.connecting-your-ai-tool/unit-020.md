---
title: Coding Agents and IDEs

name: coding-agents-and-ides
kind: unit
---

All coding agents and IDEs point at the same connector URL - `https://labs.iximiuz.com/mcp` -
they differ only in where the configuration goes.
Below are the snippets for the most popular ones (using `ixlabs` as the server name, but you can pick any).

::remark-box
---
kind: tip
---
Running the agent inside a remote VM, a container, or CI?
The OAuth flow may not be able to complete there - see the [next unit](/docs/labs-mcp/connecting-your-ai-tool#access-tokens)
for the access-token alternative.
::

::tabbed
---
tabs:
  - name: claude-code
    title: Claude Code
  - name: codex
    title: Codex
  - name: opencode
    title: OpenCode
  - name: copilot
    title: Copilot
  - name: cursor
    title: Cursor
  - name: gemini
    title: Gemini
  - name: antigravity
    title: Antigravity
  - name: devin
    title: Devin
  - name: warp
    title: Warp
  - name: zed
    title: Zed
---

#claude-code

```sh
claude mcp add --transport http ixlabs https://labs.iximiuz.com/mcp
```

Then run `/mcp` inside Claude Code and choose **Authenticate**.

#codex

```sh
codex mcp add ixlabs --url https://labs.iximiuz.com/mcp
```

#opencode

```sh
opencode mcp add ixlabs --url https://labs.iximiuz.com/mcp
```

::remark-box
---
kind: warning
---
**Known issue:** OpenCode's OAuth support doesn't work with Labs MCP yet.
`opencode mcp auth` reports "Authentication successful!" without ever opening a browser,
and protected tool calls then fail with an authorization error.
The cause is on the OpenCode side: it starts the OAuth flow only if the very first `initialize` request
is rejected with a `401`, but Labs MCP (like any lazy-auth MCP server) accepts it anonymously,
and OpenCode never looks at the protected-resource metadata the server advertises.
Until this is fixed upstream, use an [access token](/docs/labs-mcp/connecting-your-ai-tool#access-tokens) instead.
::

#copilot

GitHub Copilot in VS Code - add to `settings.json`:

```json
{
  "mcp": {
    "servers": {
      "ixlabs": {
        "type": "http",
        "url": "https://labs.iximiuz.com/mcp"
      }
    }
  }
}
```

#cursor

Add to `~/.cursor/mcp.json`:

```json
{
  "mcpServers": {
    "ixlabs": {
      "url": "https://labs.iximiuz.com/mcp"
    }
  }
}
```

#gemini

Gemini CLI - add to `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "ixlabs": {
      "httpUrl": "https://labs.iximiuz.com/mcp"
    }
  }
}
```

#antigravity

Add to `mcp_config.json`:

```json
{
  "mcpServers": {
    "ixlabs": {
      "serverUrl": "https://labs.iximiuz.com/mcp"
    }
  }
}
```

#devin

Add to the MCP configuration:

```json
{
  "mcpServers": {
    "ixlabs": {
      "transport": "HTTP",
      "url": "https://labs.iximiuz.com/mcp"
    }
  }
}
```

#warp

Add to the MCP configuration:

```json
{
  "ixlabs": {
    "serverUrl": "https://labs.iximiuz.com/mcp"
  }
}
```

#zed

Add to `settings.json`:

```json
{
  "context_servers": {
    "ixlabs": {
      "url": "https://labs.iximiuz.com/mcp"
    }
  }
}
```
::

On the first protected tool call, the agent will send you through the OAuth flow -
a browser page opens with the iximiuz Labs consent screen, where you approve (or narrow) the requested permissions.
You can revoke the access at any time under **[Account](/account) → Connected apps**.

::remark-box
---
kind: tip
---
Running an agent with broad autonomy? Consider granting only the `playground:*` scopes -
the agent gets its VMs but cannot touch your learning progress, account settings, or author profile.
More on this in [Scopes and Tools](/docs/labs-mcp/scopes-and-tools).
::
