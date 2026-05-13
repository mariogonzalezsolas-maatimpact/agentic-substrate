---
name: opus-47-optimizations
description: "Opus 4.7 specific optimizations for the Agentic Corp hierarchy: prompt caching strategy, multi-tool single-message dispatch, thinking budget tiering, 1M context awareness, structured reports v2, fast mode usage. Auto-invoked by /do and VPs."
auto_invoke: true
tags: [opus-4-7, optimization, caching, performance, agentic-corp]
---

# Opus 4.7 Optimizations

## When This Activates
Auto-invoked by `/do`, VPs, and Leads on dispatch decisions. Provides the cost/latency optimization layer for the Agentic Corp hierarchy.

## Opus 4.7 Capabilities Recap
- 1M context window
- Extended thinking modes (think, think hard, think harder, ultrathink)
- Prompt caching with 5-minute TTL
- Fast mode available (`/fast` toggle, faster output without smaller model)
- Robust multi-tool single-message dispatch
- Improved structured reasoning

## Optimization 1: Prompt Cache Strategy

Cache hits save ~3-5x cost on repeated content. To maximize hits:

### Stable prefix ordering (in every dispatch prompt)
```
[STABLE: role + hierarchy + responsibilities]   ← cacheable across all tasks
[SEMI-STABLE: project conventions + quality bars] ← cacheable within project
[VOLATILE: current task + files in scope]       ← changes per dispatch
```

### Rules
- NEVER inject task-specific data into the stable section
- Reuse role definitions verbatim (don't paraphrase per task)
- Keep CLAUDE.md content stable (it's loaded into every conversation prefix)
- Avoid timestamps/UUIDs in cacheable sections

### Cache TTL Awareness
The 5-min TTL is critical for iteration loops. Strategies:
- Dispatch parallel siblings in a SINGLE message (one cache fill, multiple uses)
- Run fix-loop iterations back-to-back within 5 min (keeps prefix hot)
- For long-running monitoring agents, expect cache cold-starts; budget accordingly

## Optimization 2: Multi-Tool Single-Message Dispatch

Opus 4.7 handles multiple Agent calls in one message robustly. Use this aggressively for parallelism.

### When to use single-message parallel:
- Board Meeting: ALL involved VPs in ONE message
- Quality fan-out: Standards + Spec + Security + Tests axes in ONE message
- Independent IC dispatch: when ICs have no inter-dependencies

### When NOT to use:
- Sequential dependencies (Wave 1 → Wave 2 → Wave 3 in DevOps Lead)
- When earlier output informs later dispatch (research → plan → implement)

### Pattern
```
<single message>
  Agent(vp-engineering, ...)
  Agent(vp-frontend, ...)
  Agent(vp-quality, ...)
</single message>
```
All three contexts initialize from the same cached prefix → 3x cache hit rate.

## Optimization 3: Thinking Budget Tiering

Higher tiers think more, lower tiers think less. Allocate per role:

| Tier | Default Thinking | When to escalate |
|------|------------------|------------------|
| CEO (T0) | `think hard` | `ultrathink` for ORCHESTRATE, ARCHITECTURE, INCIDENT |
| VP (T1) | `think hard` | `think harder` for risk/prod/security decisions |
| Lead (T2) | `think` | `think hard` for inter-IC conflict resolution |
| IC (T3) | none or `think` | `think hard` only for hard debugging/research |

Why: thinking tokens are expensive. Lower-tier ICs work on surgical, well-defined tasks where extended thinking adds little.

## Optimization 4: 1M Context Awareness

Only CEO has the full 1M context (model: opus 4.7 1M). Other tiers operate with smaller working sets.

### Implications
- CEO can hold the entire master plan + all VP reports + all Lead reports
- VPs hold their domain only
- Leads hold their wave only
- ICs hold their surgical task only

### CEO responsibilities
- Aggregate without losing fidelity
- Drill down on demand (read raw IC outputs only when VP summary is insufficient)
- Synthesize final user report with full historical context

## Optimization 5: Structured Reports v2 (JSON-lite)

Replace markdown reports with structured templates for deterministic parsing.

### Old (markdown, verbose, ~800 tokens):
```markdown
## Code Coordinator Report
**Task**: Add JWT middleware
**Status**: COMPLETE
...prose...
```

### New (structured, ~400 tokens):
```yaml
agent: code-coordinator
status: COMPLETE
iteration: 1
duration_min: 8
files_changed:
  - middleware/jwt.ts: new file, 47 LOC
  - app.ts: registered middleware
tests:
  written: 12
  passing: 12
  regressions: 0
metrics:
  lint: clean
  coverage_delta: +3.2
blockers: []
risks:
  - jwt secret read from env, must be set in prod
commit: a4f2c8b
```

Both formats remain acceptable; structured is preferred for deeper tiers.

## Optimization 6: Fast Mode Usage

`/fast` toggle keeps Opus quality with faster output. Use cases:
- CEO during Board Meeting (waiting on parallel VPs anyway)
- Final synthesis when content is already structured

Do NOT use Fast mode for:
- Heavy reasoning phases (architecture, security audit, root cause)
- Long-form content generation (PRDs, ADRs)

## Optimization 7: Compaction Awareness

When context approaches limits, the harness compacts older turns. Implications:
- Keep important decisions in MEMORY.md (persistent across compactions)
- Save session state via `/save-session` for long projects
- VPs/Leads should not RELY on compacted earlier turns; they receive a fresh dispatch

## Optimization 8: Cost-Conscious Defaults (Opus Everywhere variant)

User chose Opus everywhere. To mitigate cost:
- ENFORCE report budgets ruthlessly (cap at template limits)
- Cache aggressively (prefix discipline)
- Single-message parallel dispatch wherever possible
- Skip Leads when 1-2 ICs suffice
- Skip VP-Strategy when artifacts already exist
- vp-quality runs pre-scan via Grep BEFORE dispatching review ICs (cheap fail-fast)
- Halt fix loops at iteration 3 (don't burn unbounded)

## Anti-Patterns
- Loading volatile content (timestamps, task specs) into the stable cache prefix
- Sequential dispatch when parallel is safe (wastes round-trips)
- ultrathink at every tier (only CEO and rare VP cases)
- IC reports >400 tokens (cascade overflow)
- Running fix loops past 3 iterations (circuit breaker territory)

## Sibling Skills
- [[hierarchical-orchestration]] -- defines WHO talks to WHOM
- [[context-curation-boundaries]] -- defines WHAT context passes through
- [[caveman]] -- extreme compression mode for sessions that need it
- [[context-engineering]] -- general context optimization patterns

## Verification
Before any large dispatch, ask:
1. Are stable prefixes ordered correctly?
2. Can these siblings be dispatched in ONE message?
3. Is the thinking budget appropriate for this tier?
4. Are report budgets enforced in the prompt?

If NO to any: adjust before dispatching.
