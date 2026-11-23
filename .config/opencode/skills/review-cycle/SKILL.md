---
name: review-cycle
description: >-
  Review-fix-verify loop driven by a fresh-eyes reviewer subagent. Each round:
  the reviewer reports findings, the agent fixes every one of them, runs all
  project gates, and reports the result. The loop ends only after N consecutive
  rounds with zero findings (default 3). Use when the user asks to "run the
  review cycle", "review the changes/branch until clean", "repeat reviews
  until no new findings", "make the code perfect", or to continue an
  already-running loop. For a single one-shot review, call the reviewer
  directly instead.
---

# Review Cycle

A loop that hardens changes to a stated bar; it ends on a count, never on a feeling.

## Parameters and definitions

- **N** — clean rounds required to finish. Default `3`; a positive integer; user may set another.
- **Round** — one reviewer launch + every fix it causes + one full gate run (a superseded round: launch only).
- **Finding** — in-scope issue reported as `[SEVERITY] path:line`, any severity (a NIT counts). Out-of-scope observations ("Noticed elsewhere") are not findings: no counter reset, no fix mandate; carried to the final report.
- **Clean round** — zero findings, and nothing in scope changed after the reviewer read the tree; a no-verdict launch is never a clean round.
- **Counter** — consecutive clean rounds; starts at `0`. Any finding or post-read in-scope change resets it to `0`.
- **Gates** — the project's full verification commands (format check, lint, typecheck, tests). Discover from project instructions (CLAUDE.md, AGENTS.md, Makefile); never invent them; find none — ask the user before starting.
- **Scope** — what the loop covers: the changes the user named, or the whole working-tree diff if none named. Non-repo or non-code target: every `git status`/`git diff` step below becomes a fresh full re-read, and the review dimensions adapt.

## Before round 1

1. Discover the gates; list them to the user.
2. Global workflow rules apply throughout the loop: `git status`/`git diff` plus a fresh re-read of every in-scope file before each round and gate run — the user edits in parallel and may commit mid-loop; in-scope work is never overwritten (non-repo: fresh full re-reads, see Scope). Task queue and drift audit per global rules; loop-specific: in-scope drift-audit items are implemented and enter the next brief's "changes since last round".
3. Run the full gates once for a baseline. A failure: pause and ask — fix first (then re-run the full gates), or waive; a user-approved waiver is recorded in every brief's Owner decisions and marked "FAIL (waived)" in per-round reports.
4. State scope, gates, N, gate baseline — first line "Before round 1: scope …, gates …, N …, baseline …" — then start round 1.

Interrupted loop? Recover the state from the latest per-round report for this scope (counter included); none exists — start a fresh cycle. Anything ambiguous: ask the user.

## Each round

### 1. Prepare

- Fresh `git status`/`git diff` and in-scope re-reads (global workflow rules, Before round 1 step 2).
- **Drift audit** — re-scan the session for user requests not yet done; implement in-scope items now (they enter "changes since last round"); anything that cannot be implemented before launch: report it and implement it before the next launch.

### 2. Launch one reviewer

Build the brief from the template below and launch the `reviewer` subagent in the background with it — one live verdict at a time.

### 3. While the reviewer runs

Never mutate files in the running reviewer's scope. Questions: answer immediately. In-scope change requests: enqueue — implement after the verdict, before the gates; out-of-scope changes: implement immediately, in parallel. User commits or edits the tree mid-round: the next brief carries that delta. Never hard-kill a running reviewer — let it finish, or supersede its verdict and re-review everything next round.

### 4. Process the verdict

The listed `[SEVERITY]` items are authoritative: a "FINDINGS:" count disagreeing with them is corrected to the count of listed in-scope items.

1. Fix every finding and implement all queued in-scope work — now, before the gates. Only exception: a user-approved wontfix — record it in every brief's Owner decisions. A finding proven inapplicable (e.g., shadowed permissions, already-correct behavior): no fix — record it as dismissed in the next brief's Verified facts. A finding surviving two fix rounds: pause and ask the user — wontfix, revert and re-implement, or continue. A reviewer question that a file read settles becomes a Verified fact in every brief; an unsettled question goes to the user.
2. Run the full gates over the merged state. A user-approved waived failure: mark "FAIL (waived)" and continue. Otherwise fix and rerun; pause and ask the user only if the rerun fails again or the cause lies outside this loop's edits.
3. Whatever changed in scope becomes the next brief's "changes since last round".
4. Update the counter — `+1` on a clean round, `0` otherwise (verdict rounds; a no-verdict round follows item 5) — report the round (template below), and start the next round at Prepare, unless the counter reached N.
5. A launch returning no verdict (subagent error, timeout, or a reply without the "FINDINGS:" line): counter unchanged unless a post-read in-scope change resets it to `0`, record the round as superseded, start the next round at Prepare. After two consecutive no-verdict launches, stop and ask whether to retry or abort.

## Finish

When the counter reaches N: re-run `git status` and `git diff` and re-read the files in scope — any post-read in-scope change resets the counter to `0` and the loop continues at Prepare. Then run one more drift audit and deliver the final report (template below); record pending work in it, do not act on it. The user may change N or stop the loop at any moment: an N change takes effect at the next counter check; on a stop, deliver the same report with first line "Cycle stopped by user" and discard a still-running reviewer's verdict.

## Reviewer brief template

Fill every brace except the Output section's `{count}`, which the reviewer fills. Cumulative sections grow each round; on round 1 summarize the changes under review in "Changes since last round" and write "none yet" in empty cumulative sections.

```
Round {n} of a review-fix loop on {project/branch}; target bar: {N} clean rounds.

Scope: {files, directories, sections}. Out of scope: {explicit list}.
Changes since last round: {numbered list, or "none"; mark which items
implement findings and which are owner requests}.
Owner decisions (do NOT flag): {numbered, cumulative across rounds}.
Verified facts (do NOT re-report the opposite): {numbered, cumulative}.
Round history: {r1: k findings -> resolved (fixed, wontfixed, or dismissed); a clean
round as "r{n}: 0 findings (clean)"; a no-verdict round as "r{n}: superseded"}.
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
## Round {n}: {k} finding(s) (a no-verdict round: "## Round {n}: superseded")
Scope: {scope}.
| # | Severity | Finding (file:line) | Fix applied |
|---|----------|---------------------|-------------|
Noticed elsewhere: {bullets, or "none"} — carried to the final report's residual risks.
Gates: {command}: PASS / FAIL / FAIL (waived), ...
Delta since review: {in-scope changes after the reviewer read, or "none"}.
Counter: {c}/{N}.
Carried state: Owner decisions: {cumulative, condensed}. Verified facts: {cumulative, condensed}.
Next: round {n+1} launching. Terminal round: "Cycle complete — final report follows".
```

## Final report template

```
Review cycle complete: {c} consecutive clean rounds (target {N}). — or, on a
user stop: "Cycle stopped by user" (with the counter at the stop).
Trajectory: r1 {a} -> r2 {b} -> ..., or "none" when no round was launched.
Total findings resolved in trajectory rounds (fixed, wontfixed, or dismissed): {t}.
User requests absorbed mid-loop: {list, or "none"}.
Drift audit before finish: {pending user requests, or "none"}.
Gates (final run): {status per command, noting any user-approved waivers}.
Residual risks / out-of-scope observations (incl. user-approved wontfix
findings): {bullets, or "none recorded"}.
```
