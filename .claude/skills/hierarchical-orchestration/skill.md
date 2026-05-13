---
name: hierarchical-orchestration
description: "Formal protocol for the Agentic Corp 4-tier hierarchy (CEO → VPs → Leads → ICs). Defines board meetings, dispatch templates, escalation rules, and report aggregation. Auto-invoked by /do when classifying any non-SIMPLE task. Replaces the v7.2 3-tier pyramid with explicit role-based delegation."
auto_invoke: true
tags: [orchestration, hierarchy, agentic-corp, multi-agent, coordination]
---

# Hierarchical Orchestration (Agentic Corp v8.0)

## When This Activates
Auto-invoked by `/do` on every non-SIMPLE route. Defines HOW the orchestrator decomposes work, who reports to whom, and how reports flow back up.

## The Four Tiers

```
TIER 0: CEO        = the /do thread (this main conversation)
TIER 1: VPs        = vp-engineering, vp-frontend, vp-quality, vp-platform, vp-strategy, vp-product
TIER 2: Leads      = backend-lead, frontend-lead, devops-lead, quality-lead (on-demand only)
TIER 3: ICs        = the 30+ existing specialist agents
```

## Routing Map (CEO Classification → VP)

| Route | Primary VP | Notes |
|-------|-----------|-------|
| FEATURE | vp-strategy → vp-engineering / vp-frontend | Strategy runs first for plan/research |
| IMPLEMENT | vp-engineering and/or vp-frontend | Strategy SKIPPED if Plan already exists |
| MIGRATE | vp-strategy → vp-engineering | Plan mandatory |
| REFACTOR | vp-engineering or vp-frontend | Skip strategy if clear scope |
| CODE | vp-engineering or vp-frontend | Skip strategy |
| TEST/TESTING | vp-quality (primary) | Special: vp-quality is primary, not gate |
| RESEARCH | vp-strategy | Standalone |
| PLAN | vp-strategy | Standalone |
| DEBUG | vp-engineering (with brahma-investigator IC) | Quality VP audits the fix |
| DEPLOY | vp-platform | + vp-quality post-deploy check |
| OPTIMIZE | vp-platform | + vp-quality if app code changed |
| MONITOR | vp-platform | Standalone |
| INCIDENT | vp-platform (primary) + vp-engineering (in parallel) | Quality VP runs post-incident review |
| REVIEW | vp-quality | Standalone |
| ROLLBACK | vp-engineering (with @programmer for git revert) | + vp-platform if affects prod |
| SECURITY | vp-quality (primary) | Standalone |
| UX | vp-frontend (engineering a11y) OR vp-product (design UX) | Disambiguate per request |
| RESPONSIVE | vp-frontend | Standalone |
| THEME | vp-frontend | Standalone |
| I18N | vp-frontend | Standalone |
| ARCHITECTURE | vp-strategy | Standalone |
| DATABASE | vp-engineering | Standalone |
| API | vp-engineering | Standalone |
| DEVOPS | vp-platform | Standalone |
| SECDEVOPS | vp-platform + vp-quality | Both VPs |
| BUSINESS | vp-strategy or vp-product | Disambiguate per request |
| CONTENT | vp-product | Standalone |
| PRODUCT | vp-product | Standalone |
| SEO | vp-product | Standalone |
| MCP | vp-engineering | Standalone |
| DATA | vp-engineering | Standalone |
| DOCS | vp-product (or vp-strategy for technical docs) | Per request |
| TECH_DEBT | vp-engineering | + vp-quality audit |
| ORCHESTRATE | ALL VPs in board meeting | Use sparingly, expensive |

## The Standard Flow

```
Step 1. CEO Classify
Step 2. CEO Strategic Lens
Step 3. CEO Board Meeting → wake involved VPs in PARALLEL
Step 4. VPs return Domain Plans (compact, <300 tokens each)
Step 5. CEO Synthesizes → unified master plan
Step 6. CEO CONFIRM with user
Step 7. CEO Execute Phase → dispatch execution VPs (parallel where possible)
Step 8. Execution VPs dispatch Leads/ICs and return Reports
Step 9. CEO routes consolidated diff to vp-quality (MANDATORY for any code change)
Step 10. vp-quality returns Verdict
Step 11. If FAIL_FIX and iteration < 3: send findings to plan VPs, repeat Step 7
Step 12. If PASS: CEO Final Report to user
```

## Board Meeting Pattern

CEO opens a Board Meeting by dispatching ALL involved VPs in a SINGLE message (parallel Agent calls). Each VP returns a Domain Plan independently. CEO synthesizes.

CEO Board Meeting Dispatch Template:
```
BOARD MEETING called by CEO
TASK: <user request verbatim>
STRATEGIC_LENS: <CTO|CISO|CPO|CMO|VP-Eng>
INITIAL_SCOPE: <files/areas suspected>
URGENCY: <routine|high|P1|P0>
CROSS_VP_AWARENESS: [list of OTHER VPs at this meeting]
EXPECTED_DELIVERABLE: domain plan, <300 tokens
REPORT_BUDGET: <300 tokens
```

After plans return, CEO produces the Master Plan and asks user CONFIRM.

## Dispatch Template (VP → Lead OR IC)

```
DISPATCHED BY: <VP name>
TASK: <surgical, ≤3 lines>
FILES_IN_SCOPE: <explicit list>
CONSTRAINTS: <inherited from CEO>
SUCCESS_CRITERION: <binary, verifiable>
REPORT_TO: <parent agent>
REPORT_BUDGET: <token cap>
PARALLEL_PEERS: <list, if applicable>
```

## Dispatch Template (Lead → IC)

```
DISPATCHED BY: <Lead name> (under <VP name>)
TASK: <surgical>
FILES_IN_SCOPE: <subset>
WAVE: <number, if multi-wave>
SUCCESS_CRITERION: <binary>
REPORT_TO: <Lead name>
REPORT_BUDGET: <token cap>
```

## Communication Rules (anti-deadlock, anti-chaos)

| Direction | Allowed? | When |
|-----------|---------|------|
| Down (parent → child) | YES | At dispatch and at re-dispatch |
| Up (child → parent) BEFORE start | YES | BLOCKED status + ClarificationRequest |
| Up (child → parent) DURING execution | NO | Fail-fast, return partial report |
| Lateral (siblings) | NO | Coordinate only via parent merge |
| Skip-level (IC → CEO directly) | NO | Always through parent |
| CEO → User | YES | Only CEO can ask user |

## Escalation Protocol

Max escalation depth: 3 (matches user's circuit breaker).

When an IC is BLOCKED:
1. IC returns BLOCKED with structured ClarificationRequest
2. Lead/VP tries to resolve from their context
3. If unable: VP returns BLOCKED to CEO with ClarificationRequest
4. CEO either resolves from context or uses AskUserQuestion
5. Decision propagates back down via re-dispatch

ClarificationRequest format:
```
STATUS: BLOCKED
REASON: <one sentence>
AMBIGUITY: <what is unclear>
OPTIONS: [option A, option B, option C]
RECOMMENDATION: <agent's pick + why>
COST_OF_DELAY: <impact if user can't answer fast>
```

## Quality Gate (vp-quality is MANDATORY)

After ALL execution VPs report, CEO dispatches vp-quality with:
- The consolidated DIFF
- All execution VP reports
- Original TASK_SUMMARY
- Quality bars from CLAUDE.md and project conventions

vp-quality returns ONE of:
- PASS → CEO proceeds to Final Report
- FAIL_FIX → CEO sends findings to relevant execution VP for fix iteration (max 3)
- FAIL_ESCALATE → CEO escalates to user with verdict

## Token Budgets per Tier

Maximum allowed report sizes:
- CEO Final Report to user: no hard cap (but compact preferred)
- VP Report to CEO: 500 tokens
- Lead Report to VP: 500 tokens
- IC Report to Lead/VP: 400 tokens
- Board Meeting Domain Plan: 300 tokens

Why: each tier compresses upward. CEO never sees raw IC outputs unless explicitly drilled down.

## When NOT to Spawn Leads

Spawn a Lead ONLY when:
- 3+ ICs needed in coordinated waves (impl → review fan-out, build → deploy → monitor → optimize)
- Inter-IC dependencies that need a tactical orchestrator

Skip Leads when:
- 1-2 ICs suffice
- All ICs are independent and the VP can synthesize directly
- The task is sub-minute work

## Anti-Patterns

- Forcing ALL routes through full hierarchy when SIMPLE bypass exists
- Letting VPs make user-facing decisions without CEO consent
- Lateral coordination between siblings (use parent merge)
- Skipping vp-quality for "small" changes (every diff goes through)
- Spawning Leads for 1-2 ICs (overhead > benefit)

## Sibling Skills
- [[context-curation-boundaries]] -- defines what context passes through each tier
- [[opus-47-optimizations]] -- model-tiering and caching strategy
- [[pyramid-loop]] -- legacy v7.2 protocol (deprecated by this skill)

## Migration from v7.2
The v7.2 pyramid (plan-coordinator → code-coordinator → review-coordinator) is REPLACED by the Agentic Corp flow. The three coordinators are now ICs under VP layer:
- plan-coordinator → IC under vp-strategy
- code-coordinator → IC under vp-engineering
- review-coordinator → IC under vp-quality

Existing skills/commands that reference the v7.2 names should still work; the names route to ICs.
