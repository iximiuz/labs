---
name: list-available-playgrounds
description: Lists available playgrounds from the catalog. Use when you need to find which predefined playgrounds exist (e.g., ubuntu-24-04, docker, k3s) for assigning to content.
---

List available playgrounds from the catalog.

To list official playgrounds:

```sh
labctl playground catalog
```

To filter by category, use the `--filter` flag:

```sh
labctl playground catalog --filter my-custom
labctl playground catalog --filter recent
labctl playground catalog --filter popular
labctl playground catalog --filter community
```

Without a filter, only official playgrounds are shown.
