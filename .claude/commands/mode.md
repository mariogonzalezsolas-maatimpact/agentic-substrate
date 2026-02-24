---
name: mode
description: Switch behavioral modes. Token-Efficiency minimizes context usage. Introspection enables meta-cognitive reasoning analysis. Default restores standard behavior.
---

# /mode Command

Switch Claude's behavioral mode for the rest of the session.

## Usage

```bash
/mode [token-efficiency | introspection | default]
```

## Available Modes

### token-efficiency
Minimizes token usage and context consumption. Use during long sessions or when approaching context limits.

**Behavioral changes when active:**
- Responses are concise (bullet points over paragraphs)
- Skip non-essential explanations
- Omit verbose progress reporting
- Use compact output formats (tables over lists)
- Suppress decorative formatting
- Tool outputs summarized, not echoed in full
- Quality gates still enforced but reported minimally

**Activate:** `/mode token-efficiency`

### introspection
Meta-cognitive analysis mode. Claude evaluates its own reasoning quality and identifies potential blind spots.

**Behavioral changes when active:**
- Before answering, briefly assess: "What assumptions am I making?"
- After complex decisions, add a confidence assessment (HIGH/MEDIUM/LOW)
- Flag when a question has multiple valid interpretations
- Identify when knowledge might be stale or uncertain
- Note when a task would benefit from research vs memory
- Surface potential blind spots in proposed approaches

**Activate:** `/mode introspection`

### default
Restore standard behavior. All mode modifications are cleared.

**Activate:** `/mode default`

## Integration with /do Workflow

**token-efficiency mode**:
- `/do` plan output uses compact format (no examples)
- Quality gate reports show pass/fail only (not full breakdown)
- Agent reports use 1-line status instead of full summary

**introspection mode**:
- `/do` classification includes confidence assessment
- Quality validations include reasoning transparency
- Agent decisions include assumption assessment

---

**Executing command...**

Based on the mode argument:

**If "token-efficiency":**
Acknowledge mode switch. From this point forward in the session:
- Keep all responses under 200 words unless the task requires more
- Use tables and bullet points exclusively
- Skip "here's what I'll do" preambles - just do it
- Report tool results as one-line summaries
- Quality gates: report pass/fail only, not full breakdown

**If "introspection":**
Acknowledge mode switch. From this point forward in the session:
- Before each substantive response, include a brief `[Introspection]` block:
  - Assumptions being made
  - Confidence level (HIGH/MEDIUM/LOW)
  - Potential blind spots or alternative interpretations
- Keep introspection blocks to 2-3 lines max
- Do not let introspection slow down execution

**If "default":**
Acknowledge mode switch. Resume standard Agentic Substrate behavior.

**If no argument or unrecognized:**
Show available modes with current active mode highlighted.
