# Agent Template System Guide

## Quick Start: Create a New Agent

1. Copy the example config:
   ```bash
   cp .claude/agent-configs/programmer.yaml .claude/agent-configs/my-agent.yaml
   ```
2. Edit the YAML with your agent's unique content
3. Generate the agent markdown:
   ```bash
   ./scripts/generate-agents.sh my-agent
   ```

## Regenerate All Agents

```bash
./scripts/generate-agents.sh           # write all .md files
./scripts/generate-agents.sh --dry-run # preview without writing
```

## Config YAML Format

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | Agent identifier (matches filename) |
| `description` | string | yes | One-line description for frontmatter |
| `model` | string | yes | `opus`, `sonnet`, or `haiku` |
| `tools` | string | yes | Comma-separated tool list |
| `maxTurns` | int | yes | Max conversation turns |
| `skills` | list | no | Skill names (omit key entirely if none) |
| `memory` | string | yes | Memory scope (`project`, `user`, etc.) |
| `priority` | int | yes | Agent priority (1=highest) |
| `title` | string | yes | Display name for the `# Title` heading |
| `role` | block | yes | Role description paragraph |
| `philosophy` | list | yes | Philosophy bullet points |
| `expertise` | list | yes | Technical expertise bullets |
| `scope_do` | list | yes | What the agent does |
| `scope_dont` | list | yes | What the agent does not do |
| `scope_boundary` | block | yes | Boundary clarification paragraph |
| `file_ownership` | list | yes | Files the agent owns |
| `communication_style` | block | no | Communication style bullets (omit if not needed) |
| `custom_sections` | block | yes | Agent-specific protocol sections (bulk of unique content) |
| `quality_gates` | list | yes | Quality gate checklist items |

## Migration Status

Existing `.claude/agents/*.md` files remain the **source of truth** until each agent has a corresponding config in `.claude/agent-configs/`. Migrate agents incrementally -- the generator only overwrites files for configs that exist.
