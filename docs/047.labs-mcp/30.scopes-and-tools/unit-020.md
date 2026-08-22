---
title: Discovery Tools (No Sign-In Required)

name: discovery-tools
kind: unit
---

Everything the [four use cases](/docs/labs-mcp/what-is-labs-mcp#four-reasons) boil down to
is plain MCP tools - 39 of them, grouped by product area and split into *read* (inspects, never modifies)
and *write* (changes something: starts plays, runs commands, edits your settings).
The split is exactly how the [scopes](/docs/labs-mcp/scopes-and-tools#how-authorization-works) are drawn,
so this catalog doubles as a map of what each scope actually unlocks.

We start with the open-access group: the discovery tools work anonymously,
without signing in to iximiuz Labs at all.

| Tool | What it does |
| --- | --- |
| `search_content` | Search the Labs catalog - challenges, tutorials, courses, skill paths, and playgrounds - by free text and optional filters. |
| `get_content` | Fetch a single piece of content's metadata and (access permitting) its full markdown body. |
| `search_docs` | Search the iximiuz Labs documentation (the very docs you're reading). |
| `get_doc` | Fetch a single documentation page - the platform's own manual. |

A few things to try:

```
› Find beginner-friendly Kubernetes challenges on iximiuz Labs.

› What's the 'Reproduce a Docker Bridge Network' challenge about - and how hard is it?

› How does playground persistence work? Check the Labs docs.
```
