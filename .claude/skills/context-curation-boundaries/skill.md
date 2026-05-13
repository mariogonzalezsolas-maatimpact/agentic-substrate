---
name: context-curation-boundaries
description: "Token budgets and context filtering rules for each tier of the Agentic Corp hierarchy. Defines what context passes through CEO → VP → Lead → IC boundaries and what stays. Prevents context bloat in deep hierarchies, maintains cache friendliness."
auto_invoke: true
tags: [context, tokens, hierarchy, optimization, agentic-corp]
---

# Context Curation at Tier Boundaries

## When This Activates
Auto-invoked alongside [[hierarchical-orchestration]] whenever an agent dispatches a sub-agent. Defines the context CONTRACT between tiers.

## Core Principle
Each tier filters and compresses context DOWNWARD. The hierarchy is an information compressor, not a relay.

Wrong: CEO passes full conversation + all files + all project state to every VP.
Right: CEO passes domain-specific scoped brief to each VP. VP further filters to dispatch to IC.

## Token Budget Matrix

| Tier | Input Context Cap | Output Report Cap | Reasoning Budget |
|------|-------------------|-------------------|-----------------|
| CEO (T0) | up to 1M (Opus 4.7 full) | unbounded to user (compact preferred) | ultrathink reserved |
| VP (T1) | 30k working context | 500 tokens report | think hard |
| Lead (T2) | 15k working context | 500 tokens report | think |
| IC (T3) | 8k working context | 400 tokens report | think (only for hard ICs) |

These are TARGETS not hard limits. Use as guidance.

## What Each Tier Carries Down

### CEO → VP (Board Meeting Brief)
INCLUDE:
- User goal verbatim
- Strategic lens decision
- Initial scope (files/services suspected)
- Cross-VP awareness (which other VPs are running in parallel)
- Constraints (deadline, urgency, env)
- Auto-escalation flags (auth/payments/PII)

EXCLUDE:
- Full project history
- Unrelated files
- Other VPs' domain plans (until synthesis phase)
- Internal CEO reasoning

### VP → Lead
INCLUDE:
- Domain-scoped task spec
- Files in scope (explicit list)
- IC roster suggestion
- Sequencing hint
- Inherited constraints relevant to this Lead's domain
- Quality bar applicable

EXCLUDE:
- Cross-VP details
- User's verbatim wording (use VP's distilled task spec)
- Strategic lens reasoning
- Other Lead briefs

### Lead → IC
INCLUDE:
- Surgical task (≤3 lines)
- Exact file paths in scope (subset of Lead's)
- Single binary success criterion
- Wave number (if multi-wave)
- Inherited constraints (only the ones the IC must know)

EXCLUDE:
- Lead's sibling IC details (unless declared as PARALLEL_PEERS)
- VP's full plan
- CEO's strategic context
- Project-wide history

### IC works on
- ITS OWN context only
- Reads its scoped files
- Returns a structured report

## What Each Tier Carries UP

Reports flow up COMPRESSED, not relayed.

### IC → Lead/VP Report
INCLUDE:
- Status (COMPLETE / BLOCKED / FAILED / PARTIAL)
- Key findings (≤3 bullets)
- Changes made (file list, one-line each)
- Metrics (tests passed, lint clean, score)
- Blockers (if any)

EXCLUDE:
- Full diff (parent can read git itself if needed)
- Verbose reasoning
- Tool call traces
- Sibling-IC speculation

### Lead → VP Report
INCLUDE:
- Lead-level status
- Aggregated IC outcomes (table)
- Inter-IC conflicts resolved
- Unresolved risks
- Recommendation

EXCLUDE:
- Individual IC verbose findings (link via "drill down via IC X")
- Tool traces
- Per-IC token spend (aggregate it)

### VP → CEO Report
INCLUDE:
- VP-level status + iteration
- Top-3 findings/changes
- Quality self-check
- Open questions for next VP
- Token spend total

EXCLUDE:
- Per-IC details (CEO drills down if needed)
- Lead orchestration details
- Internal VP reasoning

## Cache Friendliness

To maximize Opus 4.7 prompt caching (5min TTL), structure dispatch prompts so STABLE parts are first:

Order in every dispatch prompt:
1. **Stable**: Role definition, hierarchy position, tier responsibilities, escalation rules (cacheable across all dispatches of the same agent type)
2. **Semi-stable**: Project conventions, quality bars (cacheable across multiple tasks in same project)
3. **Volatile**: Current task spec, files in scope (changes per dispatch)

## Anti-Patterns

- Passing the full CEO conversation to every VP (cache breaks, tokens balloon)
- IC returning a 2000-token report (violates report budget)
- VP receiving the same file via 2 different paths (deduplicate before dispatch)
- Lead skipping the report budget enforcement on ICs (cascade overflow)
- CEO drilling into raw IC outputs when VP summary suffices

## Verification

Before any dispatch, ask:
1. Does the receiver actually need this piece of context to do their job?
2. Can the receiver fetch it themselves (Read tool) if needed?
3. Is this stable enough to cache?

If NO to #1: drop it.
If YES to #2: drop it (let them fetch on-demand).
If NO to #3: place after stable sections.

## Working with [[hierarchical-orchestration]]
This skill defines the WHAT (context content) at each boundary. The hierarchical-orchestration skill defines the WHO (which agent dispatches whom). Use them together.

## Working with [[opus-47-optimizations]]
This skill informs the cache-strategy and parallel-dispatch optimizations specific to Opus 4.7.
