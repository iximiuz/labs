---
title: How Authorization Works

name: how-authorization-works
kind: unit
---

::highlight
Labs MCP uses standard OAuth: your AI tool never gets hold of your iximiuz Labs credentials -
it only receives a token limited to **the scopes you granted**, and you can revoke that token at any time
under **[Account](/account) → Connected apps**.
::

This section explains how that grant is requested, narrowed, and enforced.
If you're only here for the list of tools, skip straight to the [catalog](/docs/labs-mcp/scopes-and-tools#discovery-tools) -
the tools are grouped by the same scopes described below.

## Lazy authorization

No sign-in is needed to start: the discovery tools (searching and reading the public catalog and the docs) work anonymously.
Authorization kicks in the first time your AI tool calls a *protected* tool -
starting a playground, running a shell command, checking your progress, etc.
The client then sends you to the iximiuz Labs consent screen, which lists exactly which permissions are requested;
nothing is granted until you approve.

::remark-box
---
kind: tip
---
Clients that cannot complete the OAuth flow (agents in remote VMs, CI jobs, headless tools)
can use a [pre-issued access token](/docs/labs-mcp/connecting-your-ai-tool#access-tokens) instead.
Such tokens carry the scopes chosen at creation time and are enforced - and revoked - exactly like OAuth grants.
::

## The eight scopes

Every protected tool requires exactly one scope. Scopes are drawn along two axes:
the product area (`account`, `learning`, `playground`, `author`) and the access level (`read` or `write`):

| Scope | What it allows |
| --- | --- |
| `account:read` | Read your profile, progress, and daily practice |
| `account:write` | Manage your daily practice and email notification settings |
| `learning:read` | See what you're working on and coach you through it |
| `learning:write` | Start and complete challenges, tutorials, courses, and skill paths for you |
| `playground:read` | List and inspect your playgrounds and playground runs |
| `playground:write` | Start and manage playgrounds; run shell commands in VMs; expose ports; create custom playgrounds |
| `author:read` | Read your author profile |
| `author:write` | Create and update your author profile; create new content drafts |

::remark-box
The `author:*` scopes are a **pro** feature - the consent screen offers them only to accounts with pro access.
::

Regardless of the scopes granted, shell commands run only in playgrounds **you own**.

## Partial grants

The consent screen is not all-or-nothing: all requested scopes start checked, but you can uncheck any of them
before approving, and the grant covers only what you left checked.
The one rule is that a write scope implies its read sibling - unchecking `playground:read` also unchecks `playground:write`.

If your AI tool later needs a scope you didn't grant, the server responds with a challenge naming the missing scope,
and a well-behaved client sends you back to the consent screen to extend the grant - again, only with your approval.

## Grants vs. your agent's own approval prompts

Many AI tools have their own safety prompt - Claude Code, for example, asks
"Do you want to allow this tool call?" before invoking an MCP tool. These are different layers:

- **The agent's approval prompt** is client-side. It's only as reliable as the tool
  and its configuration (think `--dangerously-skip-permissions`).
- **The grant** is enforced by the Labs MCP server on every request.
  A call outside the granted scopes is rejected - no matter what the agent decided, promised, or was tricked into.

The grant is the hard boundary; the agent's prompts are a convenience on top.
Grant generously to a chat assistant you supervise, narrowly to an autonomous agent.

## Revoking access

Every connected AI tool and access token shows up under **[Account](/account) → Connected apps**,
along with the scopes it holds. Revoke it there at any time - the tokens stop working immediately,
and reconnecting requires going through the consent screen (or minting a new token) again.
