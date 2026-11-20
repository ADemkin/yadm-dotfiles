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

A loop that hardens a set of changes to a stated bar. It ends on a count, never
on a feeling.

## Parameters and definitions

- **N** — clean rounds required to finish. Default `3`; a positive integer. The
  user may set another value.
- **Round** — one reviewer launch + every fix it causes + one full gate run. A
  superseded round (see "While the reviewer runs") runs no gates; the counter
  resets to `0`. A launch that returns no verdict (see "Process the verdict")
  is recorded with the superseded report variant but, unlike a superseded
  round, leaves the counter unchanged.
- **Finding** — an in-scope issue reported in the `[SEVERITY] path:line` format,
  at any severity (CRITICAL, MAJOR, MINOR, NIT). A NIT counts. Out-of-scope
  observations ("Noticed elsewhere") are not findings: they neither reset the
  counter nor mandate fixes, but are carried to the final report's residual
  risks.
- **Clean round** — zero findings in the verdict and nothing in scope changed
  after the reviewer read the tree (no fixes, no queued work, no gate fix, no
  user commit or edit, no scope change).
- **Counter** — consecutive clean rounds. Starts at `0` in a fresh cycle;
  restored from the latest per-round report on resume. Any finding, post-read
  in-scope change, change to the scope itself, or superseded round resets it to
  `0`.
- **Gates** — the project's full verification commands (format check, lint,
  typecheck, tests). Discover them from project instructions (CLAUDE.md,
  AGENTS.md, Makefile); never invent them; if none are discoverable, ask the
  user before starting.
- **Scope** — what the loop covers: the changes the user named, or the whole
  working-tree diff if none named. Stated to the user before round 1; carried
  in every brief. Non-repo or non-code target: every `git status`/`git diff`
  step below becomes a fresh full re-read, and the review dimensions adapt.

## Before round 1

1. Discover the gates; list them to the user.
2. Pre-clean, only if the user asked for it: run one-shot reviews with the
   `reviewer` subagent — direct calls, not Rounds — fixing every finding,
   running the full gates after each fixing pass, until a pass reports zero
   findings or the user says to start the cycle. Brief each pass like a
   round-1 brief — first line "Pre-clean pass {k} of a review-fix loop on
   {project/branch}." (never "Round {n}", so pass and round briefs cannot
   collide in the session history the recovery rules search) — with Scope;
   "Changes since last pass" (the fixes from pass k-1, or "none" on
   pass 1 unless in-scope work already entered it); cumulative Owner
   decisions and Verified facts; Review dimensions;
   Calibrate; Fresh eyes phrased over "previous passes"; and the output
   contract — but without the target-bar clause or a Round history line:
   passes never count toward N. Pre-clean passes are not Rounds: nothing
   enters the round history or the trajectory, the counter is untouched (it
   starts at `0` at round 1), and no per-round reports are written; their
   fixes are summarized in the round-1 brief's "Changes since last round",
   their findings count toward the final report's "Total findings resolved",
   and their "Noticed elsewhere" items join the final report's residual
   risks. A pass whose reply has no verdict line is not a zero-finding pass:
   retry it, and after two consecutive no-verdict passes stop and ask
   whether to retry, change the launch setup, or skip the remaining
   pre-clean and start the cycle at step 3 — resolved inline (a retry or
   setup change resets the consecutive no-verdict pass count), without round
   reports or counter changes; a retried or relaunched pass reuses the same
   {k} — only resolved passes advance the count. The listed [SEVERITY] items are
   authoritative: a "FINDINGS:" count that disagrees with them is corrected
   to the listed count, and that corrected count decides whether the pass
   reported zero findings. A gate failure during pre-cleaning is
   resolved with the user immediately (fix, waiver recorded as an Owner
   decision, or stop before the cycle starts) — the persisted-pause
   machinery applies only once the cycle has started. A user-approved
   wontfix on a pass finding is recorded as an Owner decision — carried into
   the remaining pass briefs and every round brief — and excluded from
   fixing; a factual question a pass raises that a file read or harness
   check settles is recorded as a Verified fact the same way. In-scope work
   or a scope-change request arriving during pre-cleaning: a running pass
   resolves first, then implement it before the next pass, where it enters
   "Changes since last pass"; a scope change updates the scope for the
   remaining passes. On a user stop before
   round 1 — during pre-cleaning or any later step of this phase — deliver
   the final report's stop variant with the first line "Cycle stopped by
   user before round 1." and discard a still-running pass's verdict — let
   it finish, do not act on it; a "start the cycle" landing while a pass is
   still running takes the opposite route — let it finish and resolve it as
   a pass (findings fixed, gates run) before round 1 starts. An interruption
   during pre-cleaning predates round 1: recovery routes through the resume
   section's pre-round branch (below), which re-enters this step — the
   pre-clean reruns from the next pass unless the user says to skip it or
   the last pass already reported zero findings. A fresh cycle — any route
   that starts one — does not re-run a pre-clean of the same or an
   overlapping scope that already completed or that a user stop ended: it
   asks whether to pre-clean again.
3. Run the full gates once for a baseline. On a failure covered by a
   recorded waiver, mark it "FAIL (waived)" and continue; otherwise ask the
   user whether to proceed; a yes is recorded as a waiver in every brief's
   Owner decisions so later rounds do not re-ask.
4. Run `git status` and `git diff`; note the user's parallel edits and
   uncommitted work — in scope, never overwritten (non-repo: see "Scope").
5. Re-read every file in scope. Re-read again every round: the user edits in
   parallel and may commit mid-loop — never reuse a previous round's content.
6. State scope, gates, N, gate baseline — first line "Before round 1: scope
   …, gates …, N …, baseline …", the statement the recovery routes recognize
   — then start round 1.

## Resuming an interrupted loop

Check this first: identify the cycle being resumed — the latest cycle for
the requested scope; an unqualified request resumes the latest cycle; if no
cycle matches the requested scope — or none exists in the session — say so
and ask whether to continue an existing cycle under its scope (when one
exists), recover from a user-provided latest report, or start a fresh one
(a later cycle's
per-round reports supersede an earlier cycle's final report, so an earlier
delivered final report never routes a later interrupted cycle). A delivered
final report of that cycle
carrying the stop marker ("Cycle
stopped by user…") means the cycle stays stopped — no launch to resume it (a
later explicit request — to run or continue the cycle, with or without
raising N — starts a fresh cycle at "Before round 1"); a pre-stop reviewer's
verdict stays discarded, and the pending queue is surfaced to the user, not
implemented; one carrying the completion marker ("Review cycle complete")
means the cycle is finished — answer new requests without re-delivering it;
an explicit request to run the cycle again starts a fresh cycle at "Before
round 1"; a request to continue the completed cycle with a raised N resumes
at step 1 (Prepare) with the counter preserved unless `git status`/`git diff`
and fresh re-reads, compared against the latest per-round report's Scope and
"Delta since review" lines per the recovery rules below, show that an
in-scope change landed after the last reviewer read (the standing reset
rule) — the final report carries the counter but neither Owner decisions nor
Verified facts, so take Scope, Owner decisions, and Verified facts from the
latest per-round report per the recovery rules below, asking the user for it
when the session history is gone; a request to continue without raising N:
tell the user the cycle is complete and ask whether to raise N or start a
fresh cycle.
An interruption before round 1 — the session history shows pre-round
evidence (the step-6 statement, a gate listing, a baseline-gates run, step
4/5 output, or a pass brief) but no "Round {n} of a review-fix loop" brief
for the cycle being resumed — never reaches the Round machinery below: recover gates, scope, N, Owner
decisions, Verified facts, and the passes so far from that history; re-scan
for queued in-scope requests, scope changes, second-cycle requests (answered
or enqueued, never started — the Prepare drift-audit rule), and loop-control
commands: queued in-scope requests are implemented after a running pass, if
any, has resolved and before the next pass — or, if the pre-clean has ended,
before round 1's launch — entering the next pass brief's "Changes since last
pass" or the round-1 brief's "Changes since last round" respectively; a
scope change updates the scope for
the remaining passes; a stop delivers the stop variant per "Before round 1"
step 2 and recovery ends there (a pre-stop pass's verdict, running or
finished-unrecorded, stays discarded; the pending queue is surfaced, not
implemented); an N change updates N; a no-verdict pause answer — retry,
change the launch setup, or skip the remaining pre-clean and start the
cycle at step 3 — is honored before the retry, resetting the consecutive
no-verdict pass count on a retry or setup change; a start-the-cycle command
ends the
pre-clean — once a running pass, if any, is resolved per the pass rule
below, re-enter at step 3. Then re-enter "Before round 1" at the step that
was running. A pre-clean reviewer launched before the interruption is
resolved as a pass, not a Round: let it finish — its findings are fixed and
the full gates run per "Before round 1" step 2; a zero-finding verdict
completes pre-cleaning (continue at step 3); a reply without the verdict
line is retried per that step; a pass whose outcome cannot be established —
launched but no established reply — relaunches with the same {k}, counting
toward step 2's two-consecutive no-verdict bound alongside no-verdict
replies: after two consecutive failed launches of either kind, stop and ask
(the no-verdict pause's options). No per-round report is written and the
counter is untouched.
Otherwise, recover scope, N, counter, pending
queue, and carried state (rounds so far, Owner decisions, Verified facts)
from the latest per-round report of this cycle (matched by scope — never
another cycle's report) — or, if the interruption predates the
first per-round report, from the session history (the "Before round 1"
statement and the latest brief), with the counter at `0`; never reset the
counter merely because the session was interrupted — the standing reset rule
still applies to changes made after the last reviewer read, detected by
comparing `git status`/`git diff` and fresh re-reads against the latest
per-round report's Scope and "Delta since review" lines (plus the
interrupted launch's brief when a verdict is outstanding). Per-round
reports live in the session history: resumption needs the same session or a
user-provided latest report; with neither, start a fresh cycle at "Before
round 1". Then re-scan the session for in-scope
requests, scope-change requests, second-cycle requests (never started
mid-loop — enqueued or answered, per the Prepare drift audit), and
loop-control commands (a user stop, an N
change) enqueued before the interruption and not yet done — except a scope
change already delivered to the reviewer's session, which is scanned and
routed even though it was acted on: requests join the recovered pending
queue; a scope change the latest per-round report's Scope line does not yet
reflect — delivered to the reviewer's session or not — updates the recovered
scope for the next brief and round report and resets the counter per the
Counter definition; one the report already reflects only confirms the
recovered scope (its reset is baked into the recovered counter); a
stop delivers the final report's stop variant per
"Finish" and the cycle stays stopped — recovery ends there (a pre-stop
reviewer's verdict stays discarded, the pending queue is surfaced, not
implemented); an N change updates N. Then resolve a
reviewer launched before the interruption — still running, or already
finished with a verdict no round report records (a verdict is outstanding
only until a round report — normal, paused, or superseded — records it; a
recorded verdict routes through the Next-marker branches below, never
through verdict resolution): let it finish. If its verdict is outstanding,
process or supersede it. Process it per "Process the verdict" — its step 1
fixes the findings and implements the recovered pending queue, before the
gates — if the re-scan, `git status`/`git diff`, and fresh re-reads,
compared against the tree state reflected in the latest per-round report
(its Scope and "Delta since review" lines) plus the interrupted launch's
brief ("Changes since last round"), establish that nothing in scope changed
after the reviewer's read and no scope-change follow-up that has not
been delivered to its session is outstanding; if the evidence is inconclusive
— including when no per-round report exists to compare against — supersede; the
processing's step 5 then routes on — next round at step 1 (Prepare), or
Finish if the counter reached N. Otherwise supersede it (see "While the
reviewer runs"), implement the recovered pending queue before the next launch
— an undelivered scope-change follow-up always takes this path — verify the
tree with `git status` and `git diff`, re-read the files in scope, and launch
the next round at step 1 (Prepare). A finished reviewer whose reply has no
verdict line is recorded per "Process the verdict"'s no-verdict rule
(counter unchanged) before routing on. If no verdict is outstanding: if no
per-round report exists, start a fresh cycle at "Before round 1",
implementing the recovered pending queue first; otherwise
route on the report's Next marker. Next is "Paused — awaiting user decision":
re-present the pending decision only if the report lacks a `Decision:` line;
record the outcome in every brief's Owner decisions; a `stop` or `abort`
outcome — or a paused report whose `Decision:` line records stop or abort —
delivers the final report's stop variant per "Finish" and the cycle stays
stopped; a fix or
waiver outcome — after implementing the recovered pending queue and, for a
fix, implementing it first, and verifying the tree with `git status` and
`git diff` and re-reading the files in scope — resumes "Process the verdict"
at step 3; a retry or change-setup outcome (a no-verdict pause) — after implementing
the recovered pending queue and, for a setup change, applying it first, and
resetting the consecutive no-verdict count — starts the next round at step 1
(Prepare). Next is the terminal marker ("Cycle complete — final report follows"):
deliver the final report per "Finish" instead of launching — unless a
re-scanned N change raised N above the counter, in which case implement the
recovered pending queue and continue at step 1 (Prepare). Otherwise (a
report exists, no outstanding verdict):
implement the recovered pending queue, verify the tree with `git status` and
`git diff`, re-read the files in scope, and continue at step 1 (Prepare).

## Each round

### 1. Prepare

- Re-run `git status` and `git diff`; re-read the files in scope.
- **Drift audit** — re-scan the session for user requests not yet done; report
  anything found before launching. Implement in-scope items at once, before
  the launch (they enter "changes since last round"), or enqueue them for
  verdict step 1 if the user asked to defer; a scope-change request updates
  the scope for the next brief and resets the counter per the Counter
  definition; a request to start another review cycle is enqueued or answered,
  never started mid-loop.

### 2. Launch one reviewer

- Use the `reviewer` subagent — one at a time, launched in the
  background; say so to the user.
- Build the brief from the template below. It is cumulative: verified facts and
  owner decisions carry forward, so later rounds do not re-litigate settled
  questions.

### 3. While the reviewer runs

Never mutate files in the running reviewer's scope.

| Incoming work | Action |
|---|---|
| Question or explanation | Answer immediately. |
| Change in the reviewer's scope | Enqueue — implement after the verdict, before the gates (verdict step 1). |
| Change outside the reviewer's scope | Implement immediately, in parallel. |
| Large, fully self-specified task | May delegate to a background subagent — only if it cannot touch the reviewer's scope; otherwise handle per the rows above. |
| Change to the review's scope itself | Send a follow-up message to the reviewer's background session (its sessionID), or fold into the next brief — folding (no redirect) supersedes the running verdict. |
| Request to start another review cycle | Enqueue or answer — never start one mid-loop (the Prepare drift-audit rule). |

Between rounds and during a pause, implement in-scope requests at once, before
the next launch, so the next read covers them; the change resets the counter to
`0` and enters the next brief's "changes since last round". The same applies
after a processed verdict but before the round report, with the gates rerun over the
merged state.

Never hard-kill a running reviewer — redirect it, or supersede its verdict: a
superseded verdict is not acted on, the counter resets to `0`, the round report
notes the supersession, and the next round re-reviews everything. If the user
commits or edits the tree mid-round, the next brief carries that delta for
verification. Restate the remaining queue after every finished item.

### 4. Process the verdict

A launch that returns no message ending with the "FINDINGS: {count}" verdict
line — subagent error, timeout, or a reply without the line — has no verdict:
do not update the counter, record the round per the report template's
superseded variant, and start the next round at step 1 (Prepare). After two
consecutive no-verdict launches, record the round per the superseded variant
but with Next: "Paused — awaiting user decision", then stop and ask whether
to retry, change the launch setup, or abort; a retry or change-setup outcome
starts the next round at step 1 (Prepare) — for a setup change, apply it
first — and resets the consecutive no-verdict count; an abort outcome
delivers the final report's stop variant per "Finish".

The listed [SEVERITY] items are authoritative: a "FINDINGS:" count that
disagrees with them is corrected to the listed count, not treated as a clean
verdict.

1. Fix every finding and implement all queued in-scope work — now, after the
   verdict and before the gates. Only exception: a user-approved wontfix —
   record it in every brief's Owner decisions so later rounds do not re-report.
   A factual question the reviewer raised that a file read or harness check
   has settled is recorded as a Verified fact in every brief.
2. After any bulk replace, re-read what it touched — a bulk replace can rewrite
   a helper you created earlier in the same pass.
3. Run the full gates over the merged state. A failure covered by a recorded
   waiver, or by an Owner decision that mandates the failing state: mark it
   "FAIL (waived)" and continue. Otherwise: if the cause is outside this
   loop's edits, pause; otherwise fix and rerun, pausing only if the rerun
   fails again. To pause:
   write the round report first — gate FAIL, Next: "Paused — awaiting user
   decision" — then stop and ask; record the user's decision (fix, waiver,
   stop) in every brief's Owner decisions and append `Decision: {outcome}` to
   the paused report. A stop outcome delivers the final report's stop variant
   per "Finish" and ends the cycle. A fix or waiver outcome then resumes this
   step — for a fix, implement it first — rerunning the gates.
4. A round is clean only if it meets the "Clean round" definition. Whatever
   changed in scope becomes the next brief's "changes since last round".
5. Update the counter — `+1` on a clean round, `0` otherwise — then report the
   round with that value (template below) and start the next round at step 1
   (Prepare), unless the counter reached N.

### 5. Finish

When the counter reaches N, re-run `git status` and `git diff` and re-read the
files in scope — any post-read in-scope change or scope change resets the
counter to `0` and the loop continues at step 1 (Prepare) (non-repo: fresh
re-reads, see "Scope"). Then run one more
drift audit and list anything pending. Plain work requests: do not implement
them here (implementing would be a post-read in-scope change and would reset
the counter); record them in the final report's drift-audit line, then deliver
the final report (template below). A pending scope-change request is not
record-only: it updates the scope, resets the counter per the Counter
definition, and the loop continues at step 1 (Prepare). The user may change N or stop
the loop at any moment: an N change takes effect at the next counter check and
is recorded in the next brief and round report; an N change observed before
the final report is delivered takes effect immediately — if it raised N above
the counter, do not deliver and continue at step 1 (Prepare). On a stop,
deliver the same report with the stop variant's first line and discard a
still-running reviewer's verdict — let it finish, do not act on it. A
background subagent delegated under "While the reviewer runs" is left to
finish and is not awaited, at a stop and at a normal finish alike. The
per-round reports make the state recoverable after context compaction.

## Reviewer brief template

Fill every brace except the Output section's `{count}`, which the reviewer
fills; delete nothing. Cumulative sections grow each round. On
round 1 there is no last round: summarize the changes under review in "Changes
since last round" (non-repo targets: the target's current content), and write
"none yet" in empty cumulative sections — except that a fresh cycle whose
scope overlaps a prior cycle in the same session seeds its Owner decisions
and Verified facts from the latest such cycle's per-round reports or, when
that cycle has no per-round reports, from its latest brief (session history
only), so standing wontfixes and settled questions carry
over. A pass-1 brief seeds its cumulative sections the same way.

```
Round {n} of a review-fix loop on {project/branch}; target bar: {N} clean rounds.

Scope: {files, directories, sections}. Out of scope: {explicit list}.
Changes since last round: {numbered list, or "none"; mark which items
implement findings and which are owner requests}.
Owner decisions (do NOT flag): {numbered, cumulative across rounds}.
Verified facts (do NOT re-report the opposite): {numbered, cumulative}.
Round history: {r1: k findings -> resolved (fixed or wontfixed); ...; a
superseded round is recorded as "r{n}: superseded"; a no-verdict round as
"r{n}: no verdict"}.
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
Scope: {scope}. Pending queue: {list, or "none" — non-empty only when the
round was superseded or the launch returned no verdict, with unimplemented
enqueued work}.
| # | Severity | Finding (file:line) | Fix applied |
|---|----------|---------------------|-------------|
Noticed elsewhere: {bullets, or "none"} — carried to the final report's residual risks.
Gates: {command}: PASS / FAIL / FAIL (waived), ...
Delta since review: {in-scope changes after the reviewer read, or "none"}.
Counter: {c}/{N}.
Carried state: Rounds so far: {r1: k, ...; a superseded round as "r{n}: superseded"; a no-verdict round as "r{n}: no verdict"}. Owner decisions: {cumulative, condensed}. Verified facts: {cumulative, condensed}.
Next: round {n+1} launching. Terminal round: "Cycle complete — final report
follows". Stopped to ask: "Paused — awaiting user decision".
Superseded round: header "## Round {n}: superseded" (a no-verdict round:
"## Round {n}: no verdict"), no findings table,
Gates: "not run (superseded)" (a no-verdict round: "not run (no verdict)"),
Next: "superseded — round {n+1} re-reviews everything."
Counter: "0/{N}" (a no-verdict round keeps the counter it entered with).
Noticed elsewhere: "none" (a superseded verdict is void — its out-of-scope
observations are not carried; a no-verdict round: also "none" — the reply is
void).
Append `Decision: {outcome}` to a paused report once decided, correcting the
Counter line if the decision changes the value step 5 will set (a fix that
touches in-scope files makes it "0/{N}"); a paused report's Counter shows
the value step 5 will set for the interrupted round (a gate-failed round
with findings: "0/{N}"; with zero findings: the clean value step 5 will
set) — never the pre-round value for a gate-failed round;
a no-verdict pause keeps the counter it entered with.
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
Total findings resolved (fixed or wontfixed): {t} — on a cycle with a
pre-clean phase, append "(of which {k} resolved during pre-clean, before
round 1)" so the total reconciles with a trajectory that excludes pre-clean
passes. User requests absorbed mid-loop or during pre-clean: {list, or "none"}.
Drift audit before finish: {pending user requests, or "none"}.
Gates (final run; on a stop: the last full run, or "none — no full run
completed"): {status per command, noting any user-approved waivers}.
Residual risks / out-of-scope observations (incl. user-approved wontfix
findings): {bullets, or "none recorded"}.
```
