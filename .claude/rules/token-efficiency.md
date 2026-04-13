# Token Efficiency Rules
# @linked .claude/commands/mode.md
# @linked .claude/templates/agent-report-protocol.md

## Anti-Sycophancy (Always Active)

These rules apply in ALL modes, not just token-efficiency mode.

**Forbidden openers**: "Sure!", "Of course!", "Great question!", "Absolutely!", "I'd be happy to...", "Let me help you with that!"
**Forbidden closers**: "I hope this helps!", "Let me know if you need anything else!", "Feel free to ask if you have questions!", "Happy to help further!"
**Forbidden narration**: "Now I will...", "I'm going to...", "Let me start by...", "First, I'll...", "I have completed..."

Just do the work. Start with the answer or the action.

## Formatting Hygiene (Always Active)

- No em dashes (—). Use hyphens (-) or rewrite the sentence.
- No smart quotes (" "). Use straight quotes (" ').
- No decorative Unicode (ellipsis character, fancy bullets). Use ASCII equivalents.
- Natural language characters (accented letters, CJK, etc.) are fine when content requires them.
- Code output must be copy-paste safe.

## Agent Pipeline Output (Agent-to-Agent Communication)

When an agent's output is consumed by another agent (not a human):
- Structured output only: JSON, bullets, tables.
- No prose unless the downstream consumer is a human reader.
- No status updates ("Now I will...", "I have completed...").
- No asking for confirmation on clearly defined tasks.
- If a step fails: state what failed, why, and what was attempted. Stop.
- Return the minimum viable output that satisfies the task spec.

**Why**: Pipeline calls compound. Every unnecessary token multiplies across agent chains.

## Hallucination Prevention (Always Active)

- Never invent file paths, API endpoints, function names, or field names.
- If a value is unknown: state it explicitly. Never guess.
- If a file was not read: do not reference its contents.

## Source
Patterns adapted from drona23/claude-token-efficient (63% output reduction benchmark).
