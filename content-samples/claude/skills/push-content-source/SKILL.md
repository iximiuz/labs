---
name: push-content-source
description: "Uploads local challenge, tutorial, course, or skill-path source files to the iximiuz Labs remote server via labctl. Overwrites the remote version with local content. Use when publishing content, deploying changes, uploading source files, or pushing all local markdown and assets to the server."
argument-hint: <kind> <name>
---

Push local content of kind `$0` with name `$1` to the remote server.

## Steps

1. **Detect the local folder first** by invoking the `detect-local-content-folder` skill with arguments `$0 $1`.

2. **Push the content** from the detected folder:
   ```sh
   labctl content push $0 $1 --dir <folder> --force
   ```

   If no local folder was detected, report an error — cannot push content without local source files.

   The `--force` flag overwrites remote files with local ones without confirmation.

3. **Verify the push** by checking the command exit code. A non-zero exit code indicates failure:
   - **Authentication error** → run `labctl auth login` to re-authenticate.
   - **Network error** → retry the push command.
   - **Missing local files** → verify the folder path from step 1 is correct.
