---
name: pull-content-source
description: "Downloads remote challenge, tutorial, course, or skill-path source files from iximiuz Labs to the local project directory via labctl. Use when fetching content, syncing from the server, downloading latest source, or refreshing local copies of markdown and assets."
argument-hint: <kind> <name>
---

Pull remote content of kind `$0` with name `$1` to the local project directory.

## Steps

1. **Detect the local folder first** by invoking the `detect-local-content-folder` skill with arguments `$0 $1`.

2. **Pull the content:**
   - If a local folder was detected at `<folder>`, pull into it:
     ```sh
     labctl content pull $0 $1 --dir <folder> --force
     ```
   - If no local folder was detected, pull with the default directory naming:
     ```sh
     labctl content pull $0 $1 --dir $0s/$1 --force
     ```

   The `--force` flag overwrites existing local files without confirmation.

3. **Verify the pull** by checking the command exit code. A non-zero exit code indicates failure (e.g., network error, content not found, or authentication issue).
