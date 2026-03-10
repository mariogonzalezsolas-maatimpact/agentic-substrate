# Workflows Overview

## Universal Command: `/do`

Just say what you want -- `/do` classifies, plans, confirms, then executes:

| Route | Executes | Gates |
|-------|----------|-------|
| FEATURE | `/workflow` | Research (80+) -> Plan (85+) -> Tests Pass |
| REFACTOR | `@code-implementer` (refactor mode) | Tests Pass |
| TEST | `@code-implementer` (TDD mode) | Tests Pass |
| RESEARCH | `@docs-researcher` | ResearchPack (80+) |
| PLAN | `@implementation-planner` | Plan Score (85+) |
| IMPLEMENT | `@code-implementer` | Tests Pass |
| DEBUG | `@brahma-investigator` | Investigation -> Fix Verified |
| MIGRATE | `/workflow` (migration mode) | Research (80+) -> Plan (85+) -> Tests Pass |
| INCIDENT | `@brahma-investigator` + `@brahma-monitor` | Investigation -> Service Restored |
| ROLLBACK | Direct (git revert + verification) | Rollback Verified |
| DEPLOY | `@brahma-deployer` | Pre-deploy -> Post-deploy |
| OPTIMIZE | `@brahma-optimizer` | Baseline -> Improvement Verified |
| MONITOR | `@brahma-monitor` | Three Pillars Configured |
| REVIEW | `/review` | Review Complete |
| SEO | `@seo-strategist` | Audit Delivered |
| SECURITY | `@security-auditor` | Audit Delivered |
| UX | `@ux-accessibility-reviewer` | Audit Delivered |
| RESPONSIVE | `@responsive-reviewer` | Audit Delivered |
| THEME | `@theme-reviewer` | Audit Delivered |
| I18N | `@i18n-reviewer` | Audit Delivered |
| ARCHITECTURE | `@software-architect` | Architecture Review Delivered |
| CODE | `@programmer` | Tests Pass (if applicable) |
| DATABASE | `@database-architect` | Review/Migration Delivered |
| API | `@api-designer` | API Spec Delivered |
| TESTING | `@testing-engineer` | Tests Pass + Coverage Target |
| TECH_DEBT | `@programmer` (tech debt mode) | Tests Pass (no regressions) |
| DEVOPS | `@devops-engineer` | Pipeline Operational |
| SECDEVOPS | `@secdevops-engineer` | Security Posture Delivered |
| BUSINESS | `@business-analyst` | Analysis Delivered |
| CONTENT | `@content-strategist` | Strategy Delivered |
| PRODUCT | `@product-strategist` | Strategy Delivered |
| CONTEXT | `/context` | None (utility command) |
| ORCHESTRATE | `@chief-architect` | Per-phase gates |
| SIMPLE | Direct answer | None |

### Mandatory Plan Mode

Every `/do` invocation shows a plan and waits for confirmation before executing:
```
Route: [ROUTE]
Agent: [agent]
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

## Core Workflow: Research -> Plan -> Implement

| Phase | Agent | Time | Deliverable | Gate |
|-------|-------|------|-------------|------|
| Research | docs-researcher | <2 min | ResearchPack | Score >= 80 |
| Plan | implementation-planner | <3 min | Implementation Plan | Score >= 85 |
| Analyze | brahma-analyzer | <2 min | Consistency Report | Score >= 80 |
| Implement | code-implementer | 5-25 min | Code + tests + commit | Tests pass |

```bash
/do Add Redis caching          # Universal (recommended)
/workflow Add Redis caching     # Full automation
/research Redis for Node.js    # Manual step-by-step
```

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

## Context Management

Run `/context analyze` every 50 messages. `/context optimize` when switching tasks. `/context reset` for fresh start. (39% improvement, 84% token reduction)

---

**Updated**: 2026-03-10 | **Version**: 7.1.0 | **Routes**: 34
