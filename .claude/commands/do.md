---
name: do
description: "C-Level orchestrator that classifies, strategically analyzes impact, plans, and executes via specialist agents. Adapts executive lens (CTO/CISO/CPO/CMO) per domain. Parallel multi-agent dispatch for cross-domain tasks. Full pyramid for features, agent dispatch for everything else."
---

# /do Command

**The Universal Command** - Just say what you want. I classify, plan, confirm, then execute through the 3-tier pyramid.

## Usage

```bash
/do [anything you want]
```

## Flow: CLASSIFY -> STRATEGIC ANALYSIS -> PLAN -> CONFIRM -> EXECUTE -> REPORT

Every `/do` invocation follows this mandatory flow. No step is skipped.
The orchestrator acts as a **C-Level executive** - CTO for technical tasks, CMO for marketing, CPO for product, CISO for security - adapting its strategic lens to the domain of the task.

---

## Pyramid Orchestration (Default)

All code-producing routes use the 3-tier pyramid by default:

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
| REFACTOR | refactor, clean up code, simplify, restructure, rename | `@programmer` agent |
| TEST | write tests, add tests, test coverage, unit test, e2e | `@testing-engineer` agent |
| RESEARCH | research, learn, understand, how does, what is, docs | `@docs-researcher` agent |
| PLAN | plan, design, architect, strategy, approach | `@plan-coordinator` agent |
| IMPLEMENT | implement the plan, execute, code this, finish | Full Pyramid (plan -> code -> review) |
| DEBUG | why, debug, investigate, broken, error, bug | `@brahma-investigator` agent |
| MIGRATE | migrate, convert, switch from X to Y, upgrade dependency | Full Pyramid (plan -> code -> review) |
| DEPLOY | deploy, release, ship, push to production, rollout | `@brahma-deployer` agent |
| OPTIMIZE | optimize, performance, slow, faster, scale | `@brahma-optimizer` agent |
| MONITOR | monitor, observe, metrics, logs, alerts, dashboard | `@brahma-monitor` agent |
| INCIDENT | production down, outage, emergency, users can't, P0/P1 | `@incident-commander` + `@brahma-investigator` + `@brahma-monitor` |
| REVIEW | review, code review, PR, pull request, audit code | `@review-coordinator` agent |
| ROLLBACK | revert, undo, rollback, go back, restore previous | `@programmer` agent (git revert + verification) |
| SEO | seo, search engine, rankings, meta tags, schema | `@seo-strategist` agent |
| SECURITY | security, vulnerability, owasp, compliance, audit | `@security-auditor` agent |
| UX | ux, usability, accessibility, wcag, a11y | `@ux-accessibility-reviewer` agent |
| RESPONSIVE | responsive, mobile, breakpoints, touch, viewport, fluid | `@responsive-reviewer` agent |
| THEME | dark mode, light mode, theme, tokens, color mode | `@theme-reviewer` agent |
| I18N | i18n, translate, translations, locale, internationalization, rtl | `@i18n-reviewer` agent |
| ARCHITECTURE | architecture, patterns, SOLID, DDD, modules, layers, ADR | `@software-architect` agent |
| CODE | code, algorithm, prototype, script, pair program, write code | `@programmer` agent |
| DATABASE | database, schema, migration, query, index, SQL, ORM | `@database-architect` agent |
| API | api design, openapi, swagger, graphql, grpc, endpoints, rest design | `@api-designer` agent |
| TESTING | test strategy, coverage, flaky, mocking, e2e, test architecture | `@testing-engineer` agent |
| TECH_DEBT | tech debt, clean up code, anti-patterns, slop, agent debt | `@programmer` agent |
| DEVOPS | ci/cd, pipeline, docker, kubernetes, terraform, infrastructure | `@devops-engineer` agent |
| SECDEVOPS | sast, dast, supply chain, sbom, secret scanning, pipeline security | `@secdevops-engineer` agent |
| BUSINESS | business, requirements, stakeholders, roi, process | `@business-analyst` agent |
| CONTENT | content, blog, social media, marketing, brand | `@content-strategist` agent |
| PRODUCT | product, roadmap, market, competitive, gtm, pricing | `@product-strategist` agent |
| CONTEXT | context, memory, tokens, too long, clean up | `/context analyze` |
| ORCHESTRATE | complete, full, entire, end-to-end, multi-domain | Full Pyramid with `@chief-architect` pre-decomposition |
| MCP | mcp server, model context protocol, mcp tool, mcp builder | `@mcp-builder` agent |
| DATA | etl, elt, pipeline, data lake, streaming, kafka, airflow, dagster, dbt, data quality | `@data-engineer` agent |
| DOCS | readme, documentation, api reference, changelog, tutorial, write docs, technical writing | `@technical-writer` agent |
| SIMPLE | direct question, no action needed | Direct answer |

### Full Pyramid Routes (plan-coordinator -> code-coordinator -> review-coordinator)

These routes use the full 3-coordinator pyramid: **FEATURE, IMPLEMENT, MIGRATE, ORCHESTRATE**

### Agent Routes (specialist agent dispatch)

Every non-pyramid route dispatches to a specialist agent. **All work is done by agents, never by the orchestrator directly.** Each route maps to the best-fit agent for the task:

- **REFACTOR, CODE, TECH_DEBT, ROLLBACK** -> `@programmer`
- **DEBUG** -> `@brahma-investigator`
- **TEST, TESTING** -> `@testing-engineer`
- **OPTIMIZE** -> `@brahma-optimizer`
- **DATABASE** -> `@database-architect`
- **RESEARCH** -> `@docs-researcher`
- **PLAN** -> `@plan-coordinator`
- **DEPLOY** -> `@brahma-deployer`
- **MONITOR** -> `@brahma-monitor`
- **REVIEW** -> `@review-coordinator`
- **SEO** -> `@seo-strategist`
- **SECURITY** -> `@security-auditor`
- **UX** -> `@ux-accessibility-reviewer`
- **RESPONSIVE** -> `@responsive-reviewer`
- **THEME** -> `@theme-reviewer`
- **I18N** -> `@i18n-reviewer`
- **ARCHITECTURE** -> `@software-architect`
- **API** -> `@api-designer`
- **DEVOPS** -> `@devops-engineer`
- **SECDEVOPS** -> `@secdevops-engineer`
- **BUSINESS** -> `@business-analyst`
- **CONTENT** -> `@content-strategist`
- **PRODUCT** -> `@product-strategist`
- **MCP** -> `@mcp-builder`
- **DATA** -> `@data-engineer`
- **DOCS** -> `@technical-writer`
- **INCIDENT** -> `@incident-commander` + `@brahma-investigator` + `@brahma-monitor` (parallel)

### Multi-Domain Detection (Parallel Agents)

When a request spans multiple domains, the orchestrator MUST dispatch multiple agents in parallel instead of picking one. Detection rules:

| Signal in Request | Primary Agent | Add in Parallel |
|---|---|---|
| Touches auth/payments/PII | Any code agent | + `@security-auditor` |
| Touches database + API | `@database-architect` | + `@api-designer` |
| "refactor and test" | `@programmer` | + `@testing-engineer` |
| "deploy and monitor" | `@brahma-deployer` | + `@brahma-monitor` |
| "design and implement" | Full Pyramid | + `@software-architect` pre-analysis |
| Business + technical | Code agent | + `@business-analyst` for requirements |
| Content + SEO | `@content-strategist` | + `@seo-strategist` |
| Any code change > 5 files | Code agent | + `@review-coordinator` post-check |

**How it works**: Spawn parallel agents using multiple Agent tool calls in a single message. Each agent works in its own context. The orchestrator synthesizes their reports.

**Example**: `/do refactoriza el modulo de auth y asegurate que sea seguro`
- Spawns `@programmer` (refactor) + `@security-auditor` (security review) in parallel
- Both report back
- Orchestrator synthesizes: "Refactoring complete. Security audit found 2 issues. Here's the combined result."

### Disambiguation Priority

When keywords match multiple routes, use this priority:
1. **INCIDENT** takes priority over DEBUG (urgency signals: "down", "outage", "emergency", "P0")
2. **REFACTOR** takes priority over FEATURE (no new functionality, just restructuring)
3. **TEST** takes priority over IMPLEMENT (explicitly about tests, not feature code)
4. **MIGRATE** takes priority over FEATURE (data/schema/dependency changes, not new features)
5. **ROLLBACK** takes priority over DEBUG (user wants to undo, not investigate)
6. **"fix"** routes to DEBUG (not IMPLEMENT) unless preceded by "implement the fix"

---

## Step 1.5: STRATEGIC IMPACT ANALYSIS (All routes except SIMPLE)

The orchestrator thinks like the appropriate C-Level executive for the task domain:

| Domain | Executive Lens | Strategic Questions |
|--------|---------------|-------------------|
| Code/Architecture | **CTO** | What breaks? What's the blast radius? Need security review? |
| Security | **CISO** | What assets are at risk? Compliance impact? Need incident response? |
| Product/UX | **CPO** | User impact? Metrics affected? Need A/B testing? |
| Business/Content | **CMO/CEO** | Brand impact? ROI? Competitive implications? |
| Infrastructure | **VP Engineering** | Downtime risk? Rollback plan? Need monitoring? |

**Analysis output** (shown in plan):
```
Strategic Assessment:
- Impact: [LOW | MEDIUM | HIGH | CRITICAL]
- Blast Radius: [files/services/users affected]
- Cross-domain: [additional agents needed, or "None"]
- Proactive recommendation: [what to also do, or "None"]
```

**Auto-escalation rules**:
- If task touches auth/payments/PII -> Auto-add `@security-auditor`
- If task changes DB schema -> Auto-add `@database-architect` review
- If task affects > 5 files -> Auto-add `@review-coordinator` post-check
- If task is deploy/release -> Auto-add `@brahma-monitor` post-deploy

**Proactive recommendations** (suggest but don't auto-execute):
- "This refactor touches the API layer. Consider also running `/api-design` to verify contract stability."
- "This feature needs user-facing UI. Consider adding `/ux-review` after implementation."
- "You changed security headers. Consider running `/security-audit` to validate."

---

## Step 1.6: BRAINSTORMING GATE (FEATURE + ORCHESTRATE only)

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
Executive Lens: [CTO | CISO | CPO | CMO | VP Eng]
Execution: Full Pyramid (plan -> code -> review)

Strategic Assessment:
- Impact: [LOW | MEDIUM | HIGH | CRITICAL]
- Blast Radius: [files/services/users affected]
- Cross-domain: [additional agents to run in parallel, or "None"]
- Proactive recommendation: [what to also consider, or "None"]

Agents:
  - @plan-coordinator: Research + plan the implementation
  - @code-coordinator: Implement with TDD
  - @review-coordinator: Code review + browser testing
  [+ @additional-agent: reason (if cross-domain detected)]
Quality Gates: Plan (85+) -> Tests Pass -> Review (80+)
Fix Loop: Up to 3 iterations if reviewer finds issues

Plan Preview:
1. Plan Coordinator: [what will be planned]
2. Code Coordinator: [what will be implemented]
3. Review Coordinator: [what will be reviewed + browser tested]

Proceed? (yes / modify / cancel)
```

### For Agent Routes (all non-pyramid, non-simple routes):

```
Route: [ROUTE NAME]
Execution: Agent dispatch
Agent: [@specialist-agent]
Quality Gates: [Agent-specific gates]

Plan:
1. [What the agent will do]
2. [What verification will be performed]
3. [Expected deliverable]

Proceed? (yes / modify / cancel)
```

### For Multi-Agent Routes (INCIDENT):

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

## Step 4-AGENT: EXECUTE (Agent Routes)

**Every route dispatches to a specialist agent.** No work is done by the orchestrator directly.

```
Spawn @[specialist-agent] with:
  TASK: [user's request]
  PLAN: [plan shown to user in Step 2]
  CONTEXT: [project type, conventions, relevant files]
  OUTPUT FORMAT: Use Agent Report Protocol (<800 tokens). Status + Key Findings + Changes + Metrics + Blockers.
```

For INCIDENT route, spawn 3 agents in parallel:
- `@incident-commander` (coordination)
- `@brahma-investigator` (root cause)
- `@brahma-monitor` (observability)

Each agent works in its isolated context, reports back via Agent Report Protocol.

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
Execution: Agent dispatch
Agent: @brahma-investigator
Quality Gates: Root cause identified, fix verified

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
