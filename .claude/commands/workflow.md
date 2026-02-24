---
name: workflow
description: Complete Research → Plan → Implement workflow in one command. Shorthand for `/do [feature]` with FEATURE route.
---

# /workflow Command

> **Prefer `/do [feature]` instead.** This command is a shorthand that routes to `/do` with FEATURE classification. `/do` provides smarter routing, mandatory planning, and Agent Teams support.

## Usage

```
/workflow <feature description>
```

Equivalent to: `/do <feature description>`

## What This Does

Routes to `/do` with FEATURE classification, which executes:
1. **Research**: `@docs-researcher` -> ResearchPack (score >= 80)
2. **Plan**: `@implementation-planner` -> Implementation Plan (score >= 85)
3. **Implement**: `@code-implementer` -> Code + tests (TDD, 3-retry self-correction)
4. **Capture**: `pattern-recognition` skill -> knowledge-core.md

Quality gates enforced at each transition. See @.claude/templates/quality-gates.md

## Examples

```
/workflow Add Redis caching to product service with TTL
/workflow Implement JWT authentication middleware
/workflow Migrate database from SQLite to PostgreSQL
```

## Tips

- Be specific: "Add Redis caching to ProductService with 5-min TTL" (not "add caching")
- Include constraints: "Use JWT, not sessions" / "Must work with existing API"
- For parallel execution, use `/do [feature]` instead (Agent Teams by default)

---

**Executing command...**

Please invoke: `@chief-architect {args}`
