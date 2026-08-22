---
title: Access Tokens

name: access-tokens
kind: unit
---

OAuth is the default (and recommended) way to authorize an AI tool, but it doesn't work everywhere.
Many coding agents complete the flow by redirecting the browser to `http://localhost:<port>/callback`,
where the agent itself is expected to listen.
That breaks when the agent runs on a remote VM or in a container (the browser lands on the "wrong" localhost)
and in CI or other headless environments (there may be no browser at all).
Some clients also simply don't implement OAuth correctly yet (see the [OpenCode note](/docs/labs-mcp/connecting-your-ai-tool#coding-agents-and-ides)).

For these cases, Labs MCP supports **pre-issued access tokens** (a.k.a. personal access tokens):
you mint a token once and pass it to the client as a plain `Authorization: Bearer <token>` header.
The server treats it exactly like an OAuth-minted token - it's limited to the scopes you chose at creation time
and can be revoked at any time.

## Getting a token

Go to **[Account](/account) → Connected apps → Create access token**,
choose a name, the scopes the token should get, and its lifetime, then copy the token -
it's shown only once.

::remark-box
---
kind: warning
---
Access tokens have no refresh token and expire after the chosen lifetime (1 to 365 days).
When a token expires, mint a new one.
A single account can hold at most 20 active tokens.
::

## Using a token

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
---

#claude-code

```sh
claude mcp add --transport http ixlabs https://labs.iximiuz.com/mcp \
  --header "Authorization: Bearer <token>"
```

#codex

```sh
export IXLABS_TOKEN=<token>
codex mcp add ixlabs --url https://labs.iximiuz.com/mcp --bearer-token-env-var IXLABS_TOKEN
```

Codex stores the variable name, not the token - export `IXLABS_TOKEN` wherever Codex runs.

#opencode

Add to `opencode.json`:

```json
{
  "mcp": {
    "ixlabs": {
      "type": "remote",
      "url": "https://labs.iximiuz.com/mcp",
      "enabled": true,
      "headers": {
        "Authorization": "Bearer <token>"
      }
    }
  }
}
```

#copilot

GitHub Copilot in VS Code - add to `settings.json`:

```json
{
  "mcp": {
    "servers": {
      "ixlabs": {
        "type": "http",
        "url": "https://labs.iximiuz.com/mcp",
        "headers": {
          "Authorization": "Bearer <token>"
        }
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
      "url": "https://labs.iximiuz.com/mcp",
      "headers": {
        "Authorization": "Bearer <token>"
      }
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
      "httpUrl": "https://labs.iximiuz.com/mcp",
      "headers": {
        "Authorization": "Bearer <token>"
      }
    }
  }
}
```
::

For other clients, add an `Authorization: Bearer <token>` header to the server configuration -
check your client's docs for the exact key.

::remark-box
---
kind: error
---
A token is a secret: anyone who has it can act on your behalf within its scopes.
Prefer narrow scopes (e.g., only `playground:*` for an autonomous agent) and short lifetimes,
and revoke tokens you no longer need under **[Account](/account) → Connected apps**.
::
