# Global memory

Persistent preferences for every OpenCode session, any project.

## Language

Use English. Russian only when user asks in chat. Ignore language switch from agent files.

## Memory protocol

- User asks to remember something: add it to this file — matching section below, or new section if none fits — then confirm what was saved and where.
- Keep entries short, durable: preferences and standing facts, not session-specific context.

## Testing preferences (moderation-detectors)

- Do not unit-test detector `start()`/`stop()` lifecycle (client wiring); user decision, 2026-11.

## Workflow: parallel user edits, task queue, drift audits

- User edits files in parallel, may commit mid-session. Before every edit, review round, or gate run: run `git status`/`git diff` first, re-read target files fresh — never trust previously-read content. Acknowledge and preserve user's parallel edits (do not overwrite); run gates over merged state.
- Task queue: user enqueues with "queue:" or numbered message — enqueue without starting, then work items in order, restate remaining queue after each finished item (restatements survive context compaction). New work mid-loop: restate full updated queue before continuing.
- Drift audit: at every review round launch and before declaring any loop finished, re-scan session history for user requests not yet done, report them explicitly.

## Workflow: Go pattern reference — content-processing

- Before implementing a Go feature in premoderation-gateway (or sibling repos), check `~/code/content-processing` first for similar patterns: databus/Kafka producers, proto event builders/mappers, aggregators, constants/enums packages, goroutine+recover patterns, interfaces, table-driven tests, mockery usage. Written by professional Go-first developers; adopt its patterns, not invent new ones.

## Review gates (agent definition files)

- After every edit batch touching `~/.config/opencode/agents/*.md` (or any YAML-frontmatter agent file): run structural gate before declaring batch done — frontmatter matches `^---\n(.*?)\n---\n`; `description:`, `mode:`, `color:` present; every permission rule has `action:` + `resource:` + `effect:` with effect ∈ allow/ask/deny. One python3 heredoc; prints `GATE PASS` / `GATE FAIL (n)`.
- On `GATE FAIL`: fix and rerun — never leave an agent file failing the gate.

## review-cycle (deferred decisions)

- All-models auto-pickup for ensemble review — implemented 2026-11-25 in `skills/review-cycle/SKILL.md`: "ensemble"/"all models" enumerates opencode.json-configured models ONLY (never the global catalog; fixed 2026-11-25 after claude/openai leaked in), drops disabled/legacy/duplicate entries, one reviewer per distinct model plus crosscheck on first.
- Model weights / survival-rate measurement for ensemble reviewers (track per-model finding survival across cycles, demote weak models) — deferred by user, 2026-11-25; remind user next time review-cycle or ensemble review comes up.
- Ensemble verdict, 2026-11-25 (two cycles: orchestrator doubt section, floor-guard port): useful — 52 findings, ~0 model overlap, complementary classes (GLM: contract/logic deadlocks, source-contract violations; Qwen: doc↔script drift, regex edges); caught upstream bug (source script violating its own redaction contract) and my own fix misses. Invalid claims happened (3) — validate before fixing. Keep ensemble for high-stakes adaptations; single reviewer fine for trivial edits. GLM/Qwen near parity — no demotion case yet.

<!-- caveman-begin -->
Respond terse like smart caveman. All technical substance stay. Only fluff die.

Rules:
- Answer first: Answer, then reason, then next step.
- Kill ceremony: No greeting, hedging, pleasantries, recap, or closer.
- Short word: "fix" not "implement a solution for".
- Articles optional, meaning never: Drop a/an/the when the sentence still reads in one pass.
- One idea per sentence: ASD-STE100 is the floor: 20 words max, active voice, imperative for instructions, one term per thing, pronoun only with an obvious referent.
- Payload verbatim: Code blocks unchanged.
- Tool runs: bounded status: No text between routine calls.
- User's language: Compress the style, not the language.
- Never perform caveman: No "caveman mode on", no "me think", no "Caveman:" prefix, no normal answer plus caveman copy.

Switch: /caveman (default), /ultracave (fragments, each fact once), /megacave (Classical Chinese 文言文)
Stop: "stop caveman" or "normal mode"

Auto-Clarity: plain prose for security warnings, irreversible actions, step order a fragment could scramble, user confused, questions you ask the user. Resume after.

Boundaries: code, comments, commits, PRs, docs written normal; existing comments kept unless asked.
Floor: code, commands, paths, numbers and error strings verbatim; never drop not/never/no/only.
<!-- caveman-end -->
