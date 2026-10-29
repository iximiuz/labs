---
name: vet-challenge
description: Vets a community-author-submitted challenge for malicious content, educational value, and sanity, prepares and validates a scripted .solution.sh, and writes a feedback file for the author. Use when asked to review/vet a third-party challenge submission.
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

3. **Educational review (plot and learning value).** A challenge that works technically but teaches little is **not** ready for publication. Read the title, description, scenario, task section, and hints from the learner's seat, and judge them as a strict editor would. Each of the following is a **blocker**:
   - **The framing promises a skill that the task never exercises.** A "Troubleshoot ...", "Debug ...", or "Find out why ..." challenge whose scenario already names the cause, or whose task section spells out the fix (the resource kind, type, field, and values to set). The test: can a learner pass by following the text literally, without doing the diagnosis or making the decision the title promises? If yes, it is a blocker.
   - **The problem statement is a recipe.** A numbered list that restates a docs page ("create X with these properties, add field Y, apply it") leaves the learner nothing to figure out. Constraints the checks need (a resource name, a namespace, a port) are fine to give. The approach (which mechanism, which command, which field) belongs to the learner and the hints.
   - **The scenario is implausible or inconsistent.** The story should be a situation that happens in real work, and its details should hold on the live playground (cross-check them in step 4).

   Also search `challenges/` (and `list-remote-content challenge`) for challenges on the same topic. Overlap with existing content is fine and never a blocker on its own. Only flag it to the maintainer in the final summary (step 9), and leave it out of the author feedback.

   Do not downgrade these to optional polish because the verify tasks pass, the write-up is polished, or the solution is thorough. When unsure whether a non-technical issue blocks, treat it as a blocker and explain why.

   **Sanity review.** Confirm the challenge is clearly written and reasonable. Flag authoring issues (e.g., malformed YAML indentation in `tasks:`, broken `needs:` chains, a task depending on another machine's init task without listing it explicitly in `needs:` — cross-machine `needs:` is supported but never implicit) even when the platform tolerates them. Also flag **narrative/diagnostic mismatches** — where the symptom the text tells the student to look for differs from what actually happens (cross-check this against the live broken state in step 4). E.g. a "the pod is OOMKilled, run `kubectl describe pod`" story when the pod is in fact *rejected at admission* and never exists to describe. The fix the challenge teaches may still be correct while the explanation misleads the learner.

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

8. **Write a feedback file for the author** at `3rd-party/feedback/<name>.md` (full remote name, including the hex suffix). This is the message the maintainer sends to the challenge author, so keep it short, informative, and friendly in tone. Format:

   ```markdown
   # Feedback: <Challenge Title>

   **Verdict: ready for publication**        <- or: requires adjustment before publication

   <findings - see below>
   ```

   - **Start with the findings right after the verdict.** No opening praise paragraph, no restating what the challenge is about.
   - **Verdict is `requires adjustment before publication`** when there is at least one blocker: technical (e.g., malicious or mutable external code fetched at init, a verify task the advertised solution cannot pass) or educational (any blocker from step 3, e.g. a troubleshooting challenge whose text gives away the cause and the fix). For a plot blocker, quote the sentences that give the solution away, name the gap between what the title promises and what the task asks, and propose a reworked plot: what the learner sees, what they must find out, and how the checks should change to accept it. Lead with an intro line like "One change is required before publication:", then a numbered list — one item per blocker, each starting with a **bold one-sentence claim**, followed by the evidence and a concrete fix the author can act on. After that, list the non-blocking items under a line like "Optional polish, not blocking:". End the file there — no closing pleasantry.
   - **Verdict is `ready for publication`** only when nothing blocks, technically or educationally. List the observations under an intro line like "A few small suggestions, none blocking:", and optionally end with a single short friendly closer (e.g., "Good to go - nice job!").
   - Bullets should be concrete and factual: name the task/file in backticks, state what was observed and why it matters, and point at a fix direction. Skip trivia that doesn't help the author.
   - Follow the general style guides: simple International English, hyphens (never em dashes), no silly hooks or filler.

9. **Stop the challenge** when done and report the security verdict, the educational verdict (with any overlap with existing content), sanity findings, validation results, and the path to the feedback file.

## Notes

- Prefer the project skills (`pull-content-source`, `detect-local-content-folder`, `run-playground-command`, `list-running-playgrounds`) over raw `labctl` where they fit.
- Use polling loops with short sleeps, not single long sleeps, when waiting on init/verification.
