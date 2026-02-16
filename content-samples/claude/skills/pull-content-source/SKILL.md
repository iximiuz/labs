---
name: pull-content-source
description: Pulls remote content source files to the local project directory. Use when you need to fetch or update local copies of content from the server.
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
