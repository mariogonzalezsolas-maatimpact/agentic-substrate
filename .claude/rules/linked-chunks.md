# Linked Chunks Rule

When editing a file that contains `@linked` references (in comments), you MUST:

1. **Read all linked files first** before making changes
2. **Update linked docs** if your code change affects the documented behavior
3. **Never break a link** - if you rename or move a file, update all `@linked` references pointing to it

## @linked Syntax

```
// @linked docs/architecture.md
// @linked docs/prds/feature-v2.md#section-name
# @linked docs/security/auth.md
```

## Enforcement

If you edit a file with `@linked` references and don't read/update the linked files, the hawk hook will flag it.

## Why This Matters

Agents rely on heuristics (grep, naming conventions) to find relevant code. This leads to:
- Duplicating existing functionality instead of reusing it
- Missing critical context (security constraints, invariants)
- Breaking behavior documented elsewhere

`@linked` creates an explicit dependency graph that agents can follow deterministically.
