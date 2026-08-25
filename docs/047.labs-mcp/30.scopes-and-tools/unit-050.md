---
title: Author Tools (Pro)

name: author-tools
kind: unit
---

The tools behind the [create and teach](/docs/labs-mcp/what-is-labs-mcp#four-reasons) use case.
They act on your **real author profile** and create **real content drafts**,
which is why they live behind the pro-only `author:*` scopes -
and why agents are instructed to confirm intent before creating or updating anything.

**Read** (`author:read`):

| Tool | What it does |
| --- | --- |
| `get_author_profile` | Your author profile: bio, avatar, social links, stats, and the public page URL. |
| `get_content_access` | See who can list, read, and start a piece of content you authored. |

**Write** (`author:write`):

| Tool | What it does |
| --- | --- |
| `create_author_profile` | Create your author profile - a prerequisite for creating content. |
| `update_author_profile` | Update your display name, bio, avatar, or social links. |
| `create_content` | Start a new draft tutorial, challenge, course, skill path, roadmap, or blog post. |
| `set_content_access` | Make your content public, private, or shared with specific people - e.g., to let a reviewer see a draft. |

Drafts created this way land in your usual authoring flow -
review and publish them as described in the [Content Authoring](/docs/content-authoring/how-to-publish-content) module.

```
› Do I have an author profile yet?

› Start a draft tutorial titled 'Debugging DNS Inside Containers'.

› Share my draft challenge with github user octocat.
```
