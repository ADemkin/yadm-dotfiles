# Global memory

Persistent preferences for every OpenCode session, any project.

## Language

Use English. Use Russian only when user ask in chat. Ignore language switch from agent files.

## Memory protocol

- If user asks to remember something, add it to this file — under the matching section below, or a new section if none fits — then confirm what was saved and where.
- Keep entries short and durable: preferences and standing facts, not session-specific context.

## Testing preferences (moderation-detectors)

- Do not unit-test detector `start()`/`stop()` lifecycle (client wiring); user decision, 2026-11.
