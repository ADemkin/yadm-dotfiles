---
name: Review Cycle
description: >-
  Review-fix-verify loop driven by a fresh-eyes reviewer subagent. Each round:
  the reviewer reports findings, the agent fixes every one of them, runs all
  project gates, and reports the result. The loop ends only after N consecutive
  rounds with zero findings (default 3). An optional pre-clean phase runs
  one-shot reviews until a zero-finding pass before round 1. Use when the user
  asks to "run the review cycle", "review the changes/branch until clean",
  "repeat reviews until no new findings", "make the code perfect", or to
  continue an already-running loop. For a single one-shot review, call the
  reviewer directly instead.
---

# Review Cycle

A loop that hardens changes to a stated bar; it ends on a count, never on a feeling.

## Parameters and definitions

- **N** — clean rounds required to finish. Default `3`; a positive integer; user may set another.
- **Round** — one reviewer launch + every fix it causes + one full gate run. A superseded round (see "While the reviewer runs") runs no gates and resets the counter; a no-verdict launch (see "Process the verdict") keeps the counter it entered with.
- **Finding** — in-scope issue reported in the `[SEVERITY] path:line` format, at any severity (CRITICAL, MAJOR, MINOR, NIT). A NIT counts. A `[SEVERITY]` line naming a location outside the Scope (typically a "Noticed elsewhere" item) is an out-of-scope observation: not a finding — no counter reset, no fix mandate; carried to the final report's residual risks.
- **Clean round** — zero findings in the verdict and nothing in scope changed after the reviewer read the tree (no queued work, no gate fix, no user commit or edit, no scope change).
- **Counter** — consecutive clean rounds. Starts at `0` in a fresh cycle; the latest per-round report restores it on resume. Any finding, post-read in-scope change, scope change, or superseded round resets it to `0`.
- **Gates** — the project's full verification commands (format check, lint, typecheck, tests). Discover from project instructions (CLAUDE.md, AGENTS.md, Makefile); never invent them; find none — ask the user before starting.
- **Scope** — what the loop covers: the changes the user named, or the whole working-tree diff if none named. Non-repo or non-code target: every `git status`/`git diff` step below becomes a fresh full re-read, and the review dimensions adapt.

## Before round 1

1. Discover the gates; list them to the user.
2. Pre-clean, only if the user asked for it: one-shot reviews with the `reviewer` subagent — direct calls, not Rounds — fixing every finding and running the full gates after each fixing pass, until a pass reports zero findings (count corrected to the listed in-scope items, per the count-correction rule) or the user says to start the cycle. Brief each pass like a round-1 brief — first line "Pre-clean pass {k} of a review-fix loop on {project/branch}." (never "Round {n}"), "Changes since last pass" (the fixes from pass k-1; "none" on pass 1 unless in-scope work already entered it), no target-bar clause, no Round history line. Passes are not Rounds: the counter stays `0` until round 1, and nothing enters the round history, the trajectory, or the per-round reports; their fixes go to the round-1 brief's "Changes since last round", their findings to the final total's pre-clean plus-clause, their "Noticed elsewhere" items to its residual risks. Resolve failures inline: a no-verdict pass (two-launch bound) relaunches with the same {k} — only resolved passes advance `{k}` — and after two consecutive failed launches stop and ask (retry, change the launch setup, stop, or skip the remaining pre-clean and start the cycle at step 3; a retry or setup change resets the consecutive-failed-launch count); a gate failure goes to the user (fix, waiver recorded as an Owner decision, or stop before the cycle starts); a user-approved wontfix becomes an Owner decision and a settled reviewer question a Verified fact — both carried into the remaining pass briefs and every round brief; an unsettled question goes to the user; its answer enters every brief's Owner decisions; in-scope work or a scope change waits for a running pass to resolve, then lands before the next pass — or before round 1's launch, if the pre-clean has ended — in the next brief's changes list, a scope change updating the remaining passes' scope. On a user stop before round 1 — during pre-cleaning or any later step of this phase — deliver the final report's stop variant ("Cycle stopped by user before round 1.") and discard a still-running pass's verdict (let it finish, do not act on it); a "start the cycle" landing mid-pass resolves the pass first. An interruption routes through "Resuming an interrupted loop"; a fresh cycle does not re-run a pre-clean of the same or an overlapping scope that already completed or that a user stop or the skip option ended — it asks whether to pre-clean again.
3. Run the full gates once for a baseline. A failure covered by a recorded waiver: mark it "FAIL (waived)" and continue; otherwise ask the user whether to proceed; record a yes as a waiver in every brief's Owner decisions; a no is a user stop before round 1.
4. Run `git status` and `git diff`; note the user's parallel edits and uncommitted work — in scope, never overwritten (non-repo: see "Scope").
5. Re-read every file in scope, again every round — the user edits in parallel and may commit mid-loop.
6. State scope, gates, N, gate baseline — first line "Before round 1: scope …, gates …, N …, baseline …", the exact line the recovery routes match — then start round 1.

## Resuming an interrupted loop

Identify the cycle to resume: the latest one in the session for the requested scope; no match — say so and ask whether to start a fresh one. Recover the state from that cycle's latest per-round report (matched by scope — never another cycle's report); none exists yet: from the "Before round 1" statement and the latest brief, with the counter at `0`; session history gone: ask the user for the latest report — without it, start a fresh cycle. Interruption alone never resets the counter; the standing reset rule (the Counter definition) still applies to post-read changes. Then re-scan the session for user requests enqueued before the interruption and not yet done — in-scope work (implement before continuing), scope changes (update the scope, reset the counter), N changes, stops, second-cycle requests (never started mid-loop) — and handle them per the loop's rules (Before round 1, Each round, Finish).

A round reviewer with no per-round report yet — launched before the interruption, running or finished: process its verdict per "Process the verdict" only if `git status`/`git diff` and fresh re-reads — compared against the recovered Scope and any "Delta since review" line — establish that nothing in scope changed after its read; otherwise supersede it (see "While the reviewer runs") and start the next round at step 1 (Prepare). A pass reviewer: resolve the pass per "Before round 1". A delivered final report's stop marker means the cycle stays stopped (an explicit later request starts a fresh cycle at "Before round 1"); its completion marker means the cycle is finished: continuing with a raised N resumes at step 1 (Prepare), keeping the counter unless an in-scope change landed after the last reviewer read; any other request starts a fresh cycle. A terminal round report without a delivered final report: redo the Finish checks, then deliver the final report or continue per their outcome. A report parked on Next: "Paused — awaiting user decision" is resolved by re-presenting the decision — or, if the report already records a `Decision:` line, by acting on it per "Process the verdict" (step 2, or the no-verdict rule). Anything this section does not cover: ask the user.

## Each round

### 1. Prepare

- Re-run `git status` and `git diff`; re-read the files in scope.
- **Drift audit** — re-scan the session for user requests not yet done; report anything found before launching. Implement in-scope items at once (they enter "changes since last round") or enqueue them for verdict step 1 if deferred; a scope change updates the scope for the next brief and resets the counter; a second-cycle request is enqueued or answered, never started mid-loop.

### 2. Launch one reviewer

- Build the brief from the template below and launch the `reviewer` subagent in the background with it — one live verdict at a time; say so.

### 3. While the reviewer runs

Never mutate files in the running reviewer's scope.

| Incoming work | Action |
|---|---|
| Question or explanation | Answer immediately. |
| Change in the reviewer's scope | Enqueue — implement after the verdict, before the gates (verdict step 1). |
| Change outside the reviewer's scope | Implement immediately, in parallel. |
| Large, fully specified task | May delegate to a background subagent, only if it cannot touch the reviewer's scope. |
| Change to the review's scope itself | Send a follow-up message to the reviewer's background session (its sessionID), or fold into the next brief — folding (no redirect) supersedes the running verdict; record the round per the report template's superseded variant. |
| Request to start another review cycle | Enqueue or answer — never start one mid-loop (the Prepare drift-audit rule). |

Between rounds and during a pause, implement in-scope requests at once, before the next launch; the change resets the counter to `0` and enters the next brief's "changes since last round" — the same after a processed verdict but before the round report, with the gates rerun over the merged state. Never hard-kill a running reviewer — redirect it, or supersede its verdict. User commits or edits the tree mid-round: the next brief carries that delta.

### 4. Process the verdict

A launch returning no message ending with the "FINDINGS: {count}" verdict line — subagent error, timeout, or a reply without the line — has no verdict: do not update the counter, record the round per the report template's superseded variant, and start the next round at step 1 (Prepare). After two consecutive no-verdict launches, record the round per the superseded variant but with Next: "Paused — awaiting user decision", then stop and ask whether to retry, change the launch setup, or abort; a retry or change-setup outcome starts the next round at step 1 (Prepare) — for a setup change, apply it first — and resets the consecutive no-verdict count; an abort outcome delivers the final report's stop variant per "Finish".

The listed [SEVERITY] items are authoritative: a "FINDINGS:" count disagreeing with them is corrected to the count of listed in-scope items (the count-correction rule).

1. Fix every finding and implement all queued in-scope work — now, before the gates. Only exception: a user-approved wontfix — record it in every brief's Owner decisions. A reviewer question that a file read or harness check settles becomes a Verified fact in every brief; an unsettled question goes to the user; its answer enters every brief's Owner decisions.
2. Run the full gates over the merged state. A failure covered by a recorded waiver, or by an Owner decision that mandates the failing state: mark it "FAIL (waived)" and continue. Otherwise: cause outside this loop's edits — pause; otherwise fix and rerun, pausing only if the rerun fails again. To pause: write the round report first — gate FAIL, Next: "Paused — awaiting user decision" — then stop and ask; record the user's decision (fix, waiver, stop) in every brief's Owner decisions and append `Decision: {outcome}` to the paused report. A stop outcome delivers the final report's stop variant per "Finish" and ends the cycle. A fix or waiver outcome then resumes this step — for a fix, implement it first — rerunning the gates.
3. A round is clean only if it meets the "Clean round" definition. Whatever changed in scope becomes the next brief's "changes since last round".
4. Update the counter — `+1` on a clean round, `0` otherwise — then report the round with that value (template below) and start the next round at step 1 (Prepare), unless the counter reached N.

### 5. Finish

When the counter reaches N, re-run `git status` and `git diff` and re-read the files in scope — any post-read in-scope change or scope change resets the counter to `0` and the loop continues at step 1 (Prepare) (non-repo: fresh re-reads, see "Scope"). Then run one more drift audit and list anything pending. Work and second-cycle requests: record them in the final report's drift-audit line (do not act on them here), then deliver the final report (template below). A pending scope-change request is not record-only: it updates the scope, resets the counter per the Counter definition, and the loop continues at step 1 (Prepare). The user may change N or stop the loop at any moment: an N change takes effect at the next counter check and is recorded in the next brief and round report; an N change observed before the final report is delivered takes effect immediately — it raised N above the counter: do not deliver, continue at step 1 (Prepare). On a stop, deliver the same report with the stop variant's first line and discard a still-running reviewer's verdict — let it finish, do not act on it. A background subagent delegated under "While the reviewer runs" is left to finish and is not awaited, at stop and at finish alike.

## Reviewer brief template

Fill every brace except the Output section's `{count}`, which the reviewer fills; delete nothing (pass briefs deviate per "Before round 1"). Cumulative sections grow each round. On round 1 there is no last round: summarize the changes under review in "Changes since last round" (non-repo targets: the target's current content), and write "none yet" in empty cumulative sections — except that a fresh cycle whose scope overlaps a prior cycle in the same session seeds its Owner decisions and Verified facts from the latest such cycle's per-round reports or latest brief, and a pass-1 brief seeds the same way, so standing wontfixes and settled questions carry over.

```
Round {n} of a review-fix loop on {project/branch}; target bar: {N} clean rounds.

Scope: {files, directories, sections}. Out of scope: {explicit list}.
Changes since last round: {numbered list, or "none"; mark which items
implement findings and which are owner requests}.
Owner decisions (do NOT flag): {numbered, cumulative across rounds}.
Verified facts (do NOT re-report the opposite): {numbered, cumulative}.
Round history: {r1: k findings -> resolved (fixed or wontfixed); ...; a clean
round as "r{n}: 0 findings (clean)"; a superseded round is recorded as
"r{n}: superseded"; a no-verdict round as "r{n}: no verdict"}.
Review dimensions: {adapt to the target; code default: correctness; dead code;
naming; misleading comments/docstrings; test coverage gaps; test quality;
logging duplication or missing context; consistency with house style}.
Calibrate against house style first: {paths to sibling files / conventions}.
Fresh eyes: look for anything all previous rounds missed.
Output: findings ordered by severity, each as
[SEVERITY] path:line — problem. Concrete fix.
Note clean dimensions briefly. Deliver the whole report as a single message
ending with the verdict line "FINDINGS: {count}".
This output format supersedes your standard Solid/Verdict ending; the FINDINGS
line is the verdict. An empty findings list is a valid and expected outcome.
```

## Per-round report template

```
## Round {n}: {k} finding(s)
Scope: {scope}. Pending queue: {list, or "none" — non-empty only for a
superseded or no-verdict round with unimplemented enqueued work}.
| # | Severity | Finding (file:line) | Fix applied |
|---|----------|---------------------|-------------|
Noticed elsewhere: {bullets, or "none"} — carried to the final report's residual risks.
Gates: {command}: PASS / FAIL / FAIL (waived), ...
Delta since review: {in-scope changes after the reviewer read, or "none"}.
Counter: {c}/{N}.
Carried state: Rounds so far: {r1: k, ...; a superseded round as "r{n}: superseded"; a no-verdict round as "r{n}: no verdict"}. Owner decisions: {cumulative, condensed}. Verified facts: {cumulative, condensed}.
Next: round {n+1} launching. Terminal round: "Cycle complete — final report
follows". Stopped to ask: "Paused — awaiting user decision". A stop decision:
"stopped — stop report delivered".
Superseded round: header "## Round {n}: superseded" (a no-verdict round:
"## Round {n}: no verdict"), no findings table, Gates: "not run (superseded)"
(a no-verdict round: "not run (no verdict)"), Counter: "0/{N}" (a no-verdict round:
"{entered c}/{N}"), Noticed elsewhere: "none" (the
verdict is void — its out-of-scope observations are not carried), Next:
"superseded — round {n+1} re-reviews everything." (a no-verdict round: "no verdict — round {n+1} re-reviews everything.")
Append `Decision: {outcome}` to a paused report once decided — it is the round's only
report: set its Counter to the value step 4 will set ("0/{N}" unless the round was
clean and the decision keeps that; a no-verdict pause keeps its entered counter
unless a mid-pause change reset it to `0`; a stop leaves the Counter as written)
and update its Scope, Gates, Delta since review, Pending queue, and Next to the final values.
```

## Final report template

```
Review cycle complete: {c} consecutive clean rounds (target {N}). — or, on a user stop:
"Cycle stopped by user before round 1.", "Cycle stopped by user during round
{n}; counter {c}/{N}; round {n} verdict discarded.", or "Cycle stopped by user
after round {n}; counter {c}/{N}." (omit the discard clause when no verdict
was discarded)
Trajectory: r1 {a} -> r2 {b} -> ..., or "none" when no round was launched
(findings resolved per round; a superseded round is recorded as "superseded",
a no-verdict round as "no verdict").
On a stop, add: Interrupted round {n}, or "none" if the stop landed before
round 1 or between rounds: {actual state — findings fixed / unfixed / none
delivered; gates not run / partial / ran} — an interrupted round is excluded
from the trajectory and the total below.
Total findings resolved in trajectory rounds (fixed or wontfixed): {t} — on a cycle with a
pre-clean phase, append "(plus {k} resolved during pre-clean, before round
1)" so the total reconciles with a trajectory that excludes pre-clean
passes. User requests absorbed mid-loop or during pre-clean: {list, or "none"}.
Drift audit before finish: {pending user requests, or "none"}.
Gates (final run; on a stop: the last full run, or "none — no full run
completed"): {status per command, noting any user-approved waivers}.
Residual risks / out-of-scope observations (incl. user-approved wontfix
findings): {bullets, or "none recorded"}.
```
