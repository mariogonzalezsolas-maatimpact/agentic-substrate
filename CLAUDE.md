# Agentic Substrate v7.2.1

Source repository for the Claude Code CLI enhancement system. Install via `install.sh` or `install.ps1`.

## System Rules
- Never code from memory -- use @docs-researcher or /research first
- Every change: minimal, surgical, reversible. TDD: RED -> GREEN -> REFACTOR
- Pyramid loop: plan -> code -> review -> fix (max 3 iterations)
- Quality gates: Research 80+ | Plan 85+ | Review 80+ | Tests pass, circuit breaker closed
- Error self-tracking: log to `memory/errors.md`. 3+ similar = prevention rule
- Thinking: **think** (30-60s) | **think hard** (1-2min) | **think harder** (2-4min) | **ultrathink** (5-10min)

## Commands (27)

**Core**: `/do [anything]`, `/workflow`, `/research`, `/plan`, `/implement`, `/review`
**System**: `/mode`, `/context [analyze|optimize|reset]`, `/circuit-breaker [status|reset]`
**Audits**: `/security-audit`, `/seo-audit`, `/ux-review`, `/responsive-review`, `/theme-review`, `/i18n-review`
**Engineering**: `/architecture`, `/database`, `/api-design`, `/test-strategy`, `/devops`, `/secdevops`, `/tech-debt`
**Session**: `/generate-docs`, `/save-session`, `/resume-session`, `/learn`, `/retro`

## Agents (32 = 8 Opus + 16 Sonnet + 8 Haiku)

Priority 1-2 (always loaded): plan-coordinator, code-coordinator, review-coordinator, programmer, docs-researcher, implementation-planner, chief-architect, code-implementer, brahma-investigator
Priority 3-5 (on-demand): software-architect, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer, mcp-builder, data-engineer, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, incident-commander, seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer, technical-writer

## Project Structure

| Directory | Contents |
|-----------|----------|
| `.claude/agents/` | 32 agent definitions (priority 1-5 frontmatter) |
| `.claude/skills/` | 23 skills (21 auto-invoked, 2 manual) |
| `.claude/commands/` | 27 slash commands |
| `.claude/hooks/` | 20 lifecycle hooks |
| `.claude/templates/` | Shared templates, overview docs, agent.tmpl |
| `.claude/agent-configs/` | YAML configs for agent generator |
| `.claude/rules/` | Path-specific rules |
| `.claude/validators/` | API matcher + circuit breaker |

## Documentation (read on demand)

`.claude/templates/`: pyramid-orchestration.md, agents-overview.md, skills-overview.md, workflows-overview.md, quality-gates.md, think-protocol.md, agent-report-protocol.md
`.claude/agent-teams.md`: Parallel collaboration with persistent teammates

## Quick Fixes
- Plan <85 -> add rollback + complete file list | Review <80 -> address critical findings
- Circuit breaker open -> `/circuit-breaker reset` | Context too large -> `/context optimize`

## Compaction Preservation

When context compacts, ALWAYS preserve: modified files list, task status + next steps, FAIL entries, active spec paths (docs/specs/*.md), test commands + results.

## Memory Hierarchy
1. Managed Policy > 2. Project (this file) > 3. Project Rules > 4. User (~/.claude/CLAUDE.md) > 5. Local (CLAUDE.local.md) > 6. Imports (@path, max 5 hops) > 7. Auto Memory
