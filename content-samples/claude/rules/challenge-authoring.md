# Challenge Authoring

Practical rules and pitfalls learned from authoring challenges. These complement the format reference in `challenge-format-docs.md`.

## Playground & VM Environment

- **`flexbox` playground** is the base for custom multi-VM network topologies. Define `networks:` and `machines:` with explicit `network.interfaces` and addresses.
- **`noSSH: true`** hides a machine from the student's UI but does NOT prevent inter-machine SSH between playground VMs.
- **Debugging `noSSH` machines:** To inspect examiner tasks on a `noSSH: true` machine, temporarily comment it out (`#noSSH: true`), push, and restart the challenge. This lets you `labctl ssh <playID> --machine <name> -- examinerctl task get <task>` to see task output. Remember to restore `noSSH: true` when done.
- **curl is pre-installed** on Ubuntu playground VMs — no need for a separate install task.

## Container Image Extraction

- **`crane export` writes a tar stream to stdout.** Always extract to a temp directory with `tar xf - -C "$tmpdir"` to avoid path collisions with existing files on the VM (e.g., `/var/www/html/` may already exist).

## Content Naming

- **Remote names SOMETIMES get hex suffixes.** E.g., local `linux-protect-ports/` becomes `linux-protect-ports-b76c415e` on the server. Use the `detect-local-content-folder` skill to resolve paths reliably.
- **`labctl content create` before first push.** The challenge must exist on the server before `labctl content push` will work.

## Solution Files

- **Human-facing:** `solution-01.md`, `solution-02.md`, etc. Use YAML frontmatter with `title:` and `<!--more-->` to separate summary from detail.
- **CI-facing:** `.solution-01.sh`, `.solution-02.sh`, etc. (hidden dot-prefix). Minimal scripts that apply the solution non-interactively.
- **Remove the default `solution.md`** when using numbered solution files (but challenges with just one solution should keep it).

## Testing Workflow

- **Use polling loops, not long sleeps.** When waiting for init tasks or verification, poll `labctl playground tasks <id>` in a loop with short sleeps instead of a single long `sleep`.
- **Test each solution from a fresh start.** Stop the challenge between solution tests to ensure no leftover state from previous attempts.
