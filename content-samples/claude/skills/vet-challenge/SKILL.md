---
name: vet-challenge
description: Vets a community-author-submitted challenge for malicious content and sanity, then prepares and validates a scripted .solution.sh. Use when asked to review/vet a third-party challenge submission.
argument-hint: <challenge-name-or-url>
---

Vet the community-submitted challenge `$0` and prepare a reliable scripted solution.

Resolve the bare challenge name from `$0` (strip any `https://labs.iximiuz.com/challenges/` prefix). Refer to it below as `<name>`.

## Steps

1. **Pull the source.** Invoke the `pull-content-source` skill with `challenge <name>`. Third-party challenges live in `3rd-party/challenges/<name>` — pull there if no local folder is detected:
   ```sh
   labctl content pull challenge <name> --dir 3rd-party/challenges/<name> --force
   ```

2. **Security review.** Read `index.md` and every solution file. Look for malicious content: keyloggers, cryptominers, XSS, reverse shells, credential/data exfiltration, fetching+executing remote code, suspicious base64/obfuscation. Report findings explicitly.

3. **Sanity review.** Confirm the challenge is clearly written, reasonable, and pedagogically helpful. Flag authoring issues (e.g., malformed YAML indentation in `tasks:`, broken `needs:` chains, cross-machine init `needs:`) even when the platform tolerates them. Also flag **narrative/diagnostic mismatches** — where the symptom the text tells the student to look for differs from what actually happens (cross-check this against the live broken state in step 4). E.g. a "the pod is OOMKilled, run `kubectl describe pod`" story when the pod is in fact *rejected at admission* and never exists to describe. The fix the challenge teaches may still be correct while the explanation misleads the learner.

4. **Launch it** as a free-tier user, non-interactively:
   ```sh
   labctl challenge start --as-free-tier-user --safety-disclaimer-consent --no-open --no-ssh <name>
   ```
   Find the playground ID in the output of the above command. Verify the intended broken/initial state matches the scenario with `labctl ssh <id> -- <diagnostic>`.

5. **Write `3rd-party/challenges/<name>/.solution.sh`**. Rules:
   - **No shebang and no `set -euo pipefail`** — `set -exuo pipefail` is injected automatically when the solution is applied (see the `solve-challenge` skill).
   - **Guard benign non-zero exits** — because `set -exuo pipefail` is injected, any command whose non-zero exit is expected will abort the whole script (and waste a fresh-start cycle). Neutralize such commands with `|| true` or move them into an `if`. The classic offender is a value-probe in a `$(...)` assignment that legitimately fails before the resource exists, e.g. inside a polling loop `phase=$(kubectl get pod ... -o jsonpath='{.items[0].status.phase}')` errors with "array index out of bounds" while the pod list is empty — write `... 2>/dev/null || true`.
   - After the command(s) that satisfy each task, call `examinerctl task wait <task-name>` (task name is positional; `--timeout <dur>` supported) so the task is confirmed `completed` before proceeding. This avoids races.
   - For challenges spanning multiple VMs, split the script with `# session: [user@]machine` marker lines (e.g. `# session: root@leaf-01`); commands after a marker run on that VM. Content before the first marker runs on the default machine/user. See `solve-challenge` for the exact chunking rules.
   - Use `labctl playground tasks <id>` (tunnel-free, all machines; add `-o yaml` for per-task detail) to discover task names and dependency order.
   - If the author's solution exists (e.g., `solution(-\d+)?.md`), mirror it as closely as possible (use the same commands, file names, paths, etc).

6. **Add `3rd-party/challenges/<name>/.gitignore`** that ignores everything except the solution scripts:
   ```
   *
   !.gitignore
   !.solution*.sh
   ```

7. **Validate end-to-end twice via `solve-challenge`.** Invoke the `solve-challenge` skill with `<name>` to apply the script against a fresh attempt and confirm every non-helper task completes. Then invoke `solve-challenge` with `<name>` **a second time** to confirm the solution is not flaky. Both runs must pass. (`solve-challenge` handles fresh-start, multi-VM session chunks, `examinerctl task wait`, and the authoritative completion check — do not re-implement that here.)

8. **Stop the challenge** when done and report the security verdict, sanity findings, and validation results.

## Notes

- Prefer the project skills (`pull-content-source`, `detect-local-content-folder`, `run-playground-command`, `list-running-playgrounds`) over raw `labctl` where they fit.
- Use polling loops with short sleeps, not single long sleeps, when waiting on init/verification.
