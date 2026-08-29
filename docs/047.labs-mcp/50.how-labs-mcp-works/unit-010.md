---
title: Under the Hood

name: under-the-hood
kind: unit
---

You don't need to know any of this to use Labs MCP - but it helps to understand why the server behaves the way it does,
and it may come in handy if you're building an MCP server of your own.

## A stateless MCP 2.0 endpoint

Labs MCP is a **stateless remote MCP server** implementing the
[2026-07-28 revision of the MCP specification](https://modelcontextprotocol.io/specification/2026-07-28) (a.k.a. MCP 2.0).

From the caller's perspective, it's a single JSON-RPC endpoint handling `tools/call` requests:

```http
POST /mcp HTTP/1.1
Host: labs.iximiuz.com
Authorization: Bearer <token>
Content-Type: application/json
MCP-Protocol-Version: 2026-07-28
Mcp-Method: tools/call
Mcp-Name: start_play

{
  "jsonrpc": "2.0",
  "id": 1,
  "method": "tools/call",
  "params": {
    "name": "start_play",
    "arguments": {"playground": "docker"}
  }
}
```

There are no sessions to establish and no long-lived connections to keep - every request is self-contained.
For the server, that means the MCP endpoint is no different from any other endpoint served by the iximiuz Labs API server;
for you, it means every MCP-capable client works the same way, whether it's a chat assistant, a CLI agent, or a script in CI.

::remark-box
Because the endpoint is plain HTTP, you can call it with `curl` and a [pre-issued access token](/docs/labs-mcp/connecting-your-ai-tool#access-tokens) - handy for debugging a client configuration or scripting a tool call without an LLM in the loop.
::

## Same logic as the API

The MCP tools are thin adapters over the business logic that already powers the platform's REST API and web UI.
For instance, the `start_play` tool invokes the same handler as the `POST /api/plays` endpoint,
and the search tools sit on top of the same site-wide search that powers the catalog.

Two consequences worth knowing:

- **Everything an agent does is visible in the UI** - plays it started show up under [My Playgrounds](/dashboard#playgrounds/running),
  custom playgrounds it created are [regular custom playgrounds](/dashboard#playgrounds/custom), drafts it authored appear in your authoring flow.
- **The rules are the same** - plan limits, play expiry, and access control apply to MCP calls exactly as they do to the UI.

Authorization is standard [OAuth](/docs/labs-mcp/scopes-and-tools#how-authorization-works):
a token carries the scopes you granted, and the server enforces them on every request.

## Design notes: why the tools look the way they do

A working proof-of-concept of Labs MCP was built in less than a day, but the path from that PoC to something usable took weeks of debugging and refinement.
While almost all tools technically worked from day one, the initial tool set, schemas, and descriptions yielded poor results
when ChatGPT and Claude were actually pointed at the server -
none of the prompts from [Labs MCP in Practice](/docs/labs-mcp/labs-mcp-in-practice) produced meaningful output with the first version.
Several tool-level decisions came out of that iteration, and they explain some behaviors you'll notice:

**Three search tools instead of one.**
The first `search` tool worked across all materials - content, playgrounds, and documentation.
But different document types have different filter criteria, and models kept confusing them.
Splitting it into `search_content`, `search_playgrounds`, and `search_docs`, each with its own input and output schema,
made the problem go away immediately.

**Tools return URLs - and ask the model to show them.**
Early on, the search and get tools returned each document's URL, but the tool descriptions didn't ask the model to include it in its answer.
The result was bizarre: a great personalized learning path with no way to click on anything (in both ChatGPT and Claude).
The descriptions now instruct the model to link every recommended hit.

**Manifests are paged inline, not linked.**
Updating a playground requires its full manifest, which doesn't always fit into a single tool response.
Returning a manifest URL instead doesn't work either: playgrounds are private by default,
so the agent cannot fetch the URL - and changing the visibility would itself require a manifest update.
The chicken-and-egg problem was resolved by returning the manifest right in the `get_playground` response, in pages
(that's what the `offset` / `nextOffset` fields are for).

**Authors always read fresh data.**
The first version of `get_playground` lacked the cache bypass for the playground's own author -
a bypass that `GET /api/playgrounds/<name>` already had to prevent stale reads during active editing.
A model would call `update_playground`, read the playground back to verify, get the stale cached version,
and enter an infinite edit-and-debug loop. Now the author's reads always bypass the cache.

::remark-box
Problems like these are virtually impossible to catch with automated tests - they only show up when the server is used
to solve real tasks. Once spotted and fixed, they *are* covered by tests so the behavior doesn't regress.
If you notice a tool behaving oddly with your AI tool, please [report it](/support) -
that's how the tool set gets better.
::
