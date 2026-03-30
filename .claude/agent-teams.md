# Agent Teams Guide

Experimental parallel collaboration layer for Claude Code. Teammates are persistent, independent Claude instances that coordinate via shared task lists and messaging.

**Key difference from sub-agents**: Sub-agents (@agent via Task tool) report results back to you. Agent Teams teammates coordinate with each other in real-time.

---

## Entry Point: `/do`

**Agent Teams is the default** for FEATURE, IMPLEMENT, and ORCHESTRATE routes. `/do` automatically plans with Agent Team teammates:

1. Classify task and detect layers/scope
2. Plan with Agent Team (teammates, file ownership, dependencies)
3. Show plan and wait for confirmation
4. Execute with parallel teammates

**To opt out** (use sequential single-agent workflow instead), add one of these keywords:
- "simple", "sequential", "sin equipo", "no team", "solo", "single agent"
- Example: `/do add auth, simple` -> sequential `/workflow`

---

## Section A: When to Use What

| Dimension | Sub-agents (@agent) | Agent Teams |
|---|---|---|
| Context | Own window, report back | Own window, talk to each other |
| Best for | Focused task, result-only | Parallel work needing coordination |
| Cost | Lower (results summarized) | Higher (each is full Claude instance) |
| Lifetime | Transient (one task) | Persistent (whole session) |

### Use Agent Teams for:
- **Code review multi-angle** -- security + performance + tests in parallel
- **Cross-layer features** -- frontend + backend + tests as separate teammates
- **Debug by competing hypotheses** -- each teammate tests a different theory
- **Large multi-module refactors** -- each teammate owns different modules

### Keep using sub-agents for:
- Research tasks (just need the result)
- Single-file focused work
- Sequential workflows (research -> plan -> implement)

---

## Section B: Contract-First Spawning Pattern

Before spawning teammates, always define these 3 elements:

### 1. File Ownership
Which teammate owns which files. Prevents edit collisions.

### 2. Task Dependencies
What blocks what. Prevents racing conditions.

### 3. Rich Context
Teammates DON'T inherit lead's conversation history. Briefing must be generous -- include all relevant context, file paths, and acceptance criteria.

### Example Spawn Prompt

```
You are the Backend Teammate for a payment processing feature.

FILE OWNERSHIP (only touch these files):
- src/services/payment.ts
- src/routes/payment.ts
- src/models/transaction.ts
- src/config/stripe.ts

TASK DEPENDENCIES:
- You can start immediately (no blockers)
- Frontend Teammate is blocked on your API contract (POST /api/payments)
- Tests Teammate is blocked on your service interface

CONTEXT:
- We're adding Stripe payment processing to an Express.js app
- Use Stripe SDK v14.x (already in package.json)
- Database: PostgreSQL via Prisma ORM
- Auth: JWT middleware already exists at src/middleware/auth.ts
- Follow existing patterns in src/services/user.ts

ACCEPTANCE CRITERIA:
- POST /api/payments endpoint accepting { amount, currency, paymentMethodId }
- PaymentService class with createPayment() and getPayment() methods
- Transaction model with status enum: pending, completed, failed, refunded
- Error handling: Stripe errors mapped to HTTP status codes
- When done, update the shared task list so Frontend Teammate can proceed
```

---

## Section C: Best Practices

### Team Size
- **Max 5-6 teammates** -- diminishing returns after that
- **Sweet spot: 3 teammates** for most tasks

### Model Selection
- **Sonnet for teammates** -- cost optimization (they do focused, scoped work)
- **Opus for lead** -- orchestration needs deeper reasoning

### Coordination
- **Delegate mode** (Shift+Tab) so lead only coordinates, doesn't implement
- **Clear file ownership** per teammate to avoid edit collisions
- Use shared task lists for dependency tracking

### What Teammates Get
Teammates automatically load:
- CLAUDE.md + project instructions
- MCP servers
- Skills + permissions

Teammates DON'T load:
- Lead's conversation history
- Previous teammate outputs (unless you brief them)

### Windows Users
- Use `in-process` mode (tmux not available on Windows)
- Set via: `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1`

---

## Section D: Ready-to-Use Prompt Templates

### Template 1: Code Review Team (3 teammates)

**Lead prompt:**
```
I need a thorough code review of [FILES/PR]. Spawn 3 review teammates:

1. Security Reviewer
2. Performance Reviewer
3. Test Coverage Reviewer

Each reviewer writes findings to a shared task list. I'll synthesize the final review.
```

**Security Reviewer:**
```
You are the Security Reviewer on a code review team.

SCOPE: Review [FILES] for security vulnerabilities.

CHECKLIST:
- OWASP Top 10 patterns (injection, XSS, broken auth, SSRF)
- Input validation and sanitization
- Authentication and authorization flaws
- Secrets or credentials in code
- Dependency vulnerabilities (check package.json/requirements.txt)
- SQL injection / NoSQL injection patterns
- Insecure deserialization

OUTPUT: Create tasks for each finding with severity (Critical/High/Medium/Low).
Do NOT modify any files. Read-only review.
```

**Performance Reviewer:**
```
You are the Performance Reviewer on a code review team.

SCOPE: Review [FILES] for performance issues.

CHECKLIST:
- N+1 query patterns (database calls in loops)
- Memory leaks (unclosed connections, event listener accumulation)
- Algorithm complexity (O(n^2) or worse in hot paths)
- Missing pagination on list endpoints
- Unbounded data structures
- Missing caching opportunities
- Synchronous blocking in async contexts
- Bundle size impact (frontend)

OUTPUT: Create tasks for each finding with impact (High/Medium/Low).
Do NOT modify any files. Read-only review.
```

**Test Coverage Reviewer:**
```
You are the Test Coverage Reviewer on a code review team.

SCOPE: Review [FILES] and their corresponding tests.

CHECKLIST:
- Missing unit tests for new functions/methods
- Untested error paths and edge cases
- Missing integration tests for API endpoints
- Boundary conditions not tested
- Mock coverage (are external dependencies properly mocked?)
- Missing assertion specificity (overly broad assertions)
- Flaky test patterns (timing, order dependency)

OUTPUT: Create tasks for each gap with priority (Must-have/Nice-to-have).
Do NOT modify any files. Read-only review.
```

---

### Template 2: Feature Build Team (3 teammates)

**Lead prompt:**
```
Build [FEATURE DESCRIPTION]. Spawn 3 teammates:

1. Backend Teammate -- API + business logic + database
2. Frontend Teammate -- UI components + state + API integration
3. Tests Teammate -- E2E + integration + unit tests

Backend starts first. Frontend and Tests are blocked until Backend defines the API contract.
```

**Backend Teammate:**
```
You are the Backend Teammate building [FEATURE].

FILE OWNERSHIP:
- src/services/[feature].ts
- src/routes/[feature].ts
- src/models/[feature].ts
- src/middleware/[feature-specific].ts (if needed)

TASK DEPENDENCIES:
- You start first (no blockers)
- Frontend is blocked on your API contract
- Tests is blocked on your service interface

ACCEPTANCE CRITERIA:
[List specific endpoints, models, business rules]

When your API contract is ready (route signatures + request/response types),
update the task list so Frontend and Tests teammates can proceed.
```

**Frontend Teammate:**
```
You are the Frontend Teammate building [FEATURE].

FILE OWNERSHIP:
- src/components/[Feature]/*.tsx
- src/hooks/use[Feature].ts
- src/api/[feature].ts (API client)
- src/types/[feature].ts

TASK DEPENDENCIES:
- BLOCKED until Backend Teammate defines API contract
- Check task list for API endpoint definitions before starting

ACCEPTANCE CRITERIA:
[List specific UI components, interactions, states]

Follow existing component patterns. Use the project's design system.
```

**Tests Teammate:**
```
You are the Tests Teammate for [FEATURE].

FILE OWNERSHIP:
- tests/e2e/[feature].test.ts
- tests/integration/[feature].test.ts
- src/**/__tests__/[feature]*.test.ts

TASK DEPENDENCIES:
- BLOCKED until Backend Teammate defines service interface
- Can write E2E test skeletons immediately (describe blocks, test names)
- Integration + unit tests after Backend is done

ACCEPTANCE CRITERIA:
- E2E tests covering happy path + main error paths
- Integration tests for each API endpoint
- Unit tests for business logic (service layer)
- Minimum 80% coverage on new code
```

---

### Template 3: Debug Team (2-3 teammates)

**Lead prompt:**
```
Investigating: [BUG DESCRIPTION]

Spawn 2-3 teammates, each testing a different hypothesis:

1. Hypothesis A: [e.g., "Race condition in the WebSocket handler"]
2. Hypothesis B: [e.g., "Memory leak from unclosed database connections"]
3. Hypothesis C: [e.g., "Timeout misconfiguration in the load balancer"]

Each teammate investigates their hypothesis independently.
Report findings to task list. I'll synthesize the root cause.
```

**Debug Teammate (template):**
```
You are investigating a bug: [BUG DESCRIPTION]

YOUR HYPOTHESIS: [SPECIFIC HYPOTHESIS]

INVESTIGATION PLAN:
1. Read relevant source files: [LIST FILES]
2. Search for patterns that support/refute your hypothesis
3. Check logs, configs, and error handling in the suspect area
4. If possible, identify the exact line(s) causing the issue

RULES:
- Do NOT fix the bug -- only investigate
- Do NOT modify any files
- Report findings to the task list with evidence
- State clearly: CONFIRMED, REFUTED, or INCONCLUSIVE with reasoning
```

---

## Environment Variable

Agent Teams requires this environment variable:

```
CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1
```

The install.sh script automatically adds this to `~/.claude/settings.json`.

To verify: check `~/.claude/settings.json` contains:
```json
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

---

## Hooks

Two quality gate hooks are installed for Agent Teams:

- **teammate-idle.sh** -- Prevents premature teammate idle when tasks remain
- **task-completed.sh** -- Verifies implementation tasks include tests before completion

---

*Agent Teams is experimental. The feature flag and behavior may change in future Claude Code releases.*

---

## Agent Teams + Report Protocol

All teammates MUST use the Agent Report Protocol when completing tasks:

@.claude/templates/agent-report-protocol.md

### How It Works in Teams

1. **Each teammate** formats their completed work as a compact Agent Report (<800 tokens)
2. **The lead** receives all reports and can read them quickly (<3000 tokens total for a 5-agent team)
3. **Cross-team synthesis**: The lead scans all status lines, detects patterns across reports, and resolves dependencies
4. **Drill-down via messaging**: If the lead needs the full artifact from a teammate, they send a direct message requesting it

### Benefits for Agent Teams

- **Reduced context overhead**: 5 teammates x 600 tokens = 3000 tokens (vs. 5 x 5000+ tokens raw output)
- **Faster lead processing**: Status + Key Findings give 80% of the picture in <30 seconds
- **Better coordination**: Blockers are surfaced explicitly, dependency chains are visible
- **Selective depth**: Lead only requests full details where needed, saving tokens for orchestration
