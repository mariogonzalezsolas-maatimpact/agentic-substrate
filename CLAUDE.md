# Agentic Substrate v7.0

Source repository for the Claude Code CLI enhancement system. Users install to `~/.claude/` via `install.sh` or `install.ps1`.

## System Rules
- Never code from memory -- use @docs-researcher or /research first
- Every change: minimal, surgical, reversible
- TDD mandatory: RED -> GREEN -> REFACTOR
- Quality gates: Research 80+, Plan 85+, Tests pass
- Circuit breaker opens after 3 failures: /circuit-breaker reset
- **CRITICAL: Error Self-Tracking** -- When you make a mistake (wrong code, bad assumption, incorrect tool usage, failed approach), you MUST log it immediately in `memory/errors.md`. Read this file at the start of every session. Never repeat a documented error. This is your feedback loop for continuous improvement.

## Commands (22)
- `/do [anything]` -- Universal router with mandatory planning (RECOMMENDED)
- `/workflow [feature]` -- Full automation: research -> plan -> implement
- `/research [topic]` -- Fetch version-accurate docs (<2 min)
- `/plan [feature]` -- Create minimal-change blueprint
- `/implement` -- Execute plan with TDD + self-correction (3 retries)
- `/review [scope]` -- Multi-perspective code review (security + perf + architecture)
- `/mode [token-efficiency|introspection|default]` -- Switch behavioral modes
- `/context [analyze|optimize|reset]` -- Context health
- `/circuit-breaker [status|reset]` -- Manage circuit breaker
- `/security-audit [scope]` -- OWASP Top 10 + code security review
- `/seo-audit [scope]` -- Technical SEO + Core Web Vitals audit
- `/ux-review [scope]` -- WCAG 2.2 + usability heuristics audit
- `/responsive-review [scope]` -- Mobile-first, breakpoints, touch targets
- `/theme-review [scope]` -- Dark/light mode, design tokens, contrast
- `/i18n-review [scope]` -- Translations, RTL, pluralization, locale
- `/architecture [scope]` -- System design, patterns, ADRs, C4
- `/database [scope]` -- Schema design, migrations, query optimization
- `/api-design [scope]` -- REST/GraphQL/gRPC, OpenAPI specs
- `/test-strategy [scope]` -- Test architecture, coverage, TDD coaching
- `/devops [scope]` -- CI/CD, Docker, K8s, Terraform
- `/secdevops [scope]` -- SAST/DAST, supply chain, pipeline security
- `/tech-debt [scope]` -- Continuous tech debt reduction

## 25 Agents (5 Tiers, 3 Models)
- **Orchestrator** (opus): chief-architect
- **Core** (opus+sonnet): docs-researcher, implementation-planner, brahma-analyzer, code-implementer, brahma-investigator
- **Engineering** (opus+sonnet): software-architect, programmer, database-architect, api-designer, testing-engineer
- **Infrastructure** (sonnet): devops-engineer, secdevops-engineer, brahma-deployer, brahma-monitor, brahma-optimizer
- **Growth & Quality** (haiku+sonnet): seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer

### Model Distribution
- **Opus** (5): chief-architect, code-implementer, brahma-investigator, software-architect, programmer -- orchestration + deep reasoning + complex coding
- **Sonnet** (12): docs-researcher, implementation-planner, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, security-auditor, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer -- analysis + code + infrastructure
- **Haiku** (8): seo-strategist, business-analyst, content-strategist, product-strategist, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer -- checklist + content + review

## Quality Gates
@.claude/templates/quality-gates.md

| Transition | Threshold |
|------------|-----------|
| Research -> Plan | Score >= 80 |
| Plan -> Implement | Score >= 85 |
| Analysis | Score >= 80 |
| Implementation | Tests pass, circuit breaker closed |

## Thinking Modes
Add keyword: **think** (30-60s) | **think hard** (1-2min) | **think harder** (2-4min) | **ultrathink** (5-10min)

## Detailed Documentation
@.claude/templates/agents-overview.md
@.claude/templates/skills-overview.md
@.claude/templates/workflows-overview.md
@.claude/templates/quality-gates.md
@.claude/templates/think-protocol.md
@.claude/templates/AGENT-REPORT-PROTOCOL.md
@.claude/agent-teams.md

## Quick Fixes
- Research <80 -> specify library version explicitly
- Plan <85 -> add rollback procedure + complete file list
- Circuit breaker open -> `/circuit-breaker reset`
- Context too large -> `/context optimize`

## Project Context

This repository is the **source** for the Agentic Substrate. Key directories:

| Directory | Contents |
|-----------|----------|
| `.claude/agents/` | 25 agent definitions |
| `.claude/skills/` | 9 auto-invoked skills |
| `.claude/commands/` | 22 slash commands |
| `.claude/hooks/` | 13 lifecycle hooks |
| `.claude/templates/` | Shared templates + overview docs |
| `.claude/rules/` | Path-specific rules (glob patterns) |
| `.claude/validators/` | API matcher + circuit breaker |
| `.claude/metrics/` | Workflow metrics tracker |
| `.claude/data/` | MCP config template |

## Contributing

1. Follow the research-first philosophy (research -> plan -> implement)
2. Test workflow changes end-to-end before committing
3. Keep agent files focused -- extract shared content to templates
4. Run `install.sh --force` or `install.ps1 -Force` to test installation

## Memory Hierarchy
1. **Managed Policy** (admin-managed, highest priority)
2. **Project** (this file)
3. **Project Rules** (`.claude/rules/*.md`) — path-specific instructions
4. **User** (`~/.claude/CLAUDE.md`)
5. **Project Local** (`./CLAUDE.local.md`) — personal, auto-gitignored
6. **Imports** via `@path/to/file.md` (max 5 hops)
7. **Auto Memory** (`~/.claude/projects/<hash>/memory/MEMORY.md`)
