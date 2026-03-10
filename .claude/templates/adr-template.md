# ADR Template

Standard template for Architecture Decision Records. Used by @software-architect and `/architecture` command.

---

## Format

```markdown
# ADR-[N]: [Short Title]

## Status

[Proposed | Accepted | Deprecated | Superseded by ADR-X]

## Date

[YYYY-MM-DD]

## Context

[2-4 sentences describing the situation, the problem, and the forces at play.
What is the current state? Why does a decision need to be made?
What constraints exist? What quality attributes are most important?]

## Options Considered

### Option A: [Name]
- **Pros**: [benefit 1], [benefit 2]
- **Cons**: [trade-off 1], [trade-off 2]
- **Fit**: [score 1-5] for [quality attribute]

### Option B: [Name]
- **Pros**: [benefit 1], [benefit 2]
- **Cons**: [trade-off 1], [trade-off 2]
- **Fit**: [score 1-5] for [quality attribute]

### Option C: [Name] (if applicable)
- **Pros**: [benefit 1], [benefit 2]
- **Cons**: [trade-off 1], [trade-off 2]
- **Fit**: [score 1-5] for [quality attribute]

## Decision

[Which option was chosen and WHY. 2-3 sentences focusing on the reasoning,
not just "we chose Option A". Explain the key factor that tipped the decision.]

## Consequences

### Positive
- [Concrete benefit 1]
- [Concrete benefit 2]

### Negative
- [Concrete trade-off 1]
- [Concrete trade-off 2]

### Risks
- [Risk 1] → **Mitigation**: [how to address if it materializes]
- [Risk 2] → **Mitigation**: [how to address if it materializes]

## Reversal Plan

[How to reverse this decision if needed. What would trigger reversal?
What is the cost/effort of reversal? Is there a point of no return?]

## Related ADRs

- [ADR-X: Related decision] (if applicable)
```

---

## Guidelines

1. **Keep it short**: ADRs should be 1-2 pages max
2. **Focus on WHY**: The decision is less important than the reasoning
3. **Document trade-offs explicitly**: Every option has downsides
4. **Include reversal plan**: No decision should feel permanent
5. **Date everything**: Context changes over time
6. **Link related ADRs**: Decisions form a chain of reasoning

## Naming Convention

- `ADR-001-use-postgresql.md`
- `ADR-002-adopt-clean-architecture.md`
- `ADR-003-switch-to-graphql.md`

Store in: `docs/adr/` or `architecture/decisions/`

---

**Updated**: 2026-03-10 | **Version**: 7.1.0
