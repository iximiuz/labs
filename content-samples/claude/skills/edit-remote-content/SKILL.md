---
name: edit-remote-content
description: "Pushes local content edits for challenges, tutorials, courses, or skill-paths to the iximiuz Labs remote server via labctl. Supports uploading the entire directory or only specific changed files. Use when syncing edits, uploading changes, deploying content updates, or publishing modified markdown and assets to the server."
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

3. **Verify the push** by checking the command exit code. A non-zero exit code indicates failure (e.g., network error, authentication issue, or missing local files).
