# Project Knowledge Core - Agentic Substrate v7.2

**Last Updated**: 2026-03-25
**Version**: 7.2.0 (32-Agent System with Pyramid Orchestration, Quality Gates, Model Mixing & Error Learning)
**Project**: Claude User Memory → Agentic Substrate

**Purpose**: Single source of truth for architectural decisions, established patterns, and key learnings. Persistent memory for all AI agents working on the Agentic Substrate system.

**Agent Instructions**:
1. **READ FIRST**: Before starting any task, read this file to understand the project's context and history.
2. **ADHERE TO PATTERNS**: Your work must be consistent with the patterns and decisions documented here.
3. **SUGGEST UPDATES**: Upon completing a significant task, suggest additions to this file in your final report.

---

## Architectural Principles

### Principle 1: Agentic Substrate Philosophy
**Established**: 2025-10-18

The Agentic Substrate is the **foundational layer that agents build upon** to achieve superintelligent capabilities:

- **Agent autonomy first**: Minimal scaffolding, maximum model control (Anthropic pattern)
- **Context engineering as first-class discipline**: What goes into context matters more than prompt wording
- **Think before act**: Extended thinking for complex decisions (54% improvement)
- **Economic viability**: Multi-agent costs 15x tokens, requires 15x+ value
- **Truth over speed**: Achieve both through systematic approach
- **Synthesis over imitation**: Integrate best patterns from multiple sources (Philia Sophia)

### Principle 2: Research -> Plan -> Implement Workflow
**Established**: 2024-07-30 (Enhanced 2025-10-18, Pyramid added 2026-03-25)

All development follows strict workflow:
1. **Research Phase**: Gather authoritative, version-accurate documentation (docs-researcher)
2. **Planning Phase**: Create minimal-change, reversible implementation plans (plan-coordinator / implementation-planner)
3. **Implementation Phase**: Execute with TDD and self-correction (code-coordinator / code-implementer)
4. **Review Phase** (v7.2): Code review + browser testing with fix loop (review-coordinator)

**Quality Gates**: Each phase has validation before proceeding. Review gate triggers fix loop (max 3 iterations).

### Principle 3: Minimal Changes, Maximum Safety
**Established**: 2024-07-31

Every change must be: **Surgical** (fewest files), **Reversible** (include rollback), **Incremental** (independently valuable), **Tested** (TDD mandatory), **Documented** (git commits with co-author attribution).

### Principle 4: Memory Hierarchy and Import Syntax
**Established**: 2025-10-18

7-level memory hierarchy: Managed Policy > Project > Project Rules > User > Project Local > Imports (@path, max 5 hops) > Auto Memory.

### Principle 5: Quality Over Speed (But Achieve Both)
**Established**: 2025-10-18

Never sacrifice quality for performance. Use systematic approach to achieve both. Real-world validation over synthetic benchmarks.

### Principle 6: 32-Agent Architecture with Pyramid Orchestration
**Established**: 2025-10-18 (Expanded: 9→15 in v5.2, 15→25 in v7.0, 25→32 in v7.2)

The complete agent system with 32 specialized agents organized in 5 tiers + pyramid coordinators:

**Architecture (v7.2)**:
```
Pyramid Coordinators (3 agents - DEFAULT EXECUTION MODEL)
  ├─ plan-coordinator (opus): Research + plan
  ├─ code-coordinator (opus): TDD implementation
  └─ review-coordinator (sonnet): Code review + browser testing

Tier 1: Orchestrator (1 agent)
  └─ chief-architect (opus): Multi-agent coordination, parallel execution

Tier 2: Core Workflow (5 agents - BUILD + FIX)
  ├─ docs-researcher (sonnet): Fetch version-accurate docs
  ├─ implementation-planner (sonnet): Minimal-change blueprints
  ├─ brahma-analyzer (sonnet): Quality gate (80+ score)
  ├─ code-implementer (opus): TDD + 3-retry self-correction
  └─ brahma-investigator (opus): Root-cause analysis

Tier 3: Engineering (7 agents)
  ├─ software-architect (opus): System design, C4, ADRs, SOLID/DDD
  ├─ programmer (opus): General-purpose coding, algorithms, prototyping
  ├─ database-architect (sonnet): Schema design, migrations, query optimization
  ├─ api-designer (sonnet): REST/GraphQL/gRPC, OpenAPI specs
  ├─ testing-engineer (sonnet): Test strategy, coverage, TDD coaching
  ├─ mcp-builder (opus): MCP server design, tool interfaces
  └─ data-engineer (sonnet): ETL/ELT pipelines, data lakes, streaming

Tier 4: Infrastructure (6 agents - SERVE)
  ├─ devops-engineer (sonnet): CI/CD, Docker, K8s, Terraform
  ├─ secdevops-engineer (sonnet): SAST/DAST, supply chain security
  ├─ brahma-deployer (sonnet): Canary deployment + auto-rollback
  ├─ brahma-monitor (sonnet): Metrics, Logs, Traces
  ├─ brahma-optimizer (sonnet): Profiling, optimization, scaling
  └─ incident-commander (sonnet): Incident response, post-mortems

Tier 5: Growth & Quality (10 agents - GROW)
  ├─ seo-strategist (haiku): Technical SEO, Core Web Vitals
  ├─ business-analyst (haiku): Requirements, ROI
  ├─ content-strategist (haiku): Brand voice, content marketing
  ├─ product-strategist (haiku): Market analysis, roadmaps
  ├─ security-auditor (sonnet): OWASP Top 10, compliance
  ├─ ux-accessibility-reviewer (haiku): WCAG 2.2, usability
  ├─ responsive-reviewer (haiku): Breakpoints, mobile-first
  ├─ theme-reviewer (haiku): Dark/light mode, design tokens
  ├─ i18n-reviewer (haiku): Translations, RTL, pluralization
  └─ technical-writer (sonnet): READMEs, API references, tutorials
```

**Model Distribution**: 8 Opus (orchestration + deep reasoning + complex coding) + 16 Sonnet (analysis + code + infrastructure) + 8 Haiku (checklist + content + review)

---

## Established Patterns

### Pattern 1: Pyramid Orchestration (v7.2)

**Context**: All code-producing tasks need planning, coding, and review
**Problem**: Sequential single-agent execution misses bugs, lacks review discipline
**Established**: 2026-03-25

**Solution**: 3-tier pyramid with automatic fix loop

```
Tier 1: Orchestrator (main thread) -- classifies, dispatches, synthesizes
Tier 2: plan-coordinator -> code-coordinator -> review-coordinator
Tier 3: Coordinators handle specialties internally
```

**Loop**: Plan -> Code -> Review -> Fix (max 3 iterations). Review FAIL triggers plan-coordinator re-plan.

**Key Constraint**: Sub-agents cannot spawn other sub-agents. Orchestrator manages all dispatching.

**Cost**: 3 agent calls (happy path), 6 (1 fix loop), 9 (max fix loops)

**Files**: `.claude/agents/plan-coordinator.md`, `.claude/agents/code-coordinator.md`, `.claude/agents/review-coordinator.md`, `.claude/skills/pyramid-loop/skill.md`, `.claude/templates/pyramid-orchestration.md`

---

### Pattern 2: Think Tool Protocol for Complex Decisions

**Established**: 2025-10-18

Extended thinking modes for progressively deeper reasoning:
- **"think"** (30-60s): Routine decisions
- **"think hard"** (1-2min): Multiple valid approaches
- **"think harder"** (2-4min): Novel problems, high-stakes
- **"ultrathink"** (5-10min): Critical architecture, multi-agent coordination

**Performance**: 54% improvement on complex tasks (Anthropic research)

**Files**: `.claude/templates/think-protocol.md`, all 32 agents include Think Protocol section

---

### Pattern 3: Context Engineering and Active Curation

**Established**: 2025-10-18

Active context curation as first-class discipline. Triggers: >50 messages, task switch, before complex ops, after major learnings.

**Performance**: 39% improvement, 84% token reduction

**Files**: `.claude/skills/context-engineering/skill.md`, `.claude/commands/context.md`

---

### Pattern 4: Multi-Agent Parallel Spawning with Economic Viability Gates

**Established**: 2025-10-18

Lead agent spawns 3-5 subagents in parallel. Economic viability check mandatory (15x cost).

**Performance**: 90.2% performance gain, up to 90% time reduction

**Files**: `.claude/agents/chief-architect.md`, `.claude/hooks/check-agent-economics.sh`

---

### Pattern 5: TDD Enforcement (Mandatory)

**Established**: 2025-10-18

Red -> Green -> Refactor cycle. Cycle time: 6-10 min per feature unit. Tests must be written BEFORE implementation. All tests must pass before commit.

**Files**: `.claude/agents/code-implementer.md`, `.claude/agents/code-coordinator.md`

---

### Pattern 6: Git Automation with Co-Author Attribution

**Established**: 2025-10-18

Automated git operations. Co-author: `Co-Authored-By: Claude <noreply@anthropic.com>`. Only commit if tests pass. Never commit secrets.

---

### Pattern 7: Multi-Modal Quality Validation

**Established**: 2025-10-18

Research type detection with specialized scoring rubrics:
- API/Library Research: 80+ pass threshold
- Philosophy Research: 70+ pass threshold
- Pattern Research: 75+ pass threshold
- Methodology Research: 75+ pass threshold

**Files**: `.claude/skills/quality-validation/skill.md`

---

### Pattern 8: Error Self-Learning (v7.1)

**Established**: 2026-03-10

Auto-captures errors to `memory/errors.md`. 6 categories. Pattern detection: 3+ similar errors escalate to prevention rules.

**Files**: `.claude/skills/error-learning/skill.md`, `.claude/hooks/auto-error-capture.sh`

---

### Pattern 9: Hawk Oversight (v7.1)

**Established**: 2026-03-10

Real-time PostToolUse hook detecting chaotic oscillation, reward hacking, destructive ops, error swallowing.

**Files**: `.claude/hooks/hawk.sh`, `.claude/templates/hawk-pattern.md`

---

### Pattern 10: Anti-Reward-Hacking Rules (v7.1)

**Established**: 2026-03-10

Prevents: test.skip abuse, generic error swallowing, mock abuse, force-installing, evidence deletion.

**Files**: `.claude/rules/anti-reward-hacking.md`

---

### Pattern 11: Linked Chunks (v7.1)

**Established**: 2026-03-10

`@linked` references create explicit dependency graphs. Read all linked files before editing. Update linked docs if behavior changes.

**Files**: `.claude/rules/linked-chunks.md`

---

### Pattern 12: Agent Report Protocol (v7.0, enhanced v7.2)

**Established**: 2026-02-27 (Pyramid-aware v1.2: 2026-03-25)

Compact report format (<800 tokens) for all agents. Pyramid coordinators use specialized formats (<500 tokens each). Lead processes ~1500 tokens per iteration.

**Files**: `.claude/templates/AGENT-REPORT-PROTOCOL.md`

---

### Pattern 13: Memory Hierarchy and Modular Organization

**Established**: 2025-10-18

Import syntax (`@path/to/file.md`, max 5 hops) for modular CLAUDE.md organization. Prevents bloat, enables team + individual preferences.

---

### Pattern 14: Contextual Retrieval for Research

**Established**: 2025-10-18

Prepend chunk-specific explanatory context before embedding/indexing.

**Performance**: 49% reduction in failed retrievals (standalone), 67% with reranking

---

## Key Decisions & Learnings

### (2026-03-25) Pyramid Orchestration as Default Execution Model

**Decision**: All code-producing `/do` routes use 3-tier pyramid by default (plan -> code -> review -> fix loop)

**Rationale**: Catches bugs before production, prevents repeated user back-and-forth, browser testing catches UI issues that code review misses

**Impact**: 3 new pyramid coordinators + 4 new specialist agents (mcp-builder, data-engineer, incident-commander, technical-writer), 13 new skills (pyramid-loop + 5 frontend/design + 3 process/quality + generate-docs + auto-memory-capture + nextjs-firebase-gcp + django-patterns), agents 25→32, skills 10→23

---

### (2026-03-10) Error Self-Tracking and Hawk Oversight

**Decision**: Auto-capture errors, detect anti-patterns in real-time

**Impact**: 4 new hooks (auto-error-capture, hawk, session-start update, Stop hook), 1 new skill (error-learning), 3 new rules, 3 new templates

---

### (2026-02-27) 10 New Engineering + Quality Agents

**Decision**: Expand from 15 to 25 agents with Engineering tier (5 agents) + expanded Infrastructure and Quality tiers

**Impact**: 9 new commands, 4 new skills, Agent Report Protocol standardized

---

### (2025-10-25) Adaptive Learning Integration

**Decision**: Hybrid architecture for pattern learning (human-readable knowledge-core.md + machine-readable pattern-index.json)

**Bayesian Confidence**: `confidence = base_confidence x time_decay x evidence_factor`

**Expected**: 30-40% faster implementations on 5th+ similar feature

---

### (2025-10-18) "Agentic Substrate" as Project Identity

**Decision**: Adopt "Agentic Substrate" term. Repository stays `claude-user-memory` for SEO, README uses "Agentic Substrate"

**Tagline**: "The foundational layer for Claude Code superintelligence"

---

### (2025-10-18) Philia Sophia Synthesis Approach

**Decision**: Synthesize Anthropic + VAMFI patterns (not imitate, integrate)

From Anthropic: agent autonomy, context engineering, think-before-act, multi-agent economics, truth over speed
From VAMFI: Brahma orchestration, autonomous operation, quality gates, knowledge preservation, surgical changes, self-correction, circuit breaker

---

### Anti-Pattern: Documentation-Implementation Mismatch

**Identified**: 2025-11-06 | **Severity**: CRITICAL

Documentation must match reality. Automated validation (agent count matches files). Regular reviews with each major version. Score of 32/100 is unacceptable -- must be 90+.

**Fixed**: Ongoing enforcement via version bumps and CHANGELOG

---

### Anti-Pattern: Soft Quality Gates Pretending to be Hard

**Identified**: 2025-11-06

Quality gates must use `exit 1` (not `exit 0` with warnings). Add `--force` override for prototyping. Clear error messages.

---

## Performance Metrics & Benchmarks

### Anthropic Research Findings

| Metric | Result |
|--------|--------|
| Think Tool | 54% improvement on complex tasks |
| Context Engineering | 39% improvement, 84% token reduction |
| Multi-Agent Parallel | 90.2% performance gain, 90% time reduction |
| Contextual Retrieval | 49-67% reduction in failed retrievals |
| Git Automation | 90%+ of git interactions via Claude |

### Agentic Substrate Performance

| Metric | Before | After |
|--------|--------|-------|
| API Integration | 55 min | 10 min (5.5x) |
| Feature Implementation | 120 min | 25 min (4.8x) |
| Code Quality | Variable | 95%+ accuracy |

---

## Sources & References

### Anthropic Official Sources

1. Building agents with the Claude Agent SDK (Sep 29, 2025)
2. Building effective agents (2025)
3. Effective context engineering for AI agents (Sep 29, 2025)
4. A postmortem of three recent issues (Sep 17, 2025)
5. Writing effective tools for agents (Sep 11, 2025)
6. Desktop Extensions: One-click MCP server installation (Jun 26, 2025)
7. How we built our multi-agent research system (Jun 13, 2025)
8. Claude Code: Best practices for agentic coding (Apr 18, 2025)
9. The "think" tool: Enabling Claude to stop and think (Mar 20, 2025)
10. Raising the bar on SWE-bench Verified (Oct 2024)
11. Introducing Contextual Retrieval (Sep 2024)

---

**Last updated**: 2026-03-25 by Agentic Substrate v7.2 upgrade
**Major enhancement**: v7.2 - Pyramid Orchestration, 32 agents (8 Opus + 16 Sonnet + 8 Haiku), Review Gate, fix loop
**Next review**: Ongoing (review with each major version)
