---
name: memory-search
description: "Progressive disclosure memory search. 3-layer approach: INDEX (titles from MEMORY.md), SUMMARY (frontmatter only), DETAIL (full content). Reduces token waste when searching memory."
auto_invoke: true
tags: [memory, search, progressive-disclosure, token-efficiency]
---

# Memory Search Skill

Progressive disclosure search for the persistent memory system. Reads only what is needed, layer by layer, to minimize token consumption.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- Searching for prior decisions, failed approaches, or user preferences in memory
- Starting a task that may overlap with previous work
- User asks "do we have...", "did we try...", "what was decided about..."
- Context indicates a topic that may have been captured in a prior session

**Do NOT invoke when:**
- The needed information is already in the current conversation context
- The query is about code (use grep/glob instead)
- MEMORY.md has fewer than 5 entries (just read them all)

**Boundary with auto-memory-capture**: auto-memory-capture WRITES to memory. memory-search READS from memory. They are complementary - search before write to avoid duplicates.

## 3-Layer Protocol

### Layer 1: INDEX (~50-100 tokens per entry)

Read `MEMORY.md` only. Scan titles and one-line descriptions.

**Action**: Read the MEMORY.md index file.
**Output**: List of memory titles with their one-line hooks.
**Decision**: If a title clearly matches the query, go to Layer 2 for that file. If no match, STOP - the information is not in memory.

### Layer 2: SUMMARY (~100-200 tokens per file)

Read only the YAML frontmatter of matched files.

**Action**: Read the first 10 lines of each candidate file (frontmatter block).
**Output**: name, description, type fields from frontmatter.
**Decision**: If the description confirms relevance, go to Layer 3. If not, skip that file and check next candidate.

### Layer 3: DETAIL (full file content)

Read the complete memory file.

**Action**: Read the full content of confirmed-relevant files.
**Output**: Full memory content including context, reasons, and application guidance.
**Decision**: Use the information. If multiple files are relevant, read them one at a time.

## Decision Tree

```
Query arrives
  |
  v
Read MEMORY.md index
  |
  +--> No title matches --> STOP (not in memory)
  |
  +--> 1-3 titles match --> Layer 2: read frontmatter of each
  |     |
  |     +--> Frontmatter confirms relevance --> Layer 3: read full file
  |     |
  |     +--> Frontmatter not relevant --> skip, try next candidate
  |
  +--> 4+ titles match --> Narrow by type/tag before Layer 2
        |
        +--> Filter by memory type (feedback, project, user, reference)
        +--> Then proceed to Layer 2 with filtered set
```

## Anti-Patterns

| Anti-Pattern | Why It Wastes Tokens | Correct Approach |
|-------------|---------------------|-----------------|
| Reading all memory files at session start | 500-5000 tokens wasted if most are irrelevant | Read MEMORY.md index only, drill down on demand |
| Skipping Layer 1 and reading files directly | May read wrong files, miss better matches | Always start from MEMORY.md index |
| Reading Layer 3 for all candidates | Multiplies token cost by number of candidates | Use Layer 2 frontmatter to filter first |
| Not searching memory before writing | Creates duplicate entries | Always search before auto-memory-capture writes |

## Token Savings Estimate

| Memory Count | Read-All Cost | Progressive Cost | Savings |
|-------------|--------------|-----------------|---------|
| 10 memories | ~2,000 tokens | ~300-500 tokens | 75-85% |
| 25 memories | ~5,000 tokens | ~400-800 tokens | 84-92% |
| 50 memories | ~10,000 tokens | ~500-1,200 tokens | 88-95% |
| 100 memories | ~20,000 tokens | ~600-1,500 tokens | 93-97% |

Assumes average memory file is ~200 tokens, MEMORY.md index is ~50-100 tokens per entry, and typical search matches 1-3 files.

## Integration Notes

- Works with the existing MEMORY.md index format (one-line pointers per entry)
- Compatible with all memory types: feedback, project, user, reference
- Complements auto-memory-capture (search before write to deduplicate)
- Complements context-engineering (reduces memory-related context bloat)
- No changes to memory file format required - uses existing frontmatter structure
