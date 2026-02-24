---
name: do
description: Intelligent command router with mandatory planning. Analyzes your request, shows a plan, waits for confirmation, then executes. Auto-gathers context on first use.
---

# /do Command

**The Universal Command** - Just say what you want. I classify, plan, confirm, then execute.

## Usage

```bash
/do [anything you want]
```

## Flow: CLASSIFY -> PLAN -> CONFIRM -> EXECUTE -> REPORT

Every `/do` invocation follows this mandatory flow. No step is skipped.

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
| FEATURE | add, create, build, make, develop, new feature | `/workflow` (research -> plan -> implement) |
| REFACTOR | refactor, clean up code, simplify, restructure, rename | `@code-implementer` (refactor mode) |
| TEST | write tests, add tests, test coverage, unit test, e2e | `@code-implementer` (TDD mode) |
| RESEARCH | research, learn, understand, how does, what is, docs | `@docs-researcher` |
| PLAN | plan, design, architect, strategy, approach | `@implementation-planner` |
| IMPLEMENT | implement the plan, execute, code this, finish | `@code-implementer` |
| DEBUG | why, debug, investigate, broken, error, bug | `@brahma-investigator` |
| MIGRATE | migrate, convert, switch from X to Y, upgrade dependency | `/workflow` (migration mode) |
| DEPLOY | deploy, release, ship, push to production, rollout | `@brahma-deployer` |
| OPTIMIZE | optimize, performance, slow, faster, scale | `@brahma-optimizer` |
| MONITOR | monitor, observe, metrics, logs, alerts, dashboard | `@brahma-monitor` |
| INCIDENT | production down, outage, emergency, users can't, P0/P1 | `@brahma-investigator` + `@brahma-monitor` |
| REVIEW | review, code review, PR, pull request, audit code | `/review` |
| ROLLBACK | revert, undo, rollback, go back, restore previous | Direct (git revert + verification) |
| SEO | seo, search engine, rankings, meta tags, schema | `@seo-strategist` |
| SECURITY | security, vulnerability, owasp, compliance, audit | `@security-auditor` |
| UX | ux, usability, accessibility, wcag, a11y | `@ux-accessibility-reviewer` |
| BUSINESS | business, requirements, stakeholders, roi, process | `@business-analyst` |
| CONTENT | content, blog, social media, marketing, brand | `@content-strategist` |
| PRODUCT | product, roadmap, market, competitive, gtm, pricing | `@product-strategist` |
| CONTEXT | context, memory, tokens, too long, clean up | `/context analyze` |
| ORCHESTRATE | complete, full, entire, end-to-end, multi-domain | `@chief-architect` |
| SIMPLE | direct question, no action needed | Direct answer |

### Disambiguation Priority

When keywords match multiple routes, use this priority:
1. **INCIDENT** takes priority over DEBUG (urgency signals: "down", "outage", "emergency", "P0")
2. **REFACTOR** takes priority over FEATURE (no new functionality, just restructuring)
3. **TEST** takes priority over IMPLEMENT (explicitly about tests, not feature code)
4. **MIGRATE** takes priority over FEATURE (data/schema/dependency changes, not new features)
5. **ROLLBACK** takes priority over DEBUG (user wants to undo, not investigate)
6. **"fix"** routes to DEBUG (not IMPLEMENT) unless preceded by "implement the fix"

### Skill-to-Route Mapping

| Route | Agent | Auto-Invoked Skills |
|-------|-------|-------------------|
| FEATURE | `/workflow` | research-methodology, planning-methodology, quality-validation, pattern-recognition |
| RESEARCH | `@docs-researcher` | research-methodology, quality-validation |
| PLAN | `@implementation-planner` | planning-methodology, quality-validation |
| IMPLEMENT | `@code-implementer` | pattern-recognition (on success) |
| DEBUG | `@brahma-investigator` | quality-validation |
| REFACTOR | `@code-implementer` | pattern-recognition (on success) |
| TEST | `@code-implementer` | (none) |
| MIGRATE | `/workflow` | research-methodology, planning-methodology, quality-validation |

### Complexity Detection
- **Simple** (1-2 files): Direct execution, minimal plan
- **Medium** (3-5 files): Agent Team (default) or sequential workflow
- **Complex** (6+ files, multi-domain): Agent Team with `@chief-architect` orchestration

### Agent Teams (Default for FEATURE/IMPLEMENT/ORCHESTRATE)

**Agent Teams is ON by default.** For FEATURE, IMPLEMENT, and ORCHESTRATE routes, `/do` automatically plans with Agent Team teammates unless the user opts out.

**Opt-out keywords** (use sequential sub-agents instead):
- "simple", "sequential", "sin equipo", "no team", "solo", "single agent"

**Default behavior** (no opt-out keyword detected):
```
Route: FEATURE
Agent Team: 3 teammates

1. Backend Teammate: [scope]
2. Frontend Teammate: [scope]
3. Tests Teammate: [scope]

File ownership and dependencies defined per teammate.
Proceed? (yes / modify / cancel)
```

**Opted-out behavior** (`/do add auth, simple`):
```
Route: FEATURE
Agent: /workflow (sequential, single agent)
...
```

Agent Teams still require user confirmation before spawning.

---

## Step 2: PLAN (Mandatory)

**Always show a plan before executing. No exceptions.**

Based on the classified route, present:

```
Route: [ROUTE NAME]
Agent: [agent or command to execute]
Quality Gates: [gates from quality-gates.md for this route]

Plan:
1. [First action]
2. [Second action]
3. [Expected deliverable]

Estimated time: [X] minutes

Proceed? (yes / modify / cancel)
```

### Quality Gates Reference
@.claude/templates/quality-gates.md

The plan must show which gates apply to this route (from the gates-per-route table).

### Smart Shortcuts
- If ResearchPack already exists -> skip research, note in plan
- If Implementation Plan exists -> skip planning, note in plan
- If circuit breaker OPEN -> refuse implementation, suggest diagnostics

---

## Step 3: CONFIRM

Wait for user confirmation before executing:
- **yes** / **y** / **proceed**: Execute the plan
- **modify**: User adjusts the plan, re-present
- **cancel**: Abort, no action taken
- **No response needed for SIMPLE route**: Direct answers execute immediately

---

## Step 4: EXECUTE

Run the classified route with the confirmed plan:

1. Dispatch to the selected agent or command
2. Evaluate quality gates between phases (if multi-phase route)
3. If a gate FAILS: stop, report the failure, suggest fixes
4. If circuit breaker trips: stop, report state

### Execution Rules
- Follow the plan exactly as confirmed
- Report progress at natural milestones
- If blocked, report immediately (don't spin)

---

## Step 5: REPORT

After execution completes, present results:

1. Receive Agent Report from dispatched agent
2. Check status: COMPLETE / PARTIAL / BLOCKED / FAILED
3. Present summary to user:
   - Key findings (top 3)
   - Changes made (file list)
   - Quality gate results
   - Any blockers or risks
4. Offer drill-down: "Want details on [specific finding]?"
5. If BLOCKED/FAILED: Report issue and suggest next steps

### Agent Report Protocol
@.claude/templates/AGENT-REPORT-PROTOCOL.md

---

## Examples

**User**: `/do add authentication to my API`
```
Route: FEATURE
Agent: /workflow (research -> plan -> implement)
Gates: Research (80+) -> Plan (85+) -> Tests Pass

Plan:
1. @docs-researcher: Research auth library options
2. @implementation-planner: Create implementation blueprint
3. @code-implementer: Implement with TDD

Estimated time: 10-15 minutes
Proceed?
```

**User**: `/do why is the login failing?`
```
Route: DEBUG
Agent: @brahma-investigator
Gates: Investigation Complete -> Fix Verified

Plan:
1. Investigate login failure with 3-retry strategy
2. Identify root cause with evidence
3. Create regression test

Estimated time: 5-10 minutes
Proceed?
```

**User**: `/do research Redis caching`
```
Route: RESEARCH
Agent: @docs-researcher
Gates: ResearchPack (80+)

Plan:
1. Fetch Redis docs for detected version
2. Extract key APIs, setup, gotchas
3. Deliver ResearchPack

Estimated time: 2 minutes
Proceed?
```

**User**: `/do deploy v2.0`
```
Route: DEPLOY
Agent: @brahma-deployer
Gates: Pre-deploy Checks -> Post-deploy Validation

Plan:
1. Pre-deployment validation (tests, staging, config)
2. Canary deployment (5% -> 25% -> 50% -> 100%)
3. Post-deployment monitoring

Estimated time: 45-60 minutes
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
