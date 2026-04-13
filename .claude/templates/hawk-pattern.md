# Hawk Agent Pattern

Real-time oversight mechanism that reviews agent reasoning during execution, not after.

---

## Why Hawk Exists

A PR reviewer only sees the **output code**. The Hawk reads the **entire reasoning process**. It catches:

- **Chaotic oscillation**: Agent editing the same file 50+ times without progress
- **Reward hacking**: Disabling tests, swallowing errors, mocking everything to make suite green
- **Context poisoning**: Bad patterns (generic try/catch, disabled tests) that propagate across sessions
- **Destructive operations**: `rm -rf .git`, `git reset --hard` when blocked

## How It Works

```
Implementer -> Tool call -> Hawk reviews -> continue | block | escalate
```

The Hawk runs as a PostToolUse hook on Edit|Write|Bash operations. It inspects the session transcript for red flags.

## Red Flags Detected

| Pattern | Risk | Action |
|---------|------|--------|
| `test.skip` / `.skip(` | Reward hacking | Block: tests must not be disabled |
| Generic `catch` with no specific handling | Error swallowing | Block: errors must propagate or have specific recovery |
| `rm -rf` / `git reset --hard` | Destructive operation | Block: requires human approval |
| Same file edited 5+ times | Chaotic oscillation | Warn: agent may be stuck in a loop |
| `TODO: fix` / `FIXME` added | Deferred problems | Warn: agent is deferring instead of solving |

## Enabling the Hawk

```bash
# Enable in your environment
export HAWK_ENABLED=1

# Or in ~/.claude/settings.json env section
```

The Hawk is **opt-in** by default. Enable it for complex or high-risk tasks.

## Cross-Provider Pairing (Advanced)

For maximum effectiveness, use different model providers:
- **Implementer**: High-throughput model (good at generating code)
- **Hawk**: Well-aligned model (good at catching intent mismatches)

Different providers reduce self-preference bias.

## Relationship to Circuit Breaker

| Mechanism | When | Scope |
|-----------|------|-------|
| Hawk | Real-time, per tool call | Catches reasoning errors before they compound |
| Circuit Breaker | After failures | Stops after 3 consecutive implementation failures |

They complement each other: Hawk prevents errors, Circuit Breaker limits damage.

---

**Source**: Alejandro Vidal, "Agentic Engineering" - HACKNIGHT Valencia 2026
**Updated**: 2026-04-13 | **Version**: 7.3.0
