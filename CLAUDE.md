# Agentic Substrate v7.2

Source repository for the Claude Code CLI enhancement system. Users install to `~/.claude/` via `install.sh` or `install.ps1`.

## Pyramid Orchestration (NEW in v7.2)

All code-producing `/do` routes now use 3-tier pyramid orchestration by default:

```
Tier 1: Orchestrator (main thread) -- classifies, dispatches, synthesizes
Tier 2: @plan-coordinator -> @code-coordinator -> @review-coordinator
         (research+plan)     (TDD implement)     (code+browser review)
```

Review-coordinator triggers a **fix loop** back to plan-coordinator if issues found (max 3 iterations). Browser testing via Playwright MCP.

@.claude/templates/pyramid-orchestration.md

## System Rules
- Never code from memory -- use @docs-researcher or /research first
- Every change: minimal, surgical, reversible
- TDD mandatory: RED -> GREEN -> REFACTOR
- Quality gates: Plan 85+, Tests pass, Review 80+
- Pyramid loop: plan -> code -> review -> fix (max 3 iterations)
- Circuit breaker opens after 3 failures: /circuit-breaker reset
- **CRITICAL: Error Self-Tracking** -- When you make a mistake, log it to `memory/errors.md` immediately. The auto-error-capture hook logs subagent failures automatically. Read errors.md at session start (auto-loaded by session-start hook). Check for patterns: 3+ similar errors = create a prevention rule. Never repeat a documented error. This is your feedback loop for continuous improvement.

## Commands (26)
- `/do [anything]` -- Universal router with pyramid orchestration (RECOMMENDED)
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
- `/generate-docs` -- Generate/migrate .claude/ structure for any project (Spanish)
- `/save-session` -- Save current session state for later resumption
- `/resume-session` -- Load saved session and resume with full context
- `/learn` -- Extract reusable patterns from session into memory

## 32 Agents (5 Tiers + Pyramid Coordinators, 3 Models)
- **Pyramid Coordinators** (opus+sonnet): plan-coordinator (opus), code-coordinator (opus), review-coordinator (sonnet)
- **Orchestrator** (opus): chief-architect
- **Core** (opus+sonnet): docs-researcher, implementation-planner, brahma-analyzer, code-implementer, brahma-investigator
- **Engineering** (opus+sonnet): software-architect, programmer, database-architect, api-designer, testing-engineer, mcp-builder, data-engineer
- **Infrastructure** (sonnet): devops-engineer, secdevops-engineer, brahma-deployer, brahma-monitor, brahma-optimizer, incident-commander
- **Growth & Quality** (haiku+sonnet): seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer, technical-writer

### Model Distribution
- **Opus** (8): chief-architect, code-implementer, brahma-investigator, software-architect, programmer, plan-coordinator, code-coordinator, mcp-builder -- orchestration + deep reasoning + complex coding
- **Sonnet** (16): docs-researcher, implementation-planner, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, security-auditor, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer, review-coordinator, technical-writer, data-engineer, incident-commander -- analysis + code + infrastructure + review + docs + data + incidents
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
@.claude/templates/pyramid-orchestration.md
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
| `.claude/agents/` | 32 agent definitions |
| `.claude/skills/` | 22 skills (20 auto-invoked, 2 manual) |
| `.claude/commands/` | 26 slash commands |
| `.claude/hooks/` | 18 lifecycle hooks |
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

## Compaction Preservation

When context is auto-compacted, ALWAYS preserve:
- The full list of files modified in this session
- Current task status and next steps
- Any failed approaches (FAIL entries) -- these prevent retry loops
- Active plan or spec references (docs/specs/*.md paths)
- Test commands and their last results

## Memory Hierarchy
1. **Managed Policy** (admin-managed, highest priority)
2. **Project** (this file)
3. **Project Rules** (`.claude/rules/*.md`) — path-specific instructions
4. **User** (`~/.claude/CLAUDE.md`)
5. **Project Local** (`./CLAUDE.local.md`) — personal, auto-gitignored
6. **Imports** via `@path/to/file.md` (max 5 hops)
7. **Auto Memory** (`~/.claude/projects/<hash>/memory/MEMORY.md`)
