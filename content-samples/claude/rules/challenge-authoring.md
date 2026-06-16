# Challenge Authoring

Practical rules and pitfalls learned from authoring challenges. These complement the format reference in `challenge-format-docs.md`.

## Style Guides

Use simple, clear, and concise "International English". Avoid fancy words and overly complex sentences. Write each challenge as a natural story, tailored for the corresponding problem statement in the index.md file. Using structured prose is preferred over bullet points.

The problem statement in the index.md file should focus on the challenge itself, not the solution.
Hinting at the solution is fine, especially in (collapsed by default) hint boxes.
But NEVER include the exact commands to copy/paste or generic versions of such commands that only require some parameters to be filled in.

Always try to connect the dots between the challenge and the real-world scenarios it prepares the student for and/or particular skills it helps develop.

The challenge's title should start with a verb in the imperative mood. The challenge's name (i.e., the folder name and the URL slug) should look like a simplified title (e.g., `write-tcp-echo-server` for `Write a TCP Echo Server From Scratch`).

Challenge descriptions should be concrete and factual. It should both outline the problem to be solved and the value the exercise provides to the learner.

Per-machine welcome messages should be concise and factual. They shouldn't restate the problem. Instead, they should describe the machine and its purpose, as well as highlighting its key components (if relevant for the challenge).

## Task Conventions

- **Single-machine challenges: omit the `machine:` attribute on tasks.** The `machine:` field only exists to disambiguate which VM a task runs on in multi-machine topologies. When the playground has exactly one machine, every task implicitly targets it, so spelling out `machine: <the-only-machine>` on each task is redundant noise. Add `machine:` only once a challenge has two or more machines.
- **Don't specify `timeout_seconds` unless you have a concrete reason.** The default task timeout is **60s**. If a task is expected to finish in under a minute and does not need a tighter bound, leave `timeout_seconds` off entirely. There are exactly two reasons to set it explicitly:
  - **Quick turnaround** — the task does a fast operation and you want it to fail fast (e.g., a snappy check or a probe that should never hang), so you set a value *lower* than 60s.
  - **Long task** — the operation genuinely needs more than 60s (e.g., a large image pull, a `kubeadm` bring-up, a multi-step build), so you set a value *higher* than the default.

  If neither applies, omitting `timeout_seconds` keeps the frontmatter clean and signals "ordinary, sub-minute task".

## Setup Artifacts: Never Inline, Always Fetch from `__static__`

- **NEVER inline a mini-program, `Dockerfile`, config, or any script-ish artifact longer than ~a dozen lines into an `index.md` task `run:` block.** Embedding a server, checker, or `Dockerfile` as a heredoc inside a YAML block scalar is brittle and a recurring source of bugs: YAML re-indentation silently mangles Python/Makefile indentation, quoting and `$(...)`/backticks/`$VAR` need fragile escaping, and the artifact becomes impossible to review, lint, or test in isolation. Store it as a real file under the challenge's `__static__/` folder and `wget` it in an init task instead. Short snippets (a `mkdir`, a few `echo`s, a one-liner check) are fine to keep inline.
- **How `__static__` serving works.** Every file in a published content's `__static__/` folder is served at the GLOBAL URL `https://labs.iximiuz.com/__static__/<filename>`. It only becomes available *after* `labctl content push`, and it is cached — always pass `wget --no-cache` and append a cache-buster `?t=$(date +%s)` so a re-pushed artifact is picked up on the next challenge start. `wget` is available on the playground VMs.

### Single file

Put e.g. `telemetry_server.py` in `__static__/`, then fetch it in an init task:

```yaml
  init_fetch_server:
    init: true
    run: |
      mkdir -p /opt/iximiuz-labs
      wget --no-cache -q "https://labs.iximiuz.com/__static__/telemetry_server.py?t=$(date +%s)" \
        -O /opt/iximiuz-labs/telemetry_server.py
```

### Multiple related files → tar-archive with a Makefile

When the setup is a small project (e.g. `Dockerfile` + `main.go` + `go.mod`, or a server plus its checker), keep the sources in a sibling subfolder (conventionally `app/`) and add a `Makefile` that tars them into `__static__/<name>.tar.gz`. This is the established repo pattern:

```makefile
CUR_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

.PHONY: build clean

build: __static__/app.tar.gz

__static__/app.tar.gz: $(shell find app -type f)
	mkdir -p ${CUR_DIR}/__static__
	tar -czf ${CUR_DIR}/__static__/app.tar.gz -C ${CUR_DIR}/app .

clean:
	rm -f ${CUR_DIR}/__static__/app.tar.gz
```

Run `make` before pushing — the generated `__static__/<name>.tar.gz` is the artifact that ships. Fetch and unpack it in an init task:

```yaml
  init_fetch_app:
    init: true
    user: laborant
    run: |
      mkdir -p ~/app && cd ~/app
      wget --no-cache -q "https://labs.iximiuz.com/__static__/app.tar.gz?t=$(date +%s)" -O app.tar.gz
      tar -xzf app.tar.gz
      rm app.tar.gz
```

- **Editing an artifact later** means re-running `make` (for tarballs) and re-pushing the `__static__/` file; the cache-buster ensures the next challenge start fetches the new version.
- **`.labctlignore`** any human-facing files that live next to the sources but must not be pushed as content (e.g. `app/README.md`), or `labctl content push` 400s with `Content kind challenge does not support files with kind undefined`.

## User Input Tasks

- **Use `x(.input)` to read user-submitted values, not a `destination:` file.** The `destination:` field writes the input to a file on disk; `x(.input)` injects it directly into the task script at the point of use. Prefer `x(.input)` — it is cleaner and avoids disk writes. The `destination:` field is deprecated and exists only for backwards compatibility.
- **In `run:`, assign `x(.input)` to a shell variable first**, then work with the variable. Example:

  ```yaml
    verify_something:
      run: |
        PROVIDED=$(echo "x(.input)" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')
        if [ -z "${PROVIDED}" ]; then
          echo "No answer provided."
          exit 1
        fi
        ...
  ```

- **In `.solution.sh`, submit answers with `examinerctl task input`**, then wait for the task to pass:

  ```sh
  echo -n "yes" | examinerctl task input verify_something
  examinerctl task wait verify_something --timeout 30s
  ```

## Sharing Data Between Tasks: Prefer `stdout` Over a File

- **Pass values between tasks via `x(.needs.<task>.stdout)`, not by writing to a shared file on disk.** When one task produces a value another task consumes (a generated secret, a computed digest, a discovered IP/port, a token), have the producer task simply print it to stdout and have the consumer reference it through `env:` + `x(.needs.<producer>.stdout)`. This is the default; reach for a file only when the artifact is genuinely large (e.g. a multi-KB cert bundle, a tarball, a generated dataset) or must live at a specific path for a long-running process to read.
- **Why stdout is better for small values.** A file is visible to anyone with shell access to that machine — for a *secret* shared between a server and its verifier, an on-disk copy is a leak waiting to happen, especially on the student-facing machine. The `stdout` channel is internal to the examiner: the student never sees init-task stdout, so the value stays out of their reach. It also keeps the data flow explicit in the `needs:`/`env:` graph instead of relying on an implicit file convention, and avoids file-permission/ownership pitfalls across machines and users.
- **Prefer binding `x(...)` in the `env:` block over using it inline in `run:`.** It works in either place. The benefit of binding it once in `env:` (e.g. `- SECRET=x(.needs.init_gen_secret.stdout)`) is that the value is then available as `$SECRET` across all of the task's scripts — `run:`, `hintcheck:`, and `failcheck:` — instead of being re-expanded in each one.
- **Producer task: emit exactly the value, no trailing noise.** Print just the value (e.g. `openssl rand -hex 32`, or `sha256sum file | awk '{print $1}'`). Because the captured stdout may pick up a trailing newline, normalize on the consuming side — `tr -d '[:space:]'` for shell comparisons, or `.strip()` in Python — so both sides agree byte-for-byte (a mismatched HMAC key from a stray `\n` is a maddening bug).
- **Cross-machine flow:** a regular (verify) task may `needs:` an init task on *another* machine and read its `stdout` — declare it explicitly in `needs:`. (Only `init → init` cross-machine `needs:` is rejected by server validation.) Example: `init_gen_secret` runs on the `noSSH` server machine, a long-running server reads the secret via `systemd-run --setenv=...`, and the verifier on the dev machine pulls the *same* secret via `x(.needs.init_gen_secret.stdout)` — no copy of the secret ever touches disk on either box.

### Secret Generation

- **Prefer `openssl rand -hex <n>` for generating secrets/tokens.** It is concise, emits only hex (no whitespace, no `+`/`/`/`=` that need quoting when passed through `--setenv`, env vars, or shell), and is available on the playground VMs. Example: `openssl rand -hex 32`. Fall back to `head -c <n> /dev/urandom | od -An -tx1 | tr -d ' \n'` only if `openssl` is genuinely unavailable on the target image. Avoid `base64` for secrets that flow through env/`--setenv`/comparisons — its `=` padding and `+`/`/` chars are quoting hazards.

## Playground & VM Environment

- **`flexbox` playground** is the base for custom multi-VM network topologies. Define `networks:` and `machines:` with explicit `network.interfaces` and addresses.
- **`noSSH: true`** hides a machine from the student's UI but does NOT prevent inter-machine SSH between playground VMs.
- **Debugging `noSSH` machines:** To inspect examiner *task status and last-run output* on a `noSSH: true` machine, just use `labctl playground tasks <playID> -o yaml` — it is served via the API and covers all machines, including hidden ones, so you do **not** need to comment out `noSSH: true`. Only temporarily comment it out (`#noSSH: true`, then push + restart) when you need to actually `labctl ssh` into the machine to run live diagnostic commands. Remember to restore `noSSH: true` when done.
- **curl is pre-installed** on Ubuntu playground VMs - no need for a separate install task.

## Container Image Extraction

- **`crane export` writes a tar stream to stdout.** Always extract to a temp directory with `tar xf - -C "$tmpdir"` to avoid path collisions with existing files on the VM (e.g., `/var/www/html/` may already exist).

## Content Naming

- **Remote names SOMETIMES get hex suffixes.** E.g., local `linux-protect-ports/` becomes `linux-protect-ports-b76c415e` on the server. Use the `detect-local-content-folder` skill to resolve paths reliably.
- **`labctl content create` before first push.** The challenge must exist on the server before `labctl content push` will work.

## Solution Files

- **Human-facing:** `solution-01.md`, `solution-02.md`, etc. Use YAML frontmatter with `title:` and `<!--more-->` to separate summary from detail.
- **CI-facing:** `.solution-01.sh`, `.solution-02.sh`, etc. (hidden dot-prefix). Minimal scripts that apply the solution non-interactively.
- **Remove the default `solution.md`** when using numbered solution files (but challenges with just one solution should keep it).
- **Never start a solution with the "The key to this challenge is" phrase.** It's redundant and annoying. Write each solution as a natural story, tailored for the corresponding problem statement in the index.md file.

## Hints

- **Use the `hint-box` component** to show collapsed by default clues on how to solve the challenge.
- NEVER INCLUDE THE EXACT SOLUTION IN THE HINT BOX (neither commands to copy/paste nor generic versions of such commands that only require some parameters to be filled in)

### Hint summary format

Use one of two forms depending on complexity:

```yaml
# Simple numbered hints when the challenge has a small linear sequence:
:summary: Hint 1
:summary: Hint 2

# Descriptive label when the hint is standalone or the subject matters more than the number:
:summary: "Hint: What this hint is about"
```

### Dynamic (file-based) hints for verification tasks

Static hint boxes appear regardless of what went wrong. Dynamic hints are generated by the
`run:` script based on what it actually observed, so the message is relevant to the specific
failure. Use them for any task with more than one plausible failure mode.

**Pattern:** the `run:` script writes a context-specific message to a temp file before
`exit 1`; the `hintcheck:` script reads and prints that file, then cleans it up.

```yaml
tasks:
  verify_config_file:
    machine: server-01
    run: |
      rm -f /tmp/verify_config_file_hint.txt

      if [ ! -f /etc/myapp/config.toml ]; then
        echo "The config file is expected at /etc/myapp/config.toml." | tee /tmp/verify_config_file_hint.txt
        exit 1
      fi

      if ! grep -q '^\[server\]' /etc/myapp/config.toml; then
        echo "The file exists but is missing a [server] section. Check the expected format with 'myapp --print-default-config'." | tee /tmp/verify_config_file_hint.txt
        exit 1
      fi

      PORT=$(grep -E '^port\s*=' /etc/myapp/config.toml | awk -F= '{print $2}' | tr -d ' ')
      if [ "${PORT}" != "8080" ]; then
        echo "port= is set to '${PORT}' but the expected value is 8080." | tee /tmp/verify_config_file_hint.txt
        exit 1
      fi

      echo "Config file is correct."

    hintcheck: |
      if [ -f /tmp/verify_config_file_hint.txt ]; then
        cat /tmp/verify_config_file_hint.txt
        rm -f /tmp/verify_config_file_hint.txt
      fi
```

Rules:
- `hintcheck:` **must always exit 0**, regardless of what it outputs. It is informational only.
- `failcheck:` exits non-zero to fail a task that `run:` passed. Use it when the main check
  is expensive and a secondary invariant must also hold. It follows the same file pattern.
- Clean up the hint file at the top of `run:` (`rm -f`) so a stale file from a previous run
  does not mislead the user after a fix.
- Hint messages should point to what is wrong or where to look — not how to fix it. Avoid
  repeating the exact commands that solve the challenge.

## Testing Workflow

- **NEVER validate challenge artifacts locally. Always use a remote playground via `labctl`.**
  - This includes (non-exhaustive): running scripts embedded in `index.md` (Python, shell, Go, etc.) on the host;
    invoking helpers like `systemd-socket-activate`, `docker`, `crane`, `curl`, `nft`, `iptables`, `ip netns`, `qemu-*`
    against locally-extracted binaries or files; pasting heredoc bodies into local files to "syntax-check" them
    with `python3 -m py_compile`, `bash -n`, `node --check`, etc.; spinning up local containers or VMs to
    reproduce the challenge environment.
  - **Why:** the host machine is not the playground. It has a different distro, kernel, package set, user, network,
    and pre-installed tools. A local pass tells you nothing about whether the challenge works in the actual VM,
    and a local fail can be a host-only artifact that wastes time. Local execution can also leak state into the
    author's environment.
  - **How to apply:** the only acceptable validation path is `start-challenge` (or `start-playground` +
    `push-content-source`) followed by `list-playground-tasks` / `get-playground-task` /
    `run-playground-command`. Syntax-level sanity (YAML parses, frontmatter keys present) on the markdown file
    itself is fine; executing any code that the challenge ships is not.
- **NEVER use `labctl playground stop` — terminate playgrounds with `labctl playground destroy <playID>`.** `playground stop` does NOT terminate the playground: it suspends it, preserving its state for a later resume, so the session keeps lingering around. Every ephemeral playground started for authoring/testing must be destroyed when done. For a challenge attempt, the right command is `labctl challenge stop <name>` (it tears down the attempt's playground too); only if it fails, force the teardown with `labctl playground destroy <playID>`. (The `stop-playground` skill already does the right thing — it runs `destroy` under the hood.)
- **NEVER run `labctl auth login` or `labctl auth logout` (or otherwise touch the auth session).** You are only ever allowed to use the *already-authenticated* `labctl` session you inherit. Logging out **invalidates that session server-side** — so NEVER do it. If something seems to need a different identity (e.g. testing as a free vs. premium user), that is the user's call — stop and ask; do not log in/out yourself.
- **Tasks are edge-activated (NOT level-triggered) and their status NEVER regresses.** The examiner keeps evaluating a task until it *first* observes a success or failure state; at that moment the task settles into its terminal state — `completed` (`40`) or `failed` (`35`) — and **never runs again**, even if the world state later changes and the original passing/failing condition no longer holds. The numerical status only ever increases; it cannot flip back to `running`/`blocked` or to the opposite terminal state. So a single observation of `completed` is authoritative, and a task that has already passed cannot later fail.
- **`examinerctl task wait <task> --timeout <dur>` only WAITS; it does not trigger, start, or re-run anything** (there is no `task start`/`task run` — you cannot manually fire a task). The examiner evaluates the task on its own; `task wait` just blocks until the task reaches a terminal state (or the timeout). A `.solution-NN.sh` ends each step with `examinerctl task wait <verify-task>` so applying the solution blocks until that task has settled.
- **To validate a `.solution*.sh`, ALWAYS use the CI helper `tests/challenges/main.go` (with `--skip-auth`).** This is the canonical solve path — it runs the exact CI chunk-execution semantics, so a pass here is what CI will see. It also captures rich per-solution artifacts (see below) that make debugging far easier than ad-hoc `labctl ssh`. The `solve-challenge` skill wraps this helper. **`--skip-auth` is mandatory** — without it the tester calls `labctl auth login` with a `session:token` pair and will log you out / replace your session (exactly the prohibition above). With `--skip-auth` it reuses the current session and treats it as premium-capable (premium challenges are not skipped). Test each solution from a fresh start (the helper stops the prior attempt between solutions automatically).
- **Debug a challenge by running the CI helper and inspecting it live + after.** The helper starts its own challenge playground and leaves it running for the whole attempt, so the two debugging signals are:
  - **While the helper runs, point ordinary `labctl` commands at that playground in parallel.** Find the ID with `labctl playground list --filter challenge=<name>` (or `list-running-playgrounds`), then watch/poke it: `labctl playground tasks <id> -o yaml`, `labctl ssh <id> [--machine <m>] -- <diagnostic>`, etc.
  - **Analyze the helper's artifacts — this is the primary debugging signal.** The helper writes a per-solution artifacts directory (the exact absolute path is printed at the start of each solution). The files are written and **appended to dynamically as the attempt proceeds** — tail them live, don't wait for the run to finish. The directory contains:
    - `chunk-NN[.retry-MM].{stdout,stderr}.log` — per-chunk SSH session output (`NN` = 0-based chunk index, `MM` = retry attempt). This is where a solution chunk's progress and errors (if any) show up.
    - `tasks-NNNN.txt` + `tasks-final.txt` — periodic `labctl playground tasks -o yaml` snapshots (every 15s; `tasks-final.txt` is taken right before exit) — shows which task never reached `40` and its last-run output.
    - `journal-<machine>.examiner[.err].log` — streamed examiner journal per machine.
- **Use polling loops, not long sleeps.** When waiting for init tasks or verification, poll `labctl playground tasks <id>` in a loop with short sleeps instead of a single long `sleep`. This command reads status via the **API and needs no SSH tunnel**, so it's safe to loop on. Add `-o json` for machine-readable status codes (`status: 40` == completed). A VM reboot in these playgrounds comes back in **a few seconds**; cap any post-reboot wait at ~20s — if the box isn't back by then, something is wrong (don't schedule multi-minute waits).
- **SSH tunnel discipline.** `labctl ssh` borrows a slot from a small per-account tunnel pool. NEVER background a `labctl ssh` retry loop and never fire several `labctl ssh` calls concurrently: when the parent shell is killed the `labctl ssh` child is orphaned and keeps holding its slot, and once the pool is exhausted **every** later ssh fails with the cryptic `client.StartTunnel(): retry after 2562047h47m16s` (an overflow, not a real wait). Run ssh foreground, one at a time; poll status via `labctl playground tasks` (API), and reserve ssh for a single `examinerctl task wait <task>` or a diagnostic. Recovery: `pkill -9 -f 'labctl ssh'`, then `labctl challenge stop`+`start` if it persists.
- **To INSPECT a task's last-run output, prefer the tunnel-free `labctl playground tasks <id> -o yaml` over `labctl ssh -- examinerctl task get <task>`.** The YAML form is served via the API (no SSH tunnel), covers **all** machines at once (including `noSSH` ones — so you no longer need to comment out `noSSH: true` just to read a task's output), and includes each task's status plus its last-run stdout/stderr. Reserve `examinerctl` over SSH for the one thing the API can't do: **blocking** until a task reaches its terminal state (`examinerctl task wait`).
- **Apply a single-VM solution in one shot:** `{ echo 'set -exuo pipefail'; cat .solution-NN.sh; } | labctl ssh <id> -- bash -s`. Do NOT use `$(cat file)` inside a quoted `<<'CHUNK'` heredoc - it is sent literally and runs on the VM, where the file does not exist.
- **Test each solution from a fresh start.** Stop the challenge between solution tests to ensure no leftover state from previous attempts.

## Reboot-Based Challenges (multi-machine, `sudo reboot`)

A challenge that asks the student to `sudo reboot` a machine needs a **second machine that survives the reboot** to verify persistence. This is the established `flexbox` two-machine pattern (e.g. `docker-101-container-restart-on-host-reboot`, `podman-101-container-restart-on-host-reboot`, `systemd-socket-activate-listen-stream-*`): a student-facing `server-01` (or `docker-01`, etc.) that reboots, plus a hidden `verifier` (`noSSH: true`) that SSHes into `server-01` over *inter-machine* SSH to record the boot id beforehand and re-check state afterward.

Two hard constraints shape how the **solution** (`.solution*.sh`) must be written:

- **A `noSSH: true` machine cannot be ANY solution chunk.** Both the CI runner's paths reject it with `400 Machine does not allow SSH access`: `labctl challenge start --machine <noSSH>` (used for the *first* chunk) AND `labctl ssh --machine <noSSH>` (used for *subsequent* chunks). So the solution must target **only SSH-able machines** — it never has a `# session: root@verifier` chunk. (The `verifier` still exists in `index.md`; it just does its checking through its own tasks, not through a solution session.) *`noSSH` only blocks `labctl`/student SSH **into** the machine — the verifier's own tasks still reach `server-01` over inter-machine SSH, so keep seeding `root`'s `~/.ssh/known_hosts` with `ssh-keyscan server-01` in an init task.*
- **A live solution session does not survive its machine's reboot.** The `# session:` SSH dies the instant the box goes down (`remote command exited without exit status`, non-zero exit) and does **not** reconnect. So no single session can span the reboot.

The good news: **verify tasks are evaluated autonomously while a solve is active** (the verifier's `verify_survives_reboot` advances to `status: 40` on its own once the world state is right — no solution session has to "trigger" it). That splits reboot challenges into two cases:

### Case 1 — survival is automatic (NO post-reboot action needed)

When the post-reboot state restores itself — an **enabled** systemd service (`WantedBy=…`), a container `--restart` policy, an `/etc/fstab` mount — the verifier merely *observes* it. The solution just does the setup on the student-facing machine and `sudo reboot`; nothing after. The reboot chunk exiting non-zero (its SSH died) is expected and fine — completion is judged purely by task status, which auto-eval drives to `40`. Examples: `docker-101-…`, `podman-101-…`, `storage-persistent-mount`, `linux-create-systemd-service`. Mirror one of these for structure — but **drop** the vestigial `# session: root@verifier` + `sleep 300` chunk they still carry at the top: it `400`s harmlessly and does nothing, and a new solution should not have it.

```sh
# session: server-01
# ... create the unit / set the restart policy / add the fstab line ...
sudo reboot
```

### Case 2 — a post-reboot ACTION is required (e.g. socket activation)

Some challenges need a real action *after* the reboot that auto-eval cannot perform — e.g. socket activation, where a `curl` must hit the port to wake the dormant service. Use a **second chunk on the SAME rebooting machine, marked `retry=N`**, which the CI runner re-runs from the top until it exits 0 (so it reconnects once the box is back). `examinerctl` on `server-01` can wait on tasks that live on the `verifier` (it is cross-machine), so this chunk owns the whole post-reboot sequence:

```sh
# session: server-01
# ... create units, wait on the pre-reboot verify tasks, curl once, ...
sudo systemd-run --on-active=5s systemctl reboot   # NOT a bare `sudo reboot` - see below

# session: server-01 retry=20
examinerctl task wait verify_survives_reboot --timeout 300s   # auto-passes: socket back, service dormant
curl -sf http://127.0.0.1:8080/ 2>/dev/null || true          # the post-reboot ACTION
examinerctl task wait verify_on_demand_activation_after_reboot --timeout 120s
```

- **A non-`retry` chunk followed by more chunks must SCHEDULE its reboot, never run `sudo reboot` directly.** A direct reboot races the SSH session teardown: if sshd dies before the shell's exit status crosses the connection, `labctl ssh` reports `remote command exited without exit status` and the chunk exits non-zero — and the runner then stops without ever executing the post-reboot chunk (an intermittent CI failure whose tell is a missing `chunk-01.*` log in the artifacts). `sudo systemd-run --on-active=5s systemctl reboot` fires the reboot a few seconds after the session has already exited cleanly with status 0. (A Case-1 *terminal* chunk may keep a bare `sudo reboot` — there is nothing after it to skip.)
- **`retry[=N]` is a session-line flag** parsed by the CI runner (`tests/challenges/main.go`): a subsequent chunk so marked is retried from the top (1s between attempts, bounded by the test timeout) until it exits 0, instead of bailing on the first non-zero exit. Bare `retry` = 1 attempt of retry (too few for a reboot); use a generous count like `retry=20`. A chunk **without** the flag keeps the default "stop on non-zero exit" behavior, so an ordinary reboot-terminal chunk (Case 1) is unaffected. The chunk must be **idempotent** (it re-runs whole on each attempt).
- **Reboot-survival vs. on-demand-reactivation can conflict — order them with `needs:`.** If one task asserts a service is *inactive* after reboot and a later one asserts it became *active* (because the `retry` chunk curled it), make the "active" task `needs:` the "inactive" one. Verify-task success is sticky (a passed task stays `status: 40`), so once the "still dormant" check passes it won't regress when the action wakes the service.