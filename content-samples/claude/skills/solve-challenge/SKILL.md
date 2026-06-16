---
name: solve-challenge
description: Applies a scripted solution to a running challenge (single- or multi-VM) and verifies every non-helper task completes. Use to validate a .solution.sh / .solution-NN.sh end-to-end.
argument-hint: <challenge-name-or-url> [solution-file]
---

Validate the scripted solution(s) for challenge `$0` against fresh challenge attempts. **Always do this with the CI helper `tests/challenges/main.go`** — it runs the exact CI chunk-execution semantics (multi-VM `# session:` chunks, `retry=N` reboot handling, init-task waiting, the authoritative completion check) and captures rich per-solution artifacts. Do not hand-roll the chunk runner.

Resolve the bare challenge name from `$0` (strip any `https://labs.iximiuz.com/challenges/` prefix). Refer to it as `<name>`.

## Locating the challenge and its solution scripts

Find the challenge folder: `3rd-party/challenges/<name>` for community submissions, otherwise `challenges/<name>` (use the `detect-local-content-folder` skill to resolve hex suffixes for first-party content). The helper auto-discovers every solution file in that folder whose basename matches `^\.solution(-\d+)?\.sh$` (`.solution.sh`, `.solution-01.sh`, …); `.solution-NN.md` files are human-facing and ignored. Each solution is run against its own fresh attempt and all must pass.

## Run the CI helper

Build once, then run with `--skip-auth` (mandatory — without it the helper calls `labctl auth login` and logs you out / replaces your session):

```sh
cd tests
go build -o challenge-tester ./challenges
./challenge-tester --skip-auth -v -d "$(pwd)/../challenges" -c "<name>" --test-timeout <dur>
```

- Point `-d` at `3rd-party/challenges` instead for community submissions.
- `--skip-auth` reuses the current session and treats it as premium-capable (premium challenges are not skipped).
- Bump `--test-timeout` (default 5m) for slow/reboot challenges.
- The `challenge-tester` binary is a build artifact — delete it when done, don't commit it.

The helper prints `SOLUTION ... SUCCESS`/`FAIL` per solution file and a final `TEST RESULTS` summary; a non-zero exit means at least one solution failed.

## Debugging a failing run

Two signals, both available *while the helper is still running* (it leaves its challenge playground up for the whole attempt):

- **Artifacts (primary).** At the start of each solution the helper prints the absolute artifacts directory (default `$TMPDIR/challenge-tester-artifacts/<challenge>/challenge-tester-artifacts.<solution>/`). Files are written and appended **dynamically as the attempt proceeds** — tail them live, don't wait for the run to end:
  - `chunk-NN[.retry-MM].{stdout,stderr}.log` — per-chunk SSH output (`NN` = 0-based chunk index, `MM` = retry attempt); a failing chunk's error lands here.
  - `tasks-NNNN.txt` + `tasks-final.txt` — periodic `labctl playground tasks -o yaml` snapshots (every 15s; final one taken right before exit) — shows which task never reached `40` and its last-run output.
  - `journal-<machine>.examiner[.err].log` — streamed examiner journal per machine.
- **Live `labctl` against the same playground.** Find its ID with `labctl playground list --filter challenge=<name>` (or `list-running-playgrounds`), then inspect: `labctl playground tasks <id> -o yaml`, or `labctl ssh <id> [--machine <m>] -- <diagnostic>`. Keep SSH foreground and one at a time (tunnel-pool discipline).

## Notes

- **Tasks are edge-activated and never regress** — once a task shows `completed` (`40`) it stays there. A task that has passed cannot later fail, so the artifacts' final task snapshot is authoritative.
- A flakiness check = run the helper **twice** (e.g. `vet-challenge` does this); both runs must pass.
- Never run `labctl auth login`/`labctl auth logout` — use the inherited session only (logging out invalidates it irrecoverably without an interactive browser flow); this is exactly why `--skip-auth` is mandatory.
- In challenges with VM reboots, the VM comes back in a few seconds; the helper's `retry=N` chunks handle the reconnect. Cap any manual post-reboot wait at ~20s.
