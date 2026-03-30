# Pyramid Orchestration Protocol

The default execution model for all `/do` routes. A 3-tier pyramid ensures every task goes through planning, coding, and review -- with an automatic fix loop until quality passes.

---

## Architecture

```
                    ┌─────────────────┐
   Tier 1:          │   ORCHESTRATOR  │  (main thread)
                    │  Classifies,    │
                    │  dispatches,    │
                    │  synthesizes    │
                    └───────┬─────────┘
                            │
           ┌────────────────┼────────────────┐
           │                │                │
   Tier 2: ▼                ▼                ▼
    ┌──────────────┐ ┌──────────────┐ ┌──────────────┐
    │    PLAN      │ │    CODE      │ │   REVIEW     │
    │ Coordinator  │ │ Coordinator  │ │ Coordinator  │
    │              │ │              │ │              │
    │ - Research   │ │ - TDD impl   │ │ - Code review│
    │ - Analyze    │ │ - Self-fix   │ │ - Browser QA │
    │ - Plan       │ │ - Git commit │ │ - Verdict    │
    └──────────────┘ └──────────────┘ └──────────────┘
           │                │                │
   Tier 3: │                │                │
    (plan-coordinator       │         (review-coordinator
     handles research    (code-coordinator    uses Playwright
     internally via      implements          MCP for browser
     WebFetch/WebSearch) directly)           testing)
```

## Key Constraint

**Sub-agents cannot spawn other sub-agents** in Claude Code. The orchestrator (Tier 1, main thread) manages ALL dispatching. Tier 2 coordinators report back to the orchestrator, which routes information between them.

---

## The Loop

```
         ┌──────────────────────────────────────────────┐
         │                                              │
    ┌────▼──────┐    ┌────────────┐    ┌────────────┐  │
    │   PLAN    │───►│    CODE    │───►│   REVIEW   │──┘
    │Coordinator│    │Coordinator │    │Coordinator │
    └───────────┘    └────────────┘    └────────────┘
         │                │                │
    Plan Report      Code Report     Review Report
    (score 85+)     (tests pass)    (PASS or FAIL)
         │                │                │
         └────────┬───────┘────────────────┘
                  ▼
            ORCHESTRATOR
         (reads all reports,
          routes fix requests,
          max 3 iterations)
```

### Loop Rules

1. **Max 3 iterations** of the plan-code-review loop
2. If review PASSES on iteration 1: done (best case)
3. If review FAILS: orchestrator sends review findings to plan-coordinator
4. Plan-coordinator creates a fix plan addressing reviewer's issues
5. Code-coordinator implements the fix plan
6. Review-coordinator reviews again (focused on previous issues)
7. After 3 FAIL iterations: escalate to user with full context

### Circuit Breaker Integration

The existing circuit breaker (3 consecutive failures) applies at the code-coordinator level:
- If code-coordinator reports BLOCKED 3 times: circuit breaker OPENS
- Orchestrator stops the loop and reports to user
- User must `/circuit-breaker reset` to continue

---

## Orchestrator Protocol (Step 4: EXECUTE)

When executing any route through the pyramid:

### Step 4.0: Brainstorming Gate (FEATURE + ORCHESTRATE only)

For FEATURE and ORCHESTRATE routes, run the brainstorming-gate skill first:
- Context exploration + clarifying questions + design proposals
- User approves design -> spec written to `docs/specs/`
- Spec passed to plan-coordinator as additional context
- **Skip if**: user opts out ("skip design"), spec already exists, or fix iteration > 1

### Step 4.1: Dispatch to Plan Coordinator

```
Spawn @plan-coordinator with:
  TASK: [user's request]
  CONTEXT: [project type, relevant files, constraints]
  SPEC: [path to docs/specs/feature.md if brainstorming ran, or "none"]
  ITERATION: 1
```

Wait for Plan Coordinator Report. Verify plan score >= 85.

### Step 4.2: Dispatch to Code Coordinator

```
Spawn @code-coordinator with:
  PLAN: [plan-coordinator's detailed plan]
  CONTEXT: [project type, conventions]
  ITERATION: 1
```

Wait for Code Coordinator Report. Verify tests pass.

### Step 4.3: Dispatch to Review Coordinator

```
Spawn @review-coordinator with:
  CHANGES: [files changed by code-coordinator]
  PLAN: [original plan]
  COMMIT: [git hash from code-coordinator]
  PROJECT TYPE: [stack]
  ITERATION: 1
```

Wait for Review Coordinator Report.

### Step 4.4: Evaluate Review Verdict

**If PASS**: Proceed to Step 5 (REPORT). Done.

**If FAIL (iteration < 3)**:

```
Spawn @plan-coordinator with:
  FIX REQUEST from review-coordinator:
  ISSUES: [review findings]
  FILES AFFECTED: [file paths]
  SEVERITY: [per issue]
  SUGGESTED FIXES: [reviewer's suggestions]
  ORIGINAL PLAN: [reference]
  ITERATION: [N+1]
```

Then repeat Steps 4.2 -> 4.3 -> 4.4.

**If FAIL (iteration = 3)**: Report to user with all findings. Suggest manual intervention.

---

## Report Aggregation

The orchestrator reads all three coordinator reports and synthesizes a single user-facing summary:

```markdown
## Pyramid Execution Report

**Task**: [user's original request]
**Iterations**: [1-3]
**Final Verdict**: [PASS | FAIL (escalated)]

### Plan Summary
- Files planned: [N]
- Research done: [topics]
- Plan score: [X/100]

### Implementation Summary
- Files changed: [N]
- Tests written: [N]
- Self-corrections: [0-3]
- Build: [PASS/FAIL]

### Review Summary
- Review score: [X/100]
- Critical issues: [N]
- Browser testing: [PASS/FAIL/SKIPPED]

### Changes Made
- `file1.ext`: [1-line summary]
- `file2.ext`: [1-line summary]

### Commit
- Hash: [abc1234]
- Rollback: `git revert [hash]`
```

---

## Route-Specific Behavior

### Routes that use FULL pyramid (plan + code + review):
FEATURE, IMPLEMENT, MIGRATE, ORCHESTRATE

### Routes that use LIGHTWEIGHT execution (@programmer direct):
REFACTOR, TEST, DEBUG, OPTIMIZE, CODE, DATABASE, TECH_DEBT

Lightweight routes dispatch directly to @programmer with the plan. No coordinator chain. Faster and cheaper (1 agent call vs 3+). User can upgrade to full pyramid with "con review" / "with review".

### Routes that use PARTIAL pyramid (plan + specialist):
DEPLOY, MONITOR, INCIDENT, DEVOPS, SECDEVOPS

### Routes that use REVIEW-ONLY:
REVIEW, SECURITY, SEO, UX, RESPONSIVE, THEME, I18N, ARCHITECTURE, API, TESTING, BUSINESS, CONTENT, PRODUCT

### Routes that use DIRECT specialist dispatch (no pyramid):
MCP, DATA, DOCS

### Routes that SKIP pyramid:
SIMPLE, CONTEXT, RESEARCH (just research, no code), PLAN (just plan, no code), ROLLBACK (direct git revert)

---

## Model Assignment

| Coordinator | Model | Rationale |
|-------------|-------|-----------|
| plan-coordinator | Opus | Deep reasoning for architecture + research |
| code-coordinator | Opus | Complex coding + self-correction |
| review-coordinator | Sonnet | Fast, thorough analysis + browser testing |

---

## Cost Considerations

Each pyramid iteration spawns up to 3 sub-agents:
- **1 iteration** (happy path): 3 agent calls
- **2 iterations** (1 fix loop): 6 agent calls
- **3 iterations** (max fix loops): 9 agent calls

The pyramid is cost-effective because:
1. Catches bugs BEFORE they reach production
2. Fix loop prevents repeated user back-and-forth
3. Browser testing catches UI issues that code review misses
4. Each coordinator has a focused context (no bloat)

---

**Updated**: 2026-03-30 | **Version**: 7.2.1 | **Protocol**: Pyramid Orchestration v1.1 (Full + Lightweight tiers)
