---
name: push-content-source
description: Pushes local content source files to the remote server. Use when you need to publish content changes.
argument-hint: <kind> <name>
---

Push local content of kind `$0` with name `$1` to the remote server.

## Steps

1. **Detect the local folder first** by invoking the `detect-local-content-folder` skill with arguments `$0 $1`.

2. **Push the content** from the detected folder:
   ```sh
   labctl content push $0 $1 --dir <folder> --force
   ```

   If no local folder was detected, report an error - cannot push content without local source files.

The `--force` flag overwrites remote files with local ones without confirmation.
