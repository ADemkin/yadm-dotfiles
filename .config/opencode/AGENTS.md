# Global memory

Persistent preferences for every OpenCode session, any project.

## Language

Use English. Use Russian only when user ask in chat. Ignore language switch from agent files.

## Memory protocol

- If user asks to remember something, add it to this file — under the matching section below, or a new section if none fits — then confirm what was saved and where.
- Keep entries short and durable: preferences and standing facts, not session-specific context.

## Testing preferences (moderation-detectors)

- Do not unit-test detector `start()`/`stop()` lifecycle (client wiring); user decision, 2026-11.

## Workflow: parallel user edits, task queue, drift audits

- User edits files in parallel and may commit mid-session. Before every edit, review round, or gate run: `git status`/`git diff` first and re-read target files fresh — never trust previously-read content. Acknowledge and preserve the user's parallel edits (do not overwrite); run gates over the merged state.
- Task queue: user enqueues with "queue:" or a numbered message — enqueue without starting, then work items in order, restating the remaining queue after each finished item (restatements survive context compaction). When new work arrives mid-loop, restate the full updated queue before continuing.
- Drift audit: at every review round launch and before declaring any loop finished, re-scan the session history for user requests not yet done and report them explicitly.

## Review gates (agent definition files)

- After every edit batch touching `~/.config/opencode/agents/*.md` (or any YAML-frontmatter agent file): run the structural gate before declaring the batch done — frontmatter matches `^---\n(.*?)\n---\n`; `description:`, `mode:`, `color:` present; every permission rule has `action:` + `resource:` + `effect:` with effect ∈ allow/ask/deny. One python3 heredoc; prints `GATE PASS` / `GATE FAIL (n)`.
- On `GATE FAIL`: fix and rerun — never leave an agent file failing the gate.
