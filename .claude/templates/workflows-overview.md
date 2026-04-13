# Workflows Overview

## Universal Command: `/do`

Just say what you want -- `/do` classifies, plans, confirms, then executes using **pyramid orchestration** for all code-producing routes.

> **Powered by `pyramid-loop` skill** — Auto-invoked by `/do` for all code-producing routes. Manages the plan -> code -> review -> fix loop with max 3 iterations. See `.claude/skills/pyramid-loop/skill.md`.

### Full Pyramid Routes (plan-coordinator -> code-coordinator -> review-coordinator -> fix loop)

| Route | Coordinators | Gates |
|-------|-------------|-------|
| FEATURE | plan + code + review | Plan (85+) -> Tests Pass -> Review (80+) |
| IMPLEMENT | plan + code + review | Plan (85+) -> Tests Pass -> Review (80+) |
| MIGRATE | plan + code + review | Plan (85+) -> Tests Pass -> Review (80+) |
| ORCHESTRATE | plan + code + review | Plan (85+) -> Tests Pass -> Review (80+) |

### Agent Dispatch Routes (specialist agent per route)

All non-pyramid routes dispatch to a specialist agent. Each agent works in isolated context with its domain expertise. Users can upgrade to full pyramid with "con review" / "with review".

| Route | Agent | Gates |
|-------|-------|-------|
| REFACTOR | @programmer | Tests Pass |
| TEST | @testing-engineer | Tests Pass |
| DEBUG | @brahma-investigator | Root cause + fix |
| OPTIMIZE | @programmer | Tests Pass |
| CODE | @programmer | Tests Pass |
| DATABASE | @programmer | Tests Pass |
| TECH_DEBT | @programmer | Tests Pass |

### Direct Routes (specialist agent, no pyramid)

| Route | Executes | Gates |
|-------|----------|-------|
| RESEARCH | `@docs-researcher` | ResearchPack (80+) |
| PLAN | `@plan-coordinator` | Plan Score (85+) |
| DEPLOY | `@brahma-deployer` | Pre-deploy -> Post-deploy |
| MONITOR | `@brahma-monitor` | Three Pillars Configured |
| INCIDENT | `@brahma-investigator` + `@brahma-monitor` | Investigation -> Service Restored |
| ROLLBACK | Direct (git revert + verification) | Rollback Verified |
| REVIEW | `@review-coordinator` | Review Complete |
| SEO | `@seo-strategist` | Audit Delivered |
| SECURITY | `@security-auditor` | Audit Delivered |
| UX | `@ux-accessibility-reviewer` | Audit Delivered |
| RESPONSIVE | `@responsive-reviewer` | Audit Delivered |
| THEME | `@theme-reviewer` | Audit Delivered |
| I18N | `@i18n-reviewer` | Audit Delivered |
| ARCHITECTURE | `@software-architect` | Architecture Review Delivered |
| API | `@api-designer` | API Spec Delivered |
| TESTING | `@testing-engineer` | Tests Pass + Coverage Target |
| DEVOPS | `@devops-engineer` | Pipeline Operational |
| SECDEVOPS | `@secdevops-engineer` | Security Posture Delivered |
| BUSINESS | `@business-analyst` | Analysis Delivered |
| CONTENT | `@content-strategist` | Strategy Delivered |
| PRODUCT | `@product-strategist` | Strategy Delivered |
| CONTEXT | `/context` | None (utility command) |
| ORCHESTRATE | `@chief-architect` + pyramid | Per-phase gates |
| SIMPLE | Direct answer | None |

**Note**: FEATURE and ORCHESTRATE routes include a **brainstorming gate** before the pyramid. See `brainstorming-gate` skill. Opt out with "skip design" or "no brainstorm".

### Mandatory Plan Mode

Every `/do` invocation shows a plan and waits for confirmation before executing:
```
Route: [ROUTE]
Execution: Pyramid (plan -> code -> review) | Direct (@agent)
Gates: [applicable gates]
Plan: [numbered steps]
Proceed? (yes / modify / cancel)
```

No action is taken without user confirmation (except SIMPLE direct answers).

---

## Quality Gates System

@.claude/templates/quality-gates.md

### Gate Flow
```
Research (80+) -> Plan (85+) -> Analysis (80+) -> Tests Pass
```

If any gate FAILS, execution stops and the failure is reported with suggested fixes.

### Circuit Breaker
3 consecutive failures = STOP. Check: `/circuit-breaker status`. Reset: `/circuit-breaker reset`.

---

## Core Workflow: Pyramid Orchestration (v7.2)

@.claude/templates/pyramid-orchestration.md

| Phase | Coordinator | Time | Deliverable | Gate |
|-------|-------------|------|-------------|------|
| Plan | @plan-coordinator | <3 min | Research + Implementation Plan | Score >= 85 |
| Code | @code-coordinator | 5-25 min | Code + tests + commit | Tests pass |
| Review | @review-coordinator | 3-7 min | Code review + browser test | Score >= 80 |
| Fix (if needed) | plan + code + review | 5-15 min | Fixed code | Review PASS |

```bash
/do Add Redis caching          # Pyramid (plan -> code -> review)
/do Add Redis caching, simple  # Direct dispatch (no pyramid)
/research Redis for Node.js    # Research only (no pyramid)
```

### Legacy Workflow: Research -> Plan -> Implement

| Phase | Agent | Time | Deliverable | Gate |
|-------|-------|------|-------------|------|
| Research | docs-researcher | <2 min | ResearchPack | Score >= 80 |
| Plan | implementation-planner | <3 min | Implementation Plan | Score >= 85 |
| Analyze | brahma-analyzer | <2 min | Consistency Report | Score >= 80 |
| Implement | code-implementer | 5-25 min | Code + tests + commit | Tests pass |

Available via opt-out keywords: "simple", "sequential", "directo", "no pyramid"

---

## TDD Cycle (Mandatory)

**RED** (write failing test) -> **GREEN** (minimal code to pass) -> **REFACTOR** (improve quality). 6-10 min per feature unit.

---

## Engineering Patterns (NEW)

**Architecture -> API -> Database -> Implement**:
`@software-architect` -> `@api-designer` -> `@database-architect` -> `@code-implementer`

**Full-Stack Feature**: `@software-architect` -> `@api-designer` + `@database-architect` (parallel) -> `@programmer` -> `@testing-engineer`

**DevSecOps Pipeline**: `@devops-engineer` -> `@secdevops-engineer` -> `@brahma-deployer` -> `@brahma-monitor`

**Quality Review Suite**: Run `@responsive-reviewer` + `@theme-reviewer` + `@i18n-reviewer` + `@ux-accessibility-reviewer` in parallel

---

## Growth & Strategy Patterns

**SEO + Content**: `@seo-strategist` -> `@content-strategist` -> `@code-implementer` (15-25 min)

**Product Launch**: `@product-strategist` -> `@business-analyst` -> `@content-strategist` -> `@seo-strategist` (20-30 min)

**Security-First Deploy**: `@security-auditor` -> `@secdevops-engineer` -> `@brahma-deployer` -> `@brahma-monitor` (30-45 min)

**UX-Driven Dev**: `@ux-accessibility-reviewer` + `@responsive-reviewer` + `@theme-reviewer` -> `@implementation-planner` -> `@code-implementer` (20-30 min)

**Full Growth Audit**: Run `@seo-strategist` + `@ux-accessibility-reviewer` + `@security-auditor` + `@business-analyst` in parallel, then synthesize with `@product-strategist` (25-40 min)

---

## Session & Documentation Commands (NEW)

| Command | Purpose | When to Use |
|---------|---------|-------------|
| `/generate-docs` | Generate/migrate `.claude/` structure for any project (Spanish) | Starting a new project, onboarding AI to existing project |
| `/save-session` | Save session state for later resumption | Before ending work, approaching context limits |
| `/resume-session` | Load saved session and resume with full context | Starting new session to continue previous work |
| `/learn` | Extract reusable patterns from current session | After solving non-trivial problems |

---

## Context Management

Run `/context analyze` every 50 messages. `/context optimize` when switching tasks. `/context reset` for fresh start. (39% improvement, 84% token reduction)

---

**Updated**: 2026-04-13 | **Version**: 7.3.0 | **Routes**: 34 (4 full pyramid + 29 agent dispatch + 1 simple)
