---
name: folder-context
description: "Auto-generate lightweight CLAUDE.md context files in project subdirectories based on memory observations. Wraps generated content in <!-- claude-mem-context --> tags."
auto_invoke: false
tags: [memory, context, folder, documentation, organization]
---

# Folder Context Skill

Generates lightweight CLAUDE.md context files in project subdirectories based on accumulated memory observations. Provides directory-level context without requiring manual documentation.

## When Claude Should Use This Skill

Claude will invoke this skill when:
- User runs `/folder-context` command
- User asks to "generate context files" or "add directory context"
- User asks to "clean up generated context" (cleanup mode)

**Do NOT invoke when:**
- No persistent memory exists for the project
- Directory already has a human-written CLAUDE.md with sufficient context
- Working outside a project directory

**Boundary with project-organization skill**: project-organization handles top-level project structure and CLAUDE.md. folder-context handles subdirectory-level context files generated from memory observations.

## Generate Protocol

### Step 1: Scan Memory

Read MEMORY.md index (Layer 1 from memory-search skill). Identify memories that reference specific directories or file paths within the project.

Group observations by directory:
```
src/auth/  --> [feedback_auth_session.md, project_auth_rewrite.md]
src/api/   --> [feedback_api_rate_limit.md]
lib/cache/ --> [project_redis_migration.md, feedback_cache_ttl.md]
```

### Step 2: Build Context

For each directory with 2+ relevant observations:
- Extract key facts from matched memories (use Layer 2/3 from memory-search)
- Summarize into concise directory context (max 30 lines)
- Format with marker tags

### Step 3: Write CLAUDE.md

For each target directory:

**If no CLAUDE.md exists**: Create one with only the generated block.

**If CLAUDE.md exists**: Append the generated block. NEVER modify existing human-written content.

Generated content format:
```markdown
<!-- claude-mem-context:start -->
<!-- Auto-generated from memory observations. Do not edit manually. -->
<!-- Last updated: YYYY-MM-DD -->

## Memory Context

- [Observation 1 from memory]
- [Observation 2 from memory]
- [Key decision or constraint]

<!-- claude-mem-context:end -->
```

### Step 4: Report

Output a summary of what was generated:
```
Folder context generated:
- src/auth/CLAUDE.md: 3 observations (created)
- src/api/CLAUDE.md: 2 observations (appended)
- lib/cache/CLAUDE.md: 2 observations (created)
Skipped: src/utils/ (only 1 observation, need 2+)
```

## Cleanup Mode

Remove all generated context blocks across the project:

1. Find all CLAUDE.md files in subdirectories
2. Remove content between `<!-- claude-mem-context:start -->` and `<!-- claude-mem-context:end -->` markers
3. If the file is now empty (contained only generated content), delete the file
4. Report what was removed

## Rules

- **Never modify human content**: Only touch content within `<!-- claude-mem-context -->` markers
- **Max 30 lines per directory**: Keep generated blocks concise. Summarize, do not dump raw memories
- **Minimum 2 observations**: A directory needs 2+ memory references to justify a context file
- **No nested generation**: Only generate for immediate subdirectories with observations, not recursive
- **Idempotent**: Running twice produces the same result. Old generated blocks are replaced, not duplicated
- **Respect .gitignore**: Do not generate context files in ignored directories
