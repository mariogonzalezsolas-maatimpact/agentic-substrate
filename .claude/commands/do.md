---
name: do
description: Intelligent command router with mandatory planning. Analyzes your request, shows a plan, waits for confirmation, then executes using 3-tier pyramid orchestration (plan -> code -> review -> fix loop).
---

# /do Command

**The Universal Command** - Just say what you want. I classify, plan, confirm, then execute through the 3-tier pyramid.

## Usage

```bash
/do [anything you want]
```

## Flow: CLASSIFY -> PLAN -> CONFIRM -> PYRAMID EXECUTE -> REPORT

Every `/do` invocation follows this mandatory flow. No step is skipped.

---

## Pyramid Orchestration (Default)

All code-producing routes use the 3-tier pyramid by default:

@.claude/templates/pyramid-orchestration.md

```
Tier 1: Orchestrator (this thread) -- classifies, dispatches, synthesizes
Tier 2: plan-coordinator -> code-coordinator -> review-coordinator
Tier 3: Coordinators handle their specialties internally
```

The review-coordinator can trigger a **fix loop** back to plan-coordinator (max 3 iterations).

**Opt-out keywords** (use direct agent dispatch instead):
- "simple", "sequential", "sin equipo", "no pyramid", "directo", "solo", "single agent"

---

## Step 0: Context Discovery (First Use Only)

On first `/do` of the session, gather project context in parallel:

1. Find CLAUDE.md (`./CLAUDE.md`, `./.claude/CLAUDE.md`)
2. Detect project type (package.json, Cargo.toml, go.mod, requirements.txt)
3. Find existing artifacts (ResearchPack, ImplementationPlan, knowledge-core.md)
4. Check circuit breaker state (`~/.claude/.circuit-breaker-state`)

Report:
```
Project: [name] | Type: [stack] | Artifacts: [list or None] | Circuit Breaker: [CLOSED/OPEN]
```

---

## Step 1: CLASSIFY

Analyze the request and assign exactly one route:

| Route | Keywords / Signals | Executes |
|-------|-------------------|----------|
| FEATURE | add, create, build, make, develop, new feature | Full Pyramid (plan -> code -> review) |
| REFACTOR | refactor, clean up code, simplify, restructure, rename | Lightweight (@programmer) |
| TEST | write tests, add tests, test coverage, unit test, e2e | Lightweight (@programmer) |
| RESEARCH | research, learn, understand, how does, what is, docs | `@docs-researcher` (no pyramid) |
| PLAN | plan, design, architect, strategy, approach | `@plan-coordinator` (plan only) |
| IMPLEMENT | implement the plan, execute, code this, finish | Full Pyramid (plan -> code -> review) |
| DEBUG | why, debug, investigate, broken, error, bug | Lightweight (@programmer) |
| MIGRATE | migrate, convert, switch from X to Y, upgrade dependency | Full Pyramid (plan -> code -> review) |
| DEPLOY | deploy, release, ship, push to production, rollout | `@brahma-deployer` |
| OPTIMIZE | optimize, performance, slow, faster, scale | Lightweight (@programmer) |
| MONITOR | monitor, observe, metrics, logs, alerts, dashboard | `@brahma-monitor` |
| INCIDENT | production down, outage, emergency, users can't, P0/P1 | `@incident-commander` + `@brahma-investigator` + `@brahma-monitor` |
| REVIEW | review, code review, PR, pull request, audit code | `@review-coordinator` (review only) |
| ROLLBACK | revert, undo, rollback, go back, restore previous | Direct (git revert + verification) |
| SEO | seo, search engine, rankings, meta tags, schema | `@seo-strategist` |
| SECURITY | security, vulnerability, owasp, compliance, audit | `@security-auditor` |
| UX | ux, usability, accessibility, wcag, a11y | `@ux-accessibility-reviewer` |
| RESPONSIVE | responsive, mobile, breakpoints, touch, viewport, fluid | `@responsive-reviewer` |
| THEME | dark mode, light mode, theme, tokens, color mode | `@theme-reviewer` |
| I18N | i18n, translate, translations, locale, internationalization, rtl | `@i18n-reviewer` |
| ARCHITECTURE | architecture, patterns, SOLID, DDD, modules, layers, ADR | `@software-architect` |
| CODE | code, algorithm, prototype, script, pair program, write code | Lightweight (@programmer) |
| DATABASE | database, schema, migration, query, index, SQL, ORM | Lightweight (@programmer) |
| API | api design, openapi, swagger, graphql, grpc, endpoints, rest design | `@api-designer` |
| TESTING | test strategy, coverage, flaky, mocking, e2e, test architecture | `@testing-engineer` |
| TECH_DEBT | tech debt, clean up code, anti-patterns, slop, agent debt | Lightweight (@programmer) |
| DEVOPS | ci/cd, pipeline, docker, kubernetes, terraform, infrastructure | `@devops-engineer` |
| SECDEVOPS | sast, dast, supply chain, sbom, secret scanning, pipeline security | `@secdevops-engineer` |
| BUSINESS | business, requirements, stakeholders, roi, process | `@business-analyst` |
| CONTENT | content, blog, social media, marketing, brand | `@content-strategist` |
| PRODUCT | product, roadmap, market, competitive, gtm, pricing | `@product-strategist` |
| CONTEXT | context, memory, tokens, too long, clean up | `/context analyze` |
| ORCHESTRATE | complete, full, entire, end-to-end, multi-domain | Full Pyramid with `@chief-architect` pre-decomposition |
| MCP | mcp server, model context protocol, mcp tool, mcp builder | `@mcp-builder` |
| DATA | etl, elt, pipeline, data lake, streaming, kafka, airflow, dagster, dbt, data quality | `@data-engineer` |
| DOCS | readme, documentation, api reference, changelog, tutorial, write docs, technical writing | `@technical-writer` |
| SIMPLE | direct question, no action needed | Direct answer |

### Full Pyramid Routes (plan-coordinator -> code-coordinator -> review-coordinator)

These routes use the full 3-coordinator pyramid: **FEATURE, IMPLEMENT, MIGRATE, ORCHESTRATE**

### Lightweight Routes (@programmer direct dispatch)

These routes skip the 3-coordinator pyramid and dispatch directly to @programmer for efficiency. They still require a plan shown to the user, but execution is a single agent, not 3 sequential coordinators: **REFACTOR, TEST, DEBUG, OPTIMIZE, CODE, DATABASE, TECH_DEBT**

Lightweight routes are faster and cheaper (1 agent call vs 3+). The user can upgrade any lightweight route to full pyramid by adding "con review" / "with review".

### Direct Routes (no pyramid)

These routes dispatch to a specialist directly: **RESEARCH, PLAN, DEPLOY, MONITOR, INCIDENT, REVIEW, ROLLBACK, SEO, SECURITY, UX, RESPONSIVE, THEME, I18N, ARCHITECTURE, API, TESTING, DEVOPS, SECDEVOPS, BUSINESS, CONTENT, PRODUCT, MCP, DATA, DOCS, CONTEXT, SIMPLE**

### Disambiguation Priority

When keywords match multiple routes, use this priority:
1. **INCIDENT** takes priority over DEBUG (urgency signals: "down", "outage", "emergency", "P0")
2. **REFACTOR** takes priority over FEATURE (no new functionality, just restructuring)
3. **TEST** takes priority over IMPLEMENT (explicitly about tests, not feature code)
4. **MIGRATE** takes priority over FEATURE (data/schema/dependency changes, not new features)
5. **ROLLBACK** takes priority over DEBUG (user wants to undo, not investigate)
6. **"fix"** routes to DEBUG (not IMPLEMENT) unless preceded by "implement the fix"

---

## Step 1.5: BRAINSTORMING GATE (FEATURE + ORCHESTRATE only)

For FEATURE and ORCHESTRATE routes, a mandatory design-approval phase runs BEFORE the plan:

**Invokes**: `brainstorming-gate` skill

```
1. Context exploration (read relevant files, identify integration points)
2. Clarifying questions (one at a time, max 3-4, multiple-choice preferred)
3. Design proposals (2-3 approaches with tradeoffs + recommendation)
4. User selects approach
5. Full design presented for approval
6. Spec document written to docs/specs/[feature].md
7. Spec self-review (placeholders, consistency, scope, ambiguity)
```

**Opt-out keywords**: "skip design", "no brainstorm", "just code it", "sin diseno"
**Skip conditions**: Spec already exists for this feature | Fix iteration > 1 | Bug fix or refactor

After brainstorming completes, the spec is passed to plan-coordinator as additional context.

---

## Step 2: PLAN (Mandatory)

**Always show a plan before executing. No exceptions.**

### For Full Pyramid Routes (FEATURE, IMPLEMENT, MIGRATE, ORCHESTRATE):

```
Route: [ROUTE NAME]
Execution: Full Pyramid (plan -> code -> review)
Coordinators:
  - @plan-coordinator: Research + plan the implementation
  - @code-coordinator: Implement with TDD
  - @review-coordinator: Code review + browser testing
Quality Gates: Plan (85+) -> Tests Pass -> Review (80+)
Fix Loop: Up to 3 iterations if reviewer finds issues
Spec: [docs/specs/feature.md if brainstorming gate ran, or "Skipped"]

Plan Preview:
1. Plan Coordinator: [what will be planned]
2. Code Coordinator: [what will be implemented]
3. Review Coordinator: [what will be reviewed + browser tested]

Proceed? (yes / modify / cancel)
```

### For Lightweight Routes (REFACTOR, TEST, DEBUG, OPTIMIZE, CODE, DATABASE, TECH_DEBT):

```
Route: [ROUTE NAME]
Execution: Lightweight (@programmer direct)
Agent: @programmer
Quality Gates: Tests Pass
Review: Optional (add "con review" / "with review" to upgrade)

Plan:
1. [What will be changed]
2. [What tests will be written/verified]
3. [Expected outcome]

Proceed? (yes / modify / cancel)
```

### For Direct Routes:

```
Route: [ROUTE NAME]
Agent: [specialist agent]
Quality Gates: [gates for this route]

Plan:
1. [First action]
2. [Second action]
3. [Expected deliverable]

Proceed? (yes / modify / cancel)
```

### Agentic Interviewing (Complex Tasks)

For FEATURE and ORCHESTRATE routes with ambiguous requirements, use structured multi-choice questions before planning:

1. Identify ambiguities in the request
2. Present 2-3 focused questions with concrete options
3. Use answers to refine the plan
4. Then present the refined plan for confirmation

### Smart Shortcuts
- If ResearchPack already exists -> plan-coordinator skips research
- If Implementation Plan exists -> skip to code-coordinator
- If circuit breaker OPEN -> refuse pyramid, suggest diagnostics

---

## Step 3: CONFIRM

Wait for user confirmation before executing:
- **yes** / **y** / **proceed**: Execute the plan
- **modify**: User adjusts the plan, re-present
- **cancel**: Abort, no action taken
- **No response needed for SIMPLE route**: Direct answers execute immediately

---

## Step 4: EXECUTE (Pyramid)

For pyramid routes, use the pyramid-loop skill:

### 4.1: Dispatch Plan Coordinator
```
Spawn @plan-coordinator with:
  TASK: [user's request]
  CONTEXT: [project info, relevant files]
  ITERATION: 1
  OUTPUT FORMAT: Use Agent Report Protocol (<800 tokens). Status + Key Findings + Changes + Metrics + Blockers.
```
Receive Plan Coordinator Report. Verify plan score >= 85.

### 4.2: Dispatch Code Coordinator
```
Spawn @code-coordinator with:
  PLAN: [full plan from plan-coordinator]
  CONTEXT: [project conventions]
  ITERATION: 1
  OUTPUT FORMAT: Use Agent Report Protocol (<800 tokens). Status + Key Findings + Changes + Metrics + Blockers.
```
Receive Code Coordinator Report. Verify tests pass.

### 4.3: Dispatch Review Coordinator
```
Spawn @review-coordinator with:
  CHANGES: [changed files]
  PLAN: [original plan summary]
  COMMIT: [git hash]
  PROJECT TYPE: [stack]
  ITERATION: 1
  OUTPUT FORMAT: Use Agent Report Protocol (<800 tokens). Status + Key Findings + Changes + Metrics + Blockers.
```
Receive Review Coordinator Report.

### 4.4: Evaluate Review Verdict

**PASS** -> Go to Step 5.

**FAIL (iteration < 3)** -> Send review findings to @plan-coordinator as fix request -> repeat 4.2 -> 4.3 -> 4.4.

**FAIL (iteration = 3)** -> Report all findings to user, suggest manual intervention.

---

## Step 4-LITE: EXECUTE (Lightweight Routes)

For lightweight routes (REFACTOR, TEST, DEBUG, OPTIMIZE, CODE, DATABASE, TECH_DEBT):

Spawn @programmer directly with the plan. No coordinator chain needed.
The programmer implements, tests, and commits in a single agent session.
Review is optional (user can request with "con review" / "with review").

```
Spawn @programmer with:
  TASK: [user's request]
  PLAN: [plan shown to user in Step 2]
  CONTEXT: [project type, conventions, relevant files]
  OUTPUT FORMAT: Use Agent Report Protocol (<800 tokens). Status + Key Findings + Changes + Metrics + Blockers.
```

If user requested review, dispatch @review-coordinator after @programmer completes.

---

## Step 4-ALT: EXECUTE (Direct Routes)

For non-pyramid routes, dispatch directly to the specialist agent and wait for their Agent Report.

---

## Step 5: REPORT

After execution completes, present results:

### For Pyramid Routes:
```
## Pyramid Execution Report

Task: [original request]
Iterations: [1-3]
Final Verdict: [PASS | FAIL (escalated)]

Plan: [score/100] | Code: [tests pass] | Review: [score/100]

Changes Made:
- file1.ext: [summary]
- file2.ext: [summary]

Commit: [hash] | Rollback: `git revert [hash]`

Want details on any phase? (plan / code / review)
```

### For Direct Routes:
Present the specialist agent's report with:
- Key findings (top 3)
- Changes made (file list)
- Quality gate results
- Offer drill-down

---

## Examples

**User**: `/do add authentication to my API`
```
Route: FEATURE
Execution: Pyramid (plan -> code -> review)
Coordinators:
  - @plan-coordinator: Research auth options, plan middleware + routes
  - @code-coordinator: Implement auth with TDD
  - @review-coordinator: Security review + test auth flow in browser
Quality Gates: Plan (85+) -> Tests Pass -> Review (80+)
Fix Loop: Up to 3 iterations

Proceed?
```

**User**: `/do why is the login failing?`
```
Route: DEBUG
Execution: Lightweight (@programmer direct)
Agent: @programmer
Quality Gates: Tests Pass
Review: Optional (add "con review" to upgrade)

Plan:
1. Investigate root cause in auth flow
2. Implement fix with regression test
3. Verify all existing tests pass

Proceed?
```

**User**: `/do research Redis caching`
```
Route: RESEARCH
Agent: @docs-researcher (direct, no pyramid)
Gates: ResearchPack (80+)

Plan:
1. Fetch Redis docs for detected version
2. Extract key APIs, setup, gotchas
3. Deliver ResearchPack

Proceed?
```

**User**: `/do what is this function?`
```
Route: SIMPLE
[Direct answer provided immediately, no confirmation needed]
```

---

## Context Commands

```bash
/do continue          # Resume from where we left off
/do what's the context?  # Show current project state
/do clean up context     # Runs /context optimize
/do start fresh          # Runs /context reset
```
