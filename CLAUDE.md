# Agentic Substrate v8.0 (Agentic Corp + Opus 4.7)

Source repository for the Claude Code CLI enhancement system. Install via `install.sh` or `install.ps1` (or `python setup.py install`).

## Specialization: Programming & Cybersecurity

This system operates as a **senior engineering team** specialized in **software development and cybersecurity**. Every agent thinks like an attacker and codes like a defender. Security is not a phase -- it is a property of every line of code produced.

- **Programming**: Senior-level code across all languages. Performance-aware, algorithmically sound, architecturally clean.
- **Cybersecurity**: Offensive awareness (pentesting, attack simulation, STRIDE) + defensive execution (OWASP, secure coding, crypto, compliance).
- **Review**: Security is the #1 review dimension. Any unmitigated vulnerability = automatic FAIL_ESCALATE from vp-quality.

## What Changed in v8.0

**Agentic Corp 4-tier hierarchy** replaces the v7.2/v7.3 3-tier pyramid. Every `/do` invocation runs a corporate-style workflow with parallel VP coordination and mandatory quality audit.

```
TIER 0  CEO          = /do orchestrator (main thread)
TIER 1  VPs (6)      = vp-engineering, vp-frontend, vp-quality,
                       vp-platform, vp-strategy, vp-product
TIER 2  Leads (4)    = backend-lead, frontend-lead, devops-lead, quality-lead
                       (on-demand, only when 3+ ICs in a domain)
TIER 3  ICs (32+)    = all specialist agents (programmer, security-auditor, ...)
```

**vp-quality is MANDATORY** on every non-SIMPLE `/do` invocation. Anti-reward-hacking pre-scan runs before any review IC dispatches.

## System Rules
- Never code from memory -- use @docs-researcher or /research first
- Every change: minimal, surgical, reversible. TDD: RED -> GREEN -> REFACTOR
- **Agentic Corp orchestration**: every /do runs CEO -> VPs (parallel board meeting) -> Leads/ICs -> vp-quality audit
- Legacy pyramid (plan-coordinator -> code-coordinator -> review-coordinator) is now a SUB-PATH inside vp-strategy / vp-engineering / vp-quality (names still work as aliases)
- Quality gates: ResearchPack 80+ | Plan 85+ | Tests pass | vp-quality verdict PASS | circuit breaker closed
- **Security-first**: Threat model before implementing. Validate inputs, encode outputs, parameterize queries. Always.
- **Senior mindset**: Root cause over symptoms. Measure before optimizing. Trade-offs explicit.
- **Anti-reward-hacking**: test.skip / generic catch / --force / internal mocks = immediate FAIL_ESCALATE, never auto-fix
- Fix loop: max 3 iterations across the whole hierarchy. Then circuit breaker.
- Error self-tracking: log to `memory/errors.md`. 3+ similar = prevention rule

## Communication Rules (anti-deadlock)
- Down (parent -> child): YES at dispatch
- Up (child -> parent) BEFORE start: YES via BLOCKED + ClarificationRequest
- Up DURING execution: NO (fail-fast, partial report)
- Lateral (siblings): NO (coordinate via parent merge)
- Skip-level: NO (always through parent)
- CEO -> User: only CEO talks to user

## Thinking Modes (tier-allocated)

| Tier | Default | Escalation |
|------|---------|------------|
| CEO | think hard | ultrathink for ORCHESTRATE / ARCHITECTURE / INCIDENT-P0 / MIGRATE |
| VP | think hard | think harder for risk/prod/security |
| Lead | think | think hard for inter-IC conflicts |
| IC | none or think | think hard for hard debugging |

Raw modes: **think** (30-60s) | **think hard** (1-2min) | **think harder** (2-4min) | **ultrathink** (5-10min)

## Opus 4.7 Optimizations (active)
- Single-message multi-Agent dispatch for parallel VPs / Leads / ICs (Board Meeting pattern)
- Prompt cache prefixes: stable role + hierarchy FIRST, task-specific content LAST
- 5-min cache TTL aware (back-to-back fix loops keep prefix hot)
- 1M context only at CEO tier; lower tiers operate with scoped context
- Structured reports v2 (JSON-lite) preferred at IC/Lead tier
- Strict token budgets per report: VP 500, Lead 500, IC 400, Domain Plan 300

Detailed: see `.claude/skills/opus-47-optimizations/skill.md`.

## Context Curation per Tier
Each tier filters context downward (hierarchy is a compressor, not a relay).
Detailed: see `.claude/skills/context-curation-boundaries/skill.md`.

## Commands (27)

**Core**: `/do [anything]` (now v8.0 Agentic Corp), `/workflow`, `/research`, `/plan`, `/implement`, `/review`
**System**: `/mode`, `/context [analyze|optimize|reset]`, `/circuit-breaker [status|reset]`
**Audits**: `/security-audit`, `/seo-audit`, `/ux-review`, `/responsive-review`, `/theme-review`, `/i18n-review`
**Engineering**: `/architecture`, `/database`, `/api-design`, `/test-strategy`, `/devops`, `/secdevops`, `/tech-debt`
**Session**: `/generate-docs`, `/save-session`, `/resume-session`, `/learn`, `/retro`

## Agents (42 = 32 ICs + 10 new Tier 1/2)

### Tier 1 -- VPs (Opus, priority 1)
vp-engineering, vp-frontend, vp-quality, vp-platform, vp-strategy, vp-product

### Tier 2 -- Leads (Opus, priority 2, on-demand)
backend-lead, frontend-lead, devops-lead, quality-lead

### Tier 3 -- ICs (priority 1-5)
**Priority 1-2 (always loaded)**: plan-coordinator, code-coordinator, review-coordinator, programmer, docs-researcher, implementation-planner, chief-architect, code-implementer, brahma-investigator, **security-auditor** (Opus)

**Priority 3-5 (on-demand)**: software-architect, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer, mcp-builder, data-engineer, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, incident-commander, seo-strategist, business-analyst, content-strategist, product-strategist, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer, technical-writer

## Skills (58 = 42 v7.3 + 16 new)

### New in v8.0 (16)

**Agentic Corp orchestration (3)**:
- `hierarchical-orchestration` -- the 4-tier protocol (auto)
- `context-curation-boundaries` -- token budgets per tier (auto)
- `opus-47-optimizations` -- caching + parallel patterns (auto)

**Productivity (Matt Pocock + autoresearch, 5)**:
- `grill-me` -- relentless interrogation until shared understanding
- `caveman` -- 75% token compression, opt-in trigger
- `handoff` -- agent-to-agent handoff compaction
- `write-a-skill` -- skill creation methodology
- `autoresearch` -- optimize any skill via eval-driven mutations (Karpathy)

**Engineering methodology (Matt Pocock, 5)**:
- `diagnose` -- 6-phase bug methodology (+ hitl-loop script)
- `prototype` -- throwaway prototype workflow (+ LOGIC/UI variants)
- `tdd` -- red-green-refactor (+ 5 supporting docs)
- `improve-codebase-architecture` -- deepening opportunities (+ 3 docs)
- `zoom-out` -- broader perspective trigger

**Workflow tooling (Matt Pocock, 3)**:
- `git-guardrails-claude-code` -- block dangerous git ops via hooks
- `setup-pre-commit` -- Husky + lint-staged setup
- `review` (Matt Pocock) -- Standards + Spec parallel audit (collides with built-in `/review`)

## Project Structure

| Directory | Contents |
|-----------|----------|
| `.claude/agents/` | 42 agent definitions (6 VPs + 4 Leads + 32 ICs) |
| `.claude/skills/` | 58 skills (auto + manual) |
| `.claude/commands/` | 27 slash commands |
| `.claude/hooks/` | 21 lifecycle hooks |
| `.claude/templates/` | Shared templates, overview docs, agent.tmpl |
| `.claude/agent-configs/` | YAML configs for agent generator |
| `.claude/rules/` | Path-specific rules (security, code-quality, etc.) |
| `.claude/validators/` | API matcher + circuit breaker |

## Documentation (read on demand)

`.claude/templates/`: pyramid-orchestration.md (legacy), agents-overview.md, skills-overview.md, workflows-overview.md, quality-gates.md, think-protocol.md, agent-report-protocol.md
`.claude/agent-teams.md`: Parallel collaboration with persistent teammates

## Quick Fixes
- Plan <85 -> add rollback + complete file list
- Review <80 -> address critical findings
- vp-quality FAIL_FIX (iter <3) -> fix loop continues
- vp-quality FAIL_ESCALATE -> user intervention required
- Circuit breaker open -> `/circuit-breaker reset`
- Context too large -> `/context optimize` (or `/caveman` for extreme compression)
- Need broader perspective -> `/zoom-out`

## Compaction Preservation

When context compacts, ALWAYS preserve: modified files list, task status + next steps, FAIL entries, active spec paths (docs/specs/*.md), test commands + results, current VP iteration.

## Memory Hierarchy
1. Managed Policy > 2. Project (this file) > 3. Project Rules > 4. User (~/.claude/CLAUDE.md) > 5. Local (CLAUDE.local.md) > 6. Imports (@path, max 5 hops) > 7. Auto Memory

## Migration from v7.3 to v8.0
- `pyramid-loop` skill is DEPRECATED. Use `hierarchical-orchestration` instead.
- Legacy coordinator names preserved as aliases: plan-coordinator (IC under vp-strategy), code-coordinator (IC under vp-engineering), review-coordinator (IC under vp-quality).
- All existing agents continue to work as ICs in the new hierarchy.
- /do command rewritten: now classifies, opens Board Meeting (parallel VPs), confirms, executes, MANDATORY vp-quality audit, reports.
- Cost note: with Opus everywhere + strict hierarchy, expect ~5-10x cost increase per /do vs v7.3. Configurable later by switching ICs to Sonnet.
