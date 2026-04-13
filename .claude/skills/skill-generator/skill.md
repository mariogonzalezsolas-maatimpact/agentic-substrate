---
name: skill-generator
description: "Convert any documentation website, API reference, or knowledge source into a Claude Code skill. Extracts key patterns, creates skill.md with proper frontmatter, and organizes reference material."
auto_invoke: false
tags: [meta, skill-creation, documentation, knowledge-extraction]
---

# Skill Generator

Converts documentation websites, API references, or domain knowledge into structured Claude Code skills for the Agentic Substrate system.

## When to Invoke

- User wants to create a new skill from documentation
- Integrating a new library/framework that needs skill support
- Converting a workflow or methodology into a reusable skill
- User says "make a skill for X", "create skill from docs"

## Generation Protocol

### Step 1: Source Analysis

Identify the knowledge source:

| Source Type | Approach |
|------------|----------|
| Documentation website | Fetch key pages with `@docs-researcher` |
| API reference | Extract endpoints, auth, error patterns |
| Library/framework | Focus on setup, core API, common patterns, gotchas |
| Methodology | Extract steps, decision points, quality criteria |
| Existing codebase patterns | Extract conventions, architecture decisions |

### Step 2: Extract Core Knowledge

For each source, extract:

1. **When to use** - Trigger conditions for the skill
2. **Core concepts** - The 20% of knowledge that covers 80% of use cases
3. **Step-by-step protocol** - Actionable workflow
4. **Common patterns** - Code templates, configuration examples
5. **Anti-patterns** - What to avoid and why
6. **Integration points** - How it connects with other skills/agents
7. **Quality checklist** - How to verify correct usage

### Step 3: Structure as Skill

```markdown
---
name: [kebab-case-name]
description: "[One-line description under 200 chars. Be specific about capabilities.]"
auto_invoke: [true if should trigger automatically, false if manual]
tags: [relevant, tags, for, discovery]
---

# [Skill Name]

[1-2 sentence overview of what this skill provides.]

## When to Invoke

- [Trigger condition 1]
- [Trigger condition 2]
- [Trigger condition 3]

**Do NOT invoke when:**
- [Exclusion 1]
- [Exclusion 2]

## [Core Protocol / Methodology]

### Step 1: [First step]
[Content with code examples, tables, decision trees]

### Step 2: [Second step]
[Content]

## [Reference Tables / Quick Reference]

| Pattern | When | Example |
|---------|------|---------|
| ... | ... | ... |

## Quality Checklist

- [ ] [Verification item 1]
- [ ] [Verification item 2]

## Integration with Agentic Substrate

- [Which agents use this skill]
- [Which commands invoke it]
- [How it connects to the pyramid loop]

## Source
[Attribution and version information]
```

### Step 4: Validate

- [ ] Frontmatter has name, description, auto_invoke, tags
- [ ] Description is under 200 characters
- [ ] "When to Invoke" section has clear triggers
- [ ] Protocol has actionable steps (not just theory)
- [ ] Code examples are copy-paste ready
- [ ] Anti-patterns are documented
- [ ] Integration section connects to existing system
- [ ] Source attribution included

### Step 5: Register

1. Create directory: `.claude/skills/[skill-name]/`
2. Write `skill.md` in the directory
3. If the skill needs a slash command, create `.claude/commands/[command-name].md`
4. Update CLAUDE.md skill count if needed

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| Directory | kebab-case | `playwright-testing` |
| Skill name | kebab-case | `playwright-testing` |
| Tags | lowercase, singular | `testing`, `browser` |
| Description | Sentence case, no period | `Browser automation testing with Playwright` |

## Integration with Agentic Substrate

- Meta-skill: creates new skills for the system
- Works with `@docs-researcher` for source material gathering
- Created skills integrate with existing agents and commands
- Use `@technical-writer` for polishing skill documentation

## Source
Adapted from ComposioHQ/awesome-claude-skills skill-creator and Agentic Substrate conventions.
