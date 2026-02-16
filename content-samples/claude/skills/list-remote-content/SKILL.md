---
name: list-remote-content
description: Lists remote content of a given kind from the iximiuz Labs server. Use when you need to discover existing content, find the remote name of a piece of content, or check if something already exists.
argument-hint: <kind>
---

List remote content of kind `$0`.

The valid kinds are: `challenge`, `tutorial`, `course`, `skill-path`.

Run the following command:

```sh
labctl content list --kind $0
```

This lists all authored content of the given kind on the remote server.

Note: Remote content names may have a random hex suffix (e.g., `docker-101-container-exec-6e812f1f`)
that differs from the local folder name (e.g., `docker-101-container-exec`). Use your best judgement
to match remote names to local folders.
