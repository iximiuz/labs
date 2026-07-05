---
title: Sharing and access control

name: sharing-and-access-control
kind: unit
---

A well-crafted playground is a **shareable unit of experience** - you can link it from a blog post, a README, or your resume
(see [Showcase Your Skills](/docs/getting-started/showcase-your-skills) for the motivation).
This lesson covers the finishing touches: presentation and permissions.

## Presentation

The manifest carries the playground's descriptive metadata alongside the technical spec:

```yaml
kind: playground
name: my-elk-stack
title: ELK Stack Log Observability
description: A three-VM lab with Elasticsearch, Logstash, and Kibana wired together.
categories:
  - linux
markdown: |
  ## What's inside

  This playground provisions a complete ELK stack...
playground:
  ...
```

- `title` and `description` appear on the playground card and page header.
- `markdown` is the long-form body of the playground's landing page - problem statement, diagrams, usage instructions. Good landing pages are what separate a shareable lab from "just a VM".
- `categories` places the playground in the catalog (e.g. `linux`, `containers`, `kubernetes`).

::remark-box
💡 The **cover image** can only be uploaded through the web UI - open your playground's page, add `/settings` to the URL, and use the visual editor. The same settings page also offers a rich editor for the markdown body.
::

## Access control

Who can do what with your playground is governed by three lists in the manifest:

```yaml
playground:
  accessControl:
    canList:
      - anyone
    canRead:
      - anyone
    canStart:
      - owner
      - user:<user-id>
```

- `canList` - who sees the playground in catalogs and search results.
- `canRead` - who can open its landing page.
- `canStart` - who can actually start an instance of it.

Each list holds *principals*: `owner`, `anyone`, `authenticated`, specific users (`user:<...>`), or student cohorts (`student:<training-name>` - see [Instructor-led Training](/docs/instructor-led-training/training-access-control)).
The full role vocabulary is described in [How to Control Access to Your Content](/docs/content-authoring/access-control).

Manifests submitted via `labctl` must set all three lists explicitly (each with at least one principal),
while playgrounds cloned without a manifest inherit the access settings of their base
(official bases are public, so double-check the access lists of quick clones if privacy matters). Two common recipes:

| Goal | canList | canRead | canStart |
|---|---|---|---|
| Personal work-in-progress (default) | `owner` | `owner` | `owner` |
| Public portfolio piece | `anyone` | `anyone` | `anyone` |

::remark-box
💡 Like the cover image, the point-and-click access control (RBAC) editor lives in the web UI on the playground's `/settings` page - handy for granting access to individual users without hand-editing principal strings.
::

## Sharing

Once `canRead`/`canStart` allow it, sharing a playground is as simple as sending its URL: `labs.iximiuz.com/playgrounds/<name>` (the full name, including the unique suffix appended at creation time - the URL is printed by `labctl playground create`).
Publicly listed community playgrounds appear in the [community catalog](/playgrounds?filter=community), and anyone can inspect how they are built via `labctl playground manifest <name>` - which is both a feature and a reminder not to bake secrets into manifests.

If you plan to build learning content (tutorials, challenges, courses) on top of your playgrounds, head over to [Content Authoring](/docs/content-authoring/how-to-publish-content) next.
