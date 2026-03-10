# Learnings Template

Capture what failed and why. Every failed branch feeds the knowledge base for the next attempt.

---

## The Pattern: Rollback + Learnings

Instead of: `implement → review → fix` (carries contaminated context)

Do: `attempt → fail → rollback → capture learnings → retry with learnings`

Don't carry the context. Carry only the scars.

## Template

```markdown
# Learnings: [Feature/Task Name]

## Attempt [N] - [Date]

### What Was Tried
[Brief description of the approach]

### What Failed
[Specific failure: error message, test failure, design problem]

### Why It Failed
[Root cause analysis — not symptoms, but the underlying reason]

### What We Learned
- [Concrete lesson 1]
- [Concrete lesson 2]

### Do NOT Retry
- [Approach that was proven to be a dead end]
- [Specific library/version that doesn't work]

### Carry Forward
- [Insight that should inform the next attempt]
- [Constraint discovered during this attempt]
```

## Where to Store

```
docs/learnings/
├── auth-v2-migration.md
├── redis-caching-attempt.md
└── payment-refactor.md
```

Or in the project's `SCRATCHPAD.md` under the "Learnings (Scars)" section for shorter-lived tasks.

## Why This Matters

Without learnings capture, agents **re-explore dead ends every time**. They have no memory of what failed unless you tell them. This template creates that institutional memory.

---

**Source**: Alejandro Vidal, "Agentic Engineering" (Rollback + Learnings) - HACKNIGHT Valencia 2026
**Updated**: 2026-03-10 | **Version**: 7.1.0
