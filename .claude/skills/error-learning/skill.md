---
name: error-learning
description: Automatic error self-tracking and learning feedback loop. Triggers when Claude makes a mistake, fails an approach, or gets corrected by the user.
auto_invoke: true
tags: [error, learning, self-correction, feedback-loop, quality]
---

# Error Learning Skill

## When This Activates

This skill activates automatically when:
- An implementation attempt fails (tests don't pass after 3 retries)
- The user corrects Claude's approach ("no, that's wrong", "don't do that")
- A quality gate fails (Research < 80, Plan < 85)
- The circuit breaker opens
- A subagent reports BLOCKED or FAILED status

## What To Do

### 1. Capture the Error

Immediately write to `memory/errors.md` (or create if it doesn't exist):

```markdown
### [YYYY-MM-DD] [Short descriptive title]
- **What happened**: [1 sentence - what went wrong]
- **Root cause**: [1 sentence - WHY it went wrong, not just the symptom]
- **Correct approach**: [1 sentence - what should have been done]
- **Prevention**: [1 clear rule to follow going forward]
- **Category**: [one of: wrong-assumption, bad-tool-usage, missing-context, reward-hacking, chaotic-oscillation, other]
```

### 2. Check for Patterns

After logging, scan the existing errors for patterns:
- Same category appearing 3+ times -> escalate to CLAUDE.md rule
- Same root cause across different errors -> systemic issue, create a rule in `.claude/rules/`
- Error was already documented -> YOU REPEATED A KNOWN ERROR. Flag this prominently.

### 3. Self-Correct

If the error is in the current task:
1. Stop what you're doing
2. Log the error
3. Read the error log for similar past mistakes
4. Apply the learned prevention rule
5. Retry with the corrected approach

## Error Categories

| Category | Description | Example |
|----------|-------------|---------|
| wrong-assumption | Assumed something about the codebase without verifying | Assumed a function exists without reading the file |
| bad-tool-usage | Used the wrong tool or wrong arguments | Used Bash for file reading instead of Read tool |
| missing-context | Didn't read enough context before acting | Edited a file without reading @linked references |
| reward-hacking | Satisfied the test/signal but missed the intent | Disabled a failing test instead of fixing the code |
| chaotic-oscillation | Edited the same file many times without progress | 10+ edits to the same file in one session |
| other | Doesn't fit above categories | Miscellaneous errors |

## The Virtuous Cycle

```
Session N: Make mistake -> Log error -> Learn prevention rule
Session N+1: Read errors at start -> Apply prevention rules -> Avoid mistake
Session N+2: Even fewer mistakes -> More efficient -> Better outcomes
```

Every error logged makes the system permanently better. This is the single highest-ROI mechanism in the entire substrate.

---

**Updated**: 2026-03-10 | **Version**: 7.1.0
