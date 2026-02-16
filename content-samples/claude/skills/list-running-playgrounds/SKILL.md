---
name: list-running-playgrounds
description: Lists recent playground sessions. Use to find running playground IDs or check playground status.
---

List recent playground sessions.

Run the following command:

```sh
labctl playground list
```

This shows running and recent playgrounds in a table with their IDs, names, and status.

To also include stopped and terminated playgrounds, add `--all`:

```sh
labctl playground list --all
```

To filter by content type, use the `--filter` flag:

```sh
labctl playground list --filter challenge=<name>
labctl playground list --filter tutorial=<name>
```
