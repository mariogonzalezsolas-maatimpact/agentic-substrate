---
name: tech-debt
description: Continuous tech debt reduction. Scans the codebase for agent-introduced anti-patterns and addresses them before they propagate.
---

# /tech-debt Command

Continuous tech debt reduction. Scans the codebase for agent-introduced anti-patterns and addresses them before they propagate.

## Usage

```bash
/tech-debt [scope]        # Scan and fix tech debt
/tech-debt scan           # Scan only, report findings
/tech-debt fix [finding]  # Fix a specific finding
```

## What It Detects

### Agent Anti-Patterns (High Priority)
- Generic `try/catch` blocks with no specific error handling
- `test.skip` / disabled tests without justification
- Duplicate code blocks (same logic copy-pasted across files)
- `TODO` / `FIXME` comments added by agents without linked issues
- Error swallowing (catch + log + return generic response)

### Structural Debt
- Files with no test coverage that were recently modified
- Functions longer than 50 lines
- Circular dependencies between modules
- Dead code (unused exports, unreachable branches)

### Documentation Debt
- `@linked` references pointing to non-existent files
- Stale comments that contradict the current code behavior
- Missing documentation for public APIs

## Execution

Route: CODE
Agent: @programmer
Gates: Tests Pass (no regressions introduced)

The agent:
1. Scans the specified scope (or full project) for anti-patterns
2. Reports findings ranked by severity
3. On confirmation, fixes them one at a time with tests
4. Each fix is a separate, revertible commit

## Philosophy

> The faster you clean, the less the agent learns bad patterns.
> The less it learns bad patterns, the less debt it creates.
> -- Virtuous cycle

Tech debt reduction is not a sprint-end activity. It's continuous -- because agents copy what they observe in context.

## Hard Constraints (passed to agent)

```
- Don't write types before the implementation. Types must reflect actual runtime behavior.
- All logs must use structured format with correlation_id where available.
- Never swallow errors with generic try/catch.
- Before writing a new function, search for existing ones with similar intent.
```

---

**Source**: Alejandro Vidal, "Agentic Engineering" (Continuous Tech Debt Reduction) - HACKNIGHT Valencia 2026
**Updated**: 2026-03-10 | **Version**: 7.1.0
