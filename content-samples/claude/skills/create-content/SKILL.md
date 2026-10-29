---
name: create-content
description: Creates a new piece of content (challenge, tutorial, course, skill-path, shell-gym) on the remote server and scaffolds local source files.
argument-hint: <kind> <name>
---

Create a new piece of content of kind `$0` with name `$1`.

The valid kinds are: `challenge`, `tutorial`, `course`, `skill-path`, `shell-gym`.

Run the following command:

```sh
labctl content create $0 $1 --dir $0s/$1
```

The `--dir` flag ensures the local source files are placed in the correct project subdirectory
(e.g., `challenges/my-challenge/` for a challenge, `tutorials/my-tutorial/` for a tutorial).

Once the command completes, a new folder will be created containing:

- `index.md` - the content's main file
- `__static__/` - a directory for static files (images, etc.)
- `path/` - for `shell-gym` only: a minimal shellgym learning path (see `rules/shell-gym-authoring.md`)

After creation, read the generated `index.md` to understand the scaffold and proceed with
any further edits the user has requested.
