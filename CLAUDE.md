# Agentic Substrate v7.2

Source repository for the Claude Code CLI enhancement system. Install via `install.sh` or `install.ps1`.

## Pyramid Orchestration

All code-producing `/do` routes use 3-tier pyramid: Orchestrator -> plan-coordinator -> code-coordinator -> review-coordinator. Review triggers fix loop (max 3 iterations). Browser testing via Playwright MCP.

## System Rules
- Never code from memory -- use @docs-researcher or /research first
- Every change: minimal, surgical, reversible
- TDD mandatory: RED -> GREEN -> REFACTOR
- Quality gates: Plan 85+, Tests pass, Review 80+
- Pyramid loop: plan -> code -> review -> fix (max 3 iterations)
- Circuit breaker opens after 3 failures: /circuit-breaker reset
- **Error Self-Tracking**: Log mistakes to `memory/errors.md`. 3+ similar errors = create prevention rule.

## Commands (26)

**Core workflow**: `/do [anything]` (recommended), `/workflow`, `/research`, `/plan`, `/implement`, `/review`
**System**: `/mode`, `/context [analyze|optimize|reset]`, `/circuit-breaker [status|reset]`
**Audits**: `/security-audit`, `/seo-audit`, `/ux-review`, `/responsive-review`, `/theme-review`, `/i18n-review`
**Engineering**: `/architecture`, `/database`, `/api-design`, `/test-strategy`, `/devops`, `/secdevops`, `/tech-debt`
**Session**: `/generate-docs`, `/save-session`, `/resume-session`, `/learn`

## Agents (32 = 8 Opus + 16 Sonnet + 8 Haiku)

- **Pyramid** (3): plan-coordinator, code-coordinator, review-coordinator
- **Orchestration** (1): chief-architect
- **Core** (5): docs-researcher, implementation-planner, brahma-analyzer, code-implementer, brahma-investigator
- **Engineering** (7): software-architect, programmer, database-architect, api-designer, testing-engineer, mcp-builder, data-engineer
- **Infrastructure** (6): devops-engineer, secdevops-engineer, brahma-deployer, brahma-monitor, brahma-optimizer, incident-commander
- **Growth & Quality** (10): seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer, technical-writer

## Quality Gates

| Transition | Threshold |
|------------|-----------|
| Research -> Plan | Score >= 80 |
| Plan -> Implement | Score >= 85 |
| Analysis | Score >= 80 |
| Implementation | Tests pass, circuit breaker closed |

## Thinking Modes
**think** (30-60s) | **think hard** (1-2min) | **think harder** (2-4min) | **ultrathink** (5-10min)

## Quick Fixes
- Research <80 -> specify library version explicitly
- Plan <85 -> add rollback procedure + complete file list
- Circuit breaker open -> `/circuit-breaker reset`
- Context too large -> `/context optimize`

## Project Context

| Directory | Contents |
|-----------|----------|
| `.claude/agents/` | 32 agent definitions |
| `.claude/skills/` | 23 skills (21 auto-invoked, 2 manual) |
| `.claude/commands/` | 26 slash commands |
| `.claude/hooks/` | 19 lifecycle hooks |
| `.claude/templates/` | Shared templates + overview docs |
| `.claude/rules/` | Path-specific rules (glob patterns) |
| `.claude/validators/` | API matcher + circuit breaker |
| `.claude/metrics/` | Workflow metrics tracker |
| `.claude/data/` | MCP config template |

## Detailed Documentation

See `.claude/templates/` for full details (read on demand, not auto-loaded):
- `pyramid-orchestration.md` -- 3-tier execution model, loop rules, coordinator protocols
- `agents-overview.md` -- All 32 agents with tiers, models, and invocation
- `skills-overview.md` -- 23 skills with triggers and integration
- `workflows-overview.md` -- All 34 routes, gates, and execution patterns
- `quality-gates.md` -- Scoring rubrics, thresholds, circuit breaker
- `think-protocol.md` -- Extended reasoning triggers and guidelines
- `AGENT-REPORT-PROTOCOL.md` -- Compact report format for agent output
- `.claude/agent-teams.md` -- Parallel collaboration with persistent teammates (in `.claude/`, not templates)

## Contributing

1. Research-first philosophy (research -> plan -> implement)
2. Test workflow changes end-to-end before committing
3. Keep agent files focused -- extract shared content to templates
4. Run `install.sh --force` or `install.ps1 -Force` to test installation

## Compaction Preservation

When context is auto-compacted, ALWAYS preserve:
- The full list of files modified in this session
- Current task status and next steps
- Any failed approaches (FAIL entries)
- Active plan or spec references (docs/specs/*.md paths)
- Test commands and their last results

## Memory Hierarchy
1. **Managed Policy** (admin-managed, highest priority)
2. **Project** (this file)
3. **Project Rules** (`.claude/rules/*.md`)
4. **User** (`~/.claude/CLAUDE.md`)
5. **Project Local** (`./CLAUDE.local.md`)
6. **Imports** via `@path/to/file.md` (max 5 hops)
7. **Auto Memory** (`~/.claude/projects/<hash>/memory/MEMORY.md`)
