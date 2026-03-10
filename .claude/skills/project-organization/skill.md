---
name: project-organization
description: "Use when starting a new project, onboarding onto an existing codebase, or when agents struggle to find files, duplicate code, or repeatedly re-explore the same areas. Also use when the user says 'organize', 'restructure', 'make agent-friendly', or 'set up docs'."
auto_invoke: false
tags: [organization, onboarding, navigation, documentation, structure]
---

# Project Organization Skill

Organize any codebase so AI agents can navigate it in <30 seconds, find existing code instead of duplicating it, and verify their own work.

**Core principle:** Agents lose effectiveness when they can't find things. Good organization = good agent performance. Documentation is not for humans reading later — it's for agents reading NOW.

## When Claude Should Use This Skill

Claude will invoke this skill when:
- User says "organize", "restructure", "make agent-friendly", "set up docs"
- Starting a new project for AI-assisted development
- Onboarding onto an existing codebase that lacks structure
- Agents keep re-exploring the same directories or duplicating files

**Do NOT invoke when:**
- The project already has solid CLAUDE.md + docs/ structure
- Mid-implementation (would interrupt workflow)
- Single-file tasks that don't need structural changes

## The 6 Pillars

### Pillar 1: CLAUDE.md as Navigation Map

CLAUDE.md should orient an agent in <30 seconds. Keep it high-level — point to docs/ for details.

**Must include:**

```markdown
## Where to Find What

| What | Where |
|------|-------|
| UI components | `src/components/` |
| Pages/routes | `src/pages/` |
| Business logic | `src/services/` |
| API/backend | `api/` → see `docs/api.md` |
| Database schema | `docs/database.md` |
| Utility scripts | `scripts/` → organized by domain |
| Learnings | `docs/learnings/` |
| Cross-session context | `.claude/scratchpad.md` |
```

**Also include:** dev commands (build, test, lint, deploy), architecture overview (1 paragraph), key patterns.

**Do NOT include:** detailed API docs, full schema, long examples. Those go in `docs/`.

### Pillar 2: Structured Documentation in docs/

Create an index for every area agents repeatedly explore:

```
docs/
├── api.md              ← Index of all API endpoints with 1-line descriptions
├── database.md         ← Tables, columns, relationships, triggers
├── architecture.md     ← Detailed architecture (if too long for CLAUDE.md)
└── learnings/          ← Documented mistakes and lessons
    └── incident-name.md
```

**api.md pattern:** Group by domain (auth, payments, notifications), not alphabetically.

```markdown
## Auth
- **`POST /auth/login`** — Authenticate user, return JWT
- **`POST /auth/refresh`** — Refresh expired token

## Payments
- **`POST /payments`** — Create payment intent
- **`GET /payments/:id`** — Get payment status
```

**database.md pattern:**

```markdown
## users
Purpose: Core user accounts.
- `id`, `email`, `name`, `created_at`, `updated_at`
- Related to: `orders` via `user_id`, `sessions` via `user_id`
```

### Pillar 3: Scratchpad Pattern

Create `.claude/scratchpad.md` — rewrite (not append) at session start/end.

```markdown
# Scratchpad — [Project Name]

> Rewrite this file at session start. Do not append.
> Last updated: YYYY-MM-DD

## Current State
- What's deployed, what's in progress

## Recent Decisions
- Key decisions made in last few sessions

## Known Issues
- Active bugs or warnings

## In Progress
- Current tasks and their status
```

**Add to CLAUDE.md:**
```markdown
## Scratchpad
Read `.claude/scratchpad.md` at session start for context. Update it at session end.
```

### Pillar 4: Scripts Organization

Move scripts from flat root into semantic subcategories:

```
scripts/
├── images/     ← generate-*, optimize-*, convert-*
├── data/       ← backfill-*, fix-*, clean-*, upload-*, migrate-*
├── testing/    ← test-*, debug-*, *-debug.*
├── email/      ← email-related scripts
├── analytics/  ← metrics, screenshots, reports
└── archived/   ← old scripts kept for reference
```

**Before moving:** verify no script imports another with relative paths. If they do, update paths.

**Naming:** Use descriptive verb-first names (`generate-hero-images.cjs` not `imgs.js`).

### Pillar 5: Feedback Loops

Agents need automated verification. At minimum, a pre-commit hook:

```bash
#!/bin/sh
# .git/hooks/pre-commit
echo "Running build check..."
npm run build 2>&1
if [ $? -ne 0 ]; then
  echo "Build failed. Fix errors before committing."
  exit 1
fi
```

**Other feedback loops to consider:**
- Lint on save (editor integration)
- Type-check on file change
- Test suite in CI on push
- Deploy preview on PR

**Key insight:** "Ralph only works if there are feedback loops." Without automated checks, agents commit broken code and compound errors across iterations.

### Pillar 6: Learnings as Documentation

Every significant mistake becomes a doc in `docs/learnings/`:

```markdown
# Learning: Short Description (YYYY-MM-DD)

## Incident
What happened, what broke.

## Root Cause
Why it happened — the actual technical cause.

## Lesson
What to do differently. Concrete, actionable rules.

## See Also
- Link to relevant skill or doc
```

**When to create a learning:**
- An error caused downtime or data loss
- The same mistake has happened twice
- The fix was non-obvious and took significant debugging
- A pattern violation caused cascading failures

## Execution Protocol

When organizing a project, follow this exact order:

### Step 1: Explore
- Understand current structure (dirs, file counts, patterns)
- Identify what's scattered, duplicated, or hard to find
- Note existing docs, CLAUDE.md, scripts

### Step 2: Create docs/
- Start with `api.md` and `database.md`
- Index by domain, not alphabetically
- Include only what agents need to navigate

### Step 3: Rewrite CLAUDE.md
- Add "Where to Find What" navigation table
- Simplify to high-level pointers (details in docs/)
- Include dev commands and key patterns

### Step 4: Create Scratchpad
- `.claude/scratchpad.md` with current state
- Configure rewrite-not-append discipline

### Step 5: Reorganize Scripts
- Move into semantic subcategories
- Verify no broken relative imports
- Use verb-first naming

### Step 6: Add Feedback Loop
- Pre-commit hook at minimum
- Configure CI checks if applicable

### Step 7: Verify
- Run build, check nothing broke
- Verify agent can find key files quickly

### Step 8: Commit
- Commit to non-main branch
- Verify in CI before merging

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Putting everything in CLAUDE.md | Keep CLAUDE.md as index, details in docs/ |
| Appending to scratchpad indefinitely | Rewrite each session, not append |
| Organizing by file type (*.sql, *.js) | Organize by domain/purpose (data/, testing/) |
| Documenting only for humans | Write for agents — be explicit about paths and names |
| No feedback loop | At minimum: pre-commit hook with build |
| Learnings only in memory | Write them in docs/learnings/ so all agents benefit |

## Key Principles

1. **"Constraints are more effective than instructions"** — "No TODOs, no partial implementations" works better than "please write complete code"
2. **"Tooling extends intelligence"** — Better tools and organization make the same agent dramatically more effective
3. **"Modular architecture enables agent parallelism"** — Self-contained modules let multiple agents work without conflicts
4. **"Agents duplicate when they can't find"** — The #1 cause of file duplication is poor discoverability
5. **"Scratchpads should be rewritten, not appended"** — Append-only context grows stale and misleading

## Quality Checklist

Before marking organization complete:

- [ ] CLAUDE.md has "Where to Find What" navigation table
- [ ] CLAUDE.md is high-level (< 100 lines of project-specific content)
- [ ] docs/ exists with api.md and/or database.md indexes
- [ ] Scripts are organized by domain in subcategories
- [ ] .claude/scratchpad.md exists with current state
- [ ] At least one feedback loop is configured (pre-commit hook)
- [ ] docs/learnings/ directory exists for future incident docs
- [ ] Build passes after reorganization
- [ ] No broken imports from file moves
