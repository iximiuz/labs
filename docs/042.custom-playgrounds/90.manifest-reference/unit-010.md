---
title: Manifest structure

name: manifest-structure
kind: unit
---

A playground manifest is a single YAML document. At the top level:

```yaml
kind: playground          # always "playground"
name: my-playground       # unique name (also the URL slug)
base: flexbox             # the base playground (informational in dumps;
                          # on create, the base is set via --base)
title: My Playground
description: A one-paragraph summary shown on the playground card.
categories:
  - linux
markdown: |
  The long-form landing page body (markdown).
cover: https://...        # cover image URL (uploaded via the UI)
playground:
  networks: [...]         # see Networks
  machines: [...]         # see Machines
  tabs: [...]             # see Tabs
  initTasks: {...}        # see Init tasks
  initConditions: {...}   # see Init tasks
  registryAuth: user:pass # see Access control & registry
  accessControl: {...}    # see Access control & registry
```

| Field | Type | Required | Notes |
|---|---|---|---|
| `kind` | string | yes | Must be `playground`. |
| `name` | string | yes | Hostname-like identifier. On create, the platform appends a unique suffix (e.g. `my-playground` becomes `my-playground-51c9d61a`) - the full name is printed by `create` and is what all other commands expect. |
| `base` | string | create-time | Every custom playground derives from a base; list bases with `labctl playground catalog --filter base`. Only `flexbox` allows an arbitrary machine set; other bases keep their original machines (subsets and tweaks allowed, new/renamed machines rejected). |
| `title` | string | yes | Display title (5-120 characters). |
| `description` | string | no | Short summary (up to 500 characters). |
| `categories` | list of strings | no (create) | Catalog categories, e.g. `linux`, `containers`, `kubernetes`. Inherited from the base on create; required on update. |
| `markdown` | string | no | Landing-page body (up to 100,000 characters). |
| `cover` | string | no | Cover image URL; in practice managed via the UI's `/settings` page. |
| `playground` | object | yes | The technical spec - detailed in the following units. |

The two commands that consume manifests have different expectations:

- **`create -f`** accepts a partial spec: networks, tabs, categories, and resources are inherited from the base when omitted. Still required: `title`, a non-empty `accessControl` (all three lists), and for every machine - `name`, `users`, `drives`, and `network`.
- **`update -f`** expects a **complete** manifest: `networks`, `tabs`, `categories`, and `accessControl` must all be present. The reliable workflow is to dump the current manifest with `labctl playground manifest`, edit it, and submit the result.

## Working with manifests

```sh
# List available bases and your own playgrounds:
labctl playground catalog --filter base
labctl playground catalog --filter my-custom

# Create (--base is mandatory; -f is optional - without it you get a clone of the base):
labctl playground create <name> --base <base> [-f manifest.yaml]

# Dump the current (effective) manifest of a playground:
labctl playground manifest <name>

# Apply an updated manifest:
labctl playground update <name> -f manifest.yaml

# Start / stop / remove:
labctl playground start <name> [--open] [--ide] [--ssh] [-i key=value]
labctl playground stop <playground-instance-id>
labctl playground remove <name>
```

Both `create` and `update` accept `-f -` to read the manifest from stdin - convenient for heredocs and pipelines.
