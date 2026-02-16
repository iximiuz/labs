---
name: edit-remote-content
description: Pushes local content edits to the remote server. Supports pushing the entire directory or only specific changed files. Use after editing local content files to sync changes to the server.
argument-hint: <kind> <name>
---

Push local edits for content of kind `$0` with name `$1` to the remote server.

## Steps

1. **Detect the local folder first** by invoking the `detect-local-content-folder` skill with arguments `$0 $1`.

2. **Determine which files to push.** If the context of this conversation makes it clear
   which specific files were changed, push only those files:
   ```sh
   labctl content push $0 $1 --dir <folder> --force --file <file1> --file <file2>
   ```
   The `--file` paths are **relative to the content directory** (e.g., `index.md`, `__static__/image.png`).

   Otherwise, push the entire directory:
   ```sh
   labctl content push $0 $1 --dir <folder> --force
   ```
