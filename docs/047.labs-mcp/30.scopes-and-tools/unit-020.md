---
title: Discovery Tools (No Sign-In Required)

name: discovery-tools
kind: unit
---

Everything the [four use cases](/docs/labs-mcp/what-is-labs-mcp#four-reasons) boil down to
is plain MCP tools, grouped by product area and split into *read* (inspects, never modifies)
and *write* (changes something: starts plays, runs commands, edits your settings).
The split is exactly how the [scopes](/docs/labs-mcp/scopes-and-tools#how-authorization-works) are drawn,
so this catalog doubles as a map of what each scope actually unlocks.

We start with the open-access group: the discovery tools work anonymously,
without signing in to iximiuz Labs at all.

| Tool | What it does |
| --- | --- |
| `search_content` | Search the learning materials - challenges, tutorials, courses and their lessons, skill paths, roadmaps, and blog posts - by free text and/or facets: collection (official, independent, community, vendor), author, categories, tags, difficulty, and - when signed in - your completion status (todo, in progress, completed). The query is optional, so browsing by tags or author alone works too. |
| `list_tags` | List the tags used across the content, most used first - the vocabulary for `search_content`'s tag facet. |
| `list_authors` | List the content authors with their published content counts - the vocabulary for the author facet of `search_content` and `search_playgrounds`. |
| `get_content` | Fetch a single piece of content's metadata (when signed in, including your completion status) and, on request, its page markdown (access permitting). |
| `search_playgrounds` | Find official, community, or your own custom playgrounds by keyword, collection, author, or category. |
| `get_playground` | Inspect a playground - its machines and networks - and, on request, its full manifest. |
| `search_docs` | Search the iximiuz Labs documentation (the very docs you're reading). |
| `get_doc` | Fetch a single documentation page - the platform's own manual. |

::remark-box
Why three search tools instead of one? Content, playgrounds, and docs have different filter criteria,
and models kept confusing them when a single "omnisearch" tool covered all three.
See [How Labs MCP Works](/docs/labs-mcp/how-labs-mcp-works) for this and other design notes.
::

A few things to try:

```
› Find beginner-friendly Kubernetes challenges on iximiuz Labs.

› What's the 'Reproduce a Docker Bridge Network' challenge about - and how hard is it?

› Which official networking challenges haven't I solved yet?

› Which official Kubernetes playgrounds are there?

› Who writes the Kubernetes material on Labs? Find me more from that author.

› How does playground persistence work? Check the Labs docs.
```
