---
name: detect-local-content-folder
description: "Locates the local directory path for a challenge, tutorial, course, or skill-path by name. Resolves exact and hex-suffixed folder names. Use when finding a folder path, locating a content directory, or resolving where local content files are stored before pull or push operations."
argument-hint: <kind> <name>
user-invocable: false
allowed-tools: Glob
---

Find the local folder for content of kind `$0` with name `$1`.

## Rules

1. The local folder is always inside the **pluralized kind** subdirectory of the project root:
   - `challenge` → `challenges/`
   - `tutorial` → `tutorials/`
   - `course` → `courses/`
   - `skill-path` → `skill-paths/`

2. The folder either:
   - Matches the name **exactly**: `<kind-plural>/$1/`
   - Or matches the pattern `<kind-plural>/$1-<short-hex-suffix>/` (e.g., `challenges/docker-101-6e812f1f/`)

## Steps

1. Use Glob to search for `$0s/$1/index.md` (exact match).
   Example: `Glob('challenges/docker-101/index.md')`
2. If not found, use Glob to search for `$0s/$1-*/index.md` (suffix match).
   Example: `Glob('challenges/docker-101-*/index.md')`
3. If a match is found, return the folder path (without the `index.md` part).
4. If no match is found, report that no local folder was detected.
