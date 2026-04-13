# Project Architecture

Auto-generated architecture summary for context optimization. Updated by `/context optimize`.

## Stack

Detected from project files. Update as needed.

| Layer | Technology |
|-------|-----------|
| Type | Claude Code CLI Enhancement System |
| Format | Markdown-based agents, skills, commands, hooks |
| Install | Python setup.py / Bash install.sh / PowerShell install.ps1 |
| Target | ~/.claude/ directory |

## Key Directories

| Directory | Purpose | Count |
|-----------|---------|-------|
| `.claude/agents/` | Agent definitions | 28 |
| `.claude/commands/` | Slash commands | 22 |
| `.claude/skills/` | Auto-invoked skills | 16 |
| `.claude/hooks/` | Lifecycle hooks | 19 |
| `.claude/templates/` | Shared templates | 18 |
| `.claude/validators/` | Quality gates | 2 |
| `.claude/rules/` | Path-specific rules | 3 |
| `scripts/` | Install/update scripts | 6 |
| `docs/` | Documentation | 8 |

## Architecture Pattern

3-tier pyramid orchestration:
```
Orchestrator (main thread) -> plan-coordinator -> code-coordinator -> review-coordinator
```

Review triggers fix loop (max 3 iterations). See `.claude/templates/pyramid-orchestration.md`.

## Entry Points

- `/do [anything]` — Universal command router
- `@agent-name [task]` — Direct agent invocation
- `python setup.py` — Installation

---

**Updated**: 2026-04-13 | **Version**: 7.3.0
