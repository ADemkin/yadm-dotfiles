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
  directly instead. Ensemble mode: say "ensemble" or "all models" to review
  with every distinct opencode.json-configured model — the skill enumerates
  them itself; unconfigured providers never launch.
---
# Review Cycle

Loop hardens changes to a stated bar; ends on a count, never a feeling.

## Parameters and definitions

- **N** — clean rounds required to finish. Default `3`; positive integer; user may set another.
- **Round** — one reviewer launch (or one parallel ensemble launch, see Reviewers) + every fix it causes + one full gate run (superseded round: launch only).
- **Reviewers** — reviewer launches per round. Default: one `reviewer` on its default model. Ensemble mode — user says "ensemble", "all models", or names an explicit list: enumerate ONLY models configured in `opencode.json` under `providers.<provider>.models` — never the global model catalog, so unconfigured providers (claude/anthropic, openai built-ins, any provider with ambient credentials) never launch; drop `disabled` entries and entries marked legacy or duplicate of another entry's underlying weights, launch one `reviewer` per distinct model with `model` set; explicit user list overrides enumeration, used as given. More than one Reviewer: merge and crosscheck per Each round step 4.
- **Finding** — in-scope issue reported as `[SEVERITY] path:line`, any severity (NIT counts). Out-of-scope observations ("Noticed elsewhere") are not findings: no counter reset, no fix mandate; carried to the final report.
- **Clean round** — zero findings, nothing in scope changed after reviewer read the tree; no-verdict launch is never a clean round.
- **Counter** — consecutive clean rounds; starts at `0`. Any finding or post-read in-scope change resets to `0`.
- **Gates** — project's full verification commands (format check, lint, typecheck, tests). Discover from project instructions (CLAUDE.md, AGENTS.md, Makefile); never invent. Find none: infer candidates from project markers (e.g. `stylua.toml`/`.luacheckrc` → stylua + luacheck; `go.mod` → `go test ./...`; `package.json` → `npm test`; `pyproject.toml` → ruff + pytest), propose list to user, run on approval; no marker → ask user before starting. Plus floor-guard whenever target is git repo with code in scope: `node ~/.config/opencode/skills/floor-guard/floor-guard.mjs` (default base `origin/main`; pass `--base <ref>` when it doesn't exist) — exit 0 clean / 1 violations (fix before proceeding; user-approved exception routes through project's tracked exceptions) / 2 could not run (report, never read as clean).
- **Scope** — what loop covers: changes user named, or whole working-tree diff if none named. Non-repo or non-code target: every `git status`/`git diff` step below becomes fresh full re-read, and review dimensions adapt.

## Before round 1

1. Discover gates; list them to user.
2. Global workflow rules apply throughout loop: `git status`/`git diff` plus fresh re-read of every in-scope file before each round and gate run — user edits in parallel, may commit mid-loop; in-scope work never overwritten (non-repo: fresh full re-reads, see Scope). Task queue and drift audit per global rules; loop-specific: in-scope drift-audit items are implemented and enter next brief's "changes since last round".
3. Run full gates once for baseline. Failure: pause and ask — fix first (then re-run full gates), or waive; user-approved waiver recorded in every brief's Owner decisions, marked "FAIL (waived)" in per-round reports.
4. State scope, gates, N, gate baseline — first line "Before round 1: scope …, gates …, N …, baseline …" — then start round 1.
5. Unattended mode — user said "unattended" (or "autonomous", "run without me"): never pause mid-loop; at every pause-and-ask point in this skill apply the conservative default — skip and record rather than guess, except where continuing would mean unverifiable work (baseline or repeated gate failure): there stop the loop and deliver the final report. Record every would-be question as a blocked item (what blocked, what you needed, what you tried, default applied) in the round report, continue; the final report lists all blocked items.

Interrupted loop? Recover state from latest per-round report for this scope (counter included); none exists — start fresh cycle. Anything ambiguous: ask user.

## Each round

### 1. Prepare

- Fresh `git status`/`git diff` and in-scope re-reads (global workflow rules, Before round 1 step 2).
- **Drift audit** — re-scan session for user requests not yet done; implement in-scope items now (they enter "changes since last round"); anything not implementable before launch: report it, implement before next launch.

### 2. Launch the reviewers

Build brief from template below. One Reviewer: launch `reviewer` subagent in background with it — one live verdict at a time. Multiple Reviewers: add independence line to brief, launch one background `reviewer` per model with `model` set, process verdicts only after every launch of the round has returned.

### 3. While the reviewers run

Never mutate files in running reviewers' scope. Questions: answer immediately. In-scope change requests: enqueue — implement after verdict, before gates; out-of-scope changes: implement immediately, in parallel. User commits or edits tree mid-round: next brief carries that delta. Never hard-kill a running reviewer — let it finish, or supersede its verdict and re-review everything next round.

### 4. Merge and crosscheck (multiple Reviewers only)

One Reviewer: skip to step 5. Multiple Reviewers: merge verdicts — findings from different reviewers with same `path:line` and substantially same problem are one finding, tagged with models that reported it; rest stay separate. Then crosscheck: launch one more `reviewer` on first model of list (or default model) with merged list and same scope; it confirms or refutes every finding against code with evidence, adds no new findings. Refuted: dismissed — next brief's Verified facts, no fix, no counter effect. Surviving merged list is round's findings, enters step 5. No-verdict launch contributes no findings, recorded in round report; every launch of round returned no verdict — round superseded per step 5 item 5.

### 5. Process the verdict

Listed `[SEVERITY]` items are authoritative: "FINDINGS:" count disagreeing with them is corrected to count of listed in-scope items.

1. Fix every finding, implement all queued in-scope work — now, before gates. Only exception: user-approved wontfix — record in every brief's Owner decisions. Finding proven inapplicable (e.g., shadowed permissions, already-correct behavior): no fix — record as dismissed in next brief's Verified facts. Finding surviving two fix rounds: pause and ask user — wontfix, revert and re-implement, or continue. Reviewer question settled by a file read: Verified fact in every brief; unsettled question goes to user.
2. Run full gates over merged state. User-approved waived failure: mark "FAIL (waived)", continue. Otherwise fix and rerun; pause and ask user only if rerun fails again or cause lies outside this loop's edits.
3. Whatever changed in scope becomes next brief's "changes since last round".
4. Update counter — `+1` on clean round, `0` otherwise (verdict rounds; no-verdict round follows item 5) — report round (template below), start next round at Prepare, unless counter reached N.
5. Every launch of round returned no verdict (subagent error, timeout, or reply without "FINDINGS:" line — with one Reviewer, any no-verdict launch is this case): counter unchanged unless post-read in-scope change resets it to `0`, record round as superseded, start next round at Prepare. After two consecutive superseded rounds, stop and ask whether to retry or abort (unattended mode: record blocked item, one retry, then stop loop with final report).
6. Stall tracking — a round whose findings did not shrink (same or more, or repeats of already-fixed areas) is a stall: stalls +1, a round with fewer findings -1 (floor 0). At 3 stalls: re-plan — condense Verified facts and Owner decisions into a minimal ledger, restart rounds with "fresh eyes after re-plan" line added to the brief. 15 total rounds (hard cap): stop the loop, deliver the final report with unresolved findings listed as residue. Never stop silently.

## Finish

Counter reaches N: re-run `git status` and `git diff`, re-read files in scope — any post-read in-scope change resets counter to `0`, loop continues at Prepare. Then run one more drift audit, deliver final report (template below); record pending work in it, do not act on it. User may change N or stop loop at any moment: N change takes effect at next counter check; on stop, deliver same report with first line "Cycle stopped by user", discard still-running reviewers' verdicts.

## Reviewer brief template

Fill every brace except Output section's `{count}`, which reviewer fills. Cumulative sections grow each round; on round 1 summarize changes under review in "Changes since last round", write "none yet" in empty cumulative sections.

```
Round {n} of a review-fix loop on {project/branch}; target bar: {N} clean rounds.
Reviewers: {1 — or K independent reviewers on different models; for K>1 add:
"work fully independently: another reviewer sees this same target in parallel;
report every finding you believe, nothing you do not"}.

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
| # | Severity | Finding (file:line) | Sources | Fix applied |
|---|----------|---------------------|---------|-------------|
Reviewers: {models that returned verdicts; a no-verdict launch noted}.
Crosscheck: {refuted findings listed as dismissed, or "n/a (one reviewer)"}.
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
