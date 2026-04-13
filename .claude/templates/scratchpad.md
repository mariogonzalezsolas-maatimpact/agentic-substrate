# Scratchpad Template

A living document the agent maintains during execution. Survives context compactions because it's on disk, not in the context window.

---

## How to Use

Create `SCRATCHPAD.md` in the project root at the start of complex tasks. Read it first on every new session or after compaction.

## Template

```markdown
# Scratchpad

## Purpose
[1-line description of the current goal]

## Progress
- [x] Step 1: [description] (completed HH:MM)
- [/] Step 2: [description] (in progress)
- [ ] Step 3: [description]
- [B] Step 4: [description] (blocked on: [reason])
- [-] Step 5: [description] (canceled: [reason])

## Decisions
| Date | Decision | Rationale |
|------|----------|-----------|
| MM-DD | [What was decided] | [Why] |

## Surprises & Discoveries
- [Unexpected finding with evidence]
- [Something that contradicts assumptions]

## Learnings (Scars)
- [What failed and why — carry forward to next attempt]
- [Dead end that should not be re-explored]

## Current Blockers
- [What's blocking progress and what's needed to unblock]

## Files Modified
- `path/to/file`: [what changed]
```

## Key Properties

1. **Self-contained**: A novice can continue the work without prior context
2. **Timestamped**: Progress entries include time for tracking velocity
3. **Evidence-based**: Surprises and learnings include supporting evidence
4. **Survives compaction**: Lives on disk, read at session start
5. **Status legend**: [x] done, [/] working, [ ] pending, [B] blocked, [-] canceled

## When to Create

- Tasks spanning multiple sessions
- Complex multi-file implementations
- Debug investigations with multiple hypotheses
- Any task where context loss would cause rework

---

**Source**: Alejandro Vidal, "Agentic Engineering" (Scratchpad Pattern) + OpenAI Codex Execution Plans
**Updated**: 2026-04-13 | **Version**: 7.3.0
