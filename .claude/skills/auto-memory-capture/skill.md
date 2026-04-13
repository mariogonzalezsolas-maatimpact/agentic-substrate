---
name: auto-memory-capture
description: "Automatic memory capture with compression, token awareness, deduplication, and budget tracking. Saves decisions, failed approaches, and patterns to persistent memory. Prevents knowledge loss and token waste."
auto_invoke: true
tags: [memory, capture, session, persistence, learning]
---

# Auto Memory Capture Skill

Ensures important session knowledge is captured to the memory system before it's lost to context compression or session end.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- A significant decision is made (architecture, technology choice, approach selection)
- An approach is tried and FAILS (critical to prevent retry in future sessions)
- A non-obvious solution is found after multiple attempts
- User provides project context that should persist (deadlines, constraints, stakeholders)
- Session is approaching context limits (compaction imminent)

**Do NOT invoke when:**
- Information is already in CLAUDE.md or existing memory files
- The observation is trivial (typos, simple syntax fixes)

**Boundary with error-learning skill**: error-learning captures CODE-LEVEL errors (test failures, build failures, circuit breaker events) to `memory/errors.md`. auto-memory-capture captures STRATEGIC decisions and APPROACH failures (technology choices, architecture dead-ends, failed integration attempts) to the persistent memory system. If a test fails, error-learning handles it. If an approach was tried and abandoned, auto-memory-capture handles it.

## What to Capture

### High Priority (capture immediately)
1. **Failed approaches** -- What was tried, exact error, why it failed. Format:
   ```
   FAIL: [approach] -- [exact error or reason]
   ```
   This is the MOST VALUABLE type of memory. Future sessions will blindly retry failed approaches without this.

2. **Architecture decisions** -- Why X was chosen over Y, constraints considered
3. **User corrections** -- When the user says "no, do it this way" -- save the preference
4. **Non-obvious solutions** -- Workarounds, library quirks, version-specific fixes

### Medium Priority (capture at natural breakpoints)
5. **Project constraints** -- Deadlines, compliance requirements, stakeholder preferences
6. **Integration discoveries** -- How systems connect, undocumented APIs, auth flows
7. **Performance findings** -- Bottlenecks identified, optimization approaches that worked

### Low Priority (capture if convenient)
8. **Useful commands** -- Non-obvious CLI commands or scripts that solved problems
9. **Configuration details** -- Environment-specific settings that took time to discover

## Capture Protocol

### Step 1: Identify the Observation

Ask: "Would a future session benefit from knowing this?"
- If YES: proceed to capture
- If NO: skip

### Step 2: Classify the Memory Type

| Observation | Memory Type | File Pattern |
|------------|-------------|--------------|
| User preference or correction | `feedback` | `feedback_[topic].md` |
| Project decision or constraint | `project` | `project_[topic].md` |
| User role or knowledge context | `user` | `user_[topic].md` |
| External resource location | `reference` | `reference_[topic].md` |
| Failed approach | `feedback` | `feedback_[what-failed].md` |

### Step 3: Write to Memory

Use the standard memory format:
```markdown
---
name: [descriptive name]
description: [one-line -- used for relevance matching]
type: [feedback|project|user|reference]
---

[Content]

**Why:** [context]
**How to apply:** [when this is relevant]
```

Save to: `~/.claude/projects/<project-hash>/memory/[filename].md`
Update: `MEMORY.md` index with one-line pointer.

### Step 4: "What Did NOT Work" Pattern

Adapted from claude-mem. When capturing failed approaches, use this structured format:

```markdown
---
name: failed-[approach-name]
description: [approach] failed because [reason] -- do not retry
type: feedback
---

FAIL: [What was attempted]
ERROR: [Exact error message or behavior]
REASON: [Root cause analysis]
CONTEXT: [When this was tried -- date, project state]

**Why:** Prevents future sessions from retrying this approach
**How to apply:** If considering [approach], check this memory first. The issue is [root cause] which has not been resolved.
```

## Integration with /save-session

When `/save-session` is invoked, auto-memory-capture ensures the "What Did NOT Work" section is populated with all failed approaches from the session, using the structured FAIL format.

## Quality Checklist

Before ending a significant work session:
- [ ] All failed approaches documented with exact errors
- [ ] Key architecture decisions saved to memory
- [ ] User corrections/preferences captured as feedback memories
- [ ] Non-obvious solutions saved for future reference
- [ ] MEMORY.md index updated with new entries

---

## Enhanced Memory Structure (Compression)

Memory content should match the 3-tier progressive disclosure model (see memory-search skill):

### Tier 1: Index Line (MEMORY.md)
- One line, under 150 characters
- Must be scannable without reading the file
- Format: `- [Title](filename.md) -- one-line hook`

### Tier 2: Frontmatter (top of memory file)
- name, description, type fields
- description must be specific enough for relevance filtering (~1 sentence)
- Add `tokens_estimate` field for budget tracking

### Tier 3: Body (full content)
- Structured content: fact/rule, then **Why:** and **How to apply:**
- Keep bodies concise: aim for 100-300 tokens per memory
- Use bullet points over prose
- Remove redundant context that is already in the frontmatter

### Compression Checklist

Before writing a memory, compress it:
- [ ] Remove filler words and hedging language
- [ ] Replace paragraphs with bullet points
- [ ] Merge related observations into one memory (not one per observation)
- [ ] Ensure frontmatter description is sufficient for Layer 2 filtering

## Token Cost Awareness

Every memory has a token cost. Track it to stay within budget.

### Token Estimation Table

| Content Type | Estimated Tokens |
|-------------|-----------------|
| MEMORY.md index line | 15-30 tokens |
| Frontmatter block (5 fields) | 40-80 tokens |
| Short memory body (2-3 bullets) | 50-100 tokens |
| Medium memory body (5-8 bullets) | 100-200 tokens |
| Long memory body (detailed context) | 200-400 tokens |

### Frontmatter Extension

Add `tokens_estimate` to new memories:
```yaml
---
name: example-memory
description: "One-line description for Layer 2 filtering"
type: feedback
tokens_estimate: 150
---
```

This helps the memory budget system track total token cost without reading file contents.

## Deduplication Check

Before writing ANY new memory, search first to prevent duplicates.

### Search Before Write Protocol

1. Read MEMORY.md index (Layer 1 from memory-search skill)
2. Check if any existing title covers the same topic
3. If a match exists:
   - Read the existing memory file
   - UPDATE the existing file with new information (merge, do not duplicate)
   - Update the MEMORY.md index line if the description changed
4. If no match exists:
   - Create new memory file
   - Add index line to MEMORY.md

### Merge Rules

When updating an existing memory:
- Preserve the original creation context
- Append new observations with date markers
- Update the description if the scope expanded
- Update tokens_estimate after changes
- Do NOT create a second file for the same topic

## Memory Budget

Target constraints to keep memory manageable and token-efficient.

### Budget Targets

| Metric | Target | Warning | Action |
|--------|--------|---------|--------|
| Total memories | < 70 | 70 entries | Archive low-value memories |
| Layer 1 total tokens | < 5,000 | 3,500 tokens | Shorten index lines |
| Average memory size | < 200 tokens | 250 tokens | Compress verbose memories |
| Stale memories | < 20% | 15% stale | Review and archive |

### Warning at 70 Entries

When MEMORY.md reaches 70 entries:
1. Flag to the user: "Memory budget warning: 70 entries. Consider archival."
2. Identify candidates for archival:
   - Memories older than 90 days with no recent access
   - Memories about completed/abandoned projects
   - Memories superseded by newer observations
3. Propose an archival list for user approval

### Archival Process

Archived memories are NOT deleted. They are moved to reduce Layer 1 cost:
1. Move the memory file to a `memory/archive/` subdirectory
2. Remove the index line from MEMORY.md
3. Add one summary line to an `ARCHIVE.md` index (for recovery if needed)
4. Archived memories can be restored if referenced again
