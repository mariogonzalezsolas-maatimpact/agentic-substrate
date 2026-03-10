#!/usr/bin/env bash
# hawk.sh
# PostToolUse hook: Real-time oversight that catches agent reasoning errors
# during execution (chaotic oscillation, reward hacking, destructive ops).
# Source: Alejandro Vidal's "Agentic Engineering" pattern.
# Reads tool input from stdin JSON.

if ! command -v jq &>/dev/null; then exit 0; fi

# Hawk is opt-in. Skip if not enabled.
if [ -z "$HAWK_ENABLED" ] || [ "$HAWK_ENABLED" = "0" ]; then
    exit 0
fi

INPUT=$(cat 2>/dev/null || echo "{}")
TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // empty' 2>/dev/null)
SESSION_ID=$(echo "$INPUT" | jq -r '.session_id // empty' 2>/dev/null)

# Also check tool_input for file content written by Write/Edit
TOOL_INPUT=$(echo "$INPUT" | jq -r '.tool_input // empty' 2>/dev/null)

# --- Red flag detection ---
WARNINGS=""

# 1. Reward hacking: disabling tests
if echo "$TOOL_INPUT" | grep -qE 'test\.skip|\.skip\(|xit\(|xdescribe\(' 2>/dev/null; then
    WARNINGS="Reward hacking detected: test.skip or disabled test pattern found. Tests must not be disabled to make suite pass."
fi

# 2. Error swallowing: generic catch blocks that hide errors
if echo "$TOOL_INPUT" | grep -qE 'catch\s*\(.*\)\s*\{?\s*(return|//|/\*)' 2>/dev/null; then
    if ! echo "$TOOL_INPUT" | grep -qE 'catch\s*\(.*\)\s*\{[^}]*(throw|console\.error|logger|log\.)' 2>/dev/null; then
        WARNINGS="${WARNINGS:+$WARNINGS | }Error swallowing detected: catch block with no error propagation or logging."
    fi
fi

# 3. Destructive operations
if echo "$TOOL_INPUT" | grep -qE 'rm\s+-rf\s|git\s+reset\s+--hard|git\s+checkout\s+\.|git\s+clean\s+-f|git\s+push\s+--force' 2>/dev/null; then
    WARNINGS="${WARNINGS:+$WARNINGS | }Destructive operation detected (rm -rf, git reset --hard, git push --force). Requires human approval."
fi

# 4. Chaotic oscillation: same file edited too many times in transcript
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    RECENT=$(tail -n 100 "$TRANSCRIPT_PATH" 2>/dev/null || echo "")

    # Count repeated file edits in recent transcript
    REPEATED_FILE=$(echo "$RECENT" | grep -oE '"file_path"\s*:\s*"[^"]+"' 2>/dev/null \
        | sort | uniq -c | sort -rn | head -1)
    REPEAT_COUNT=$(echo "$REPEATED_FILE" | awk '{print $1}' 2>/dev/null)

    if [ -n "$REPEAT_COUNT" ] && [ "$REPEAT_COUNT" -ge 5 ]; then
        REPEATED_NAME=$(echo "$REPEATED_FILE" | sed 's/^[[:space:]]*[0-9]*//' 2>/dev/null)
        WARNINGS="${WARNINGS:+$WARNINGS | }Chaotic oscillation: same file edited ${REPEAT_COUNT} times in recent transcript (${REPEATED_NAME}). Agent may be stuck in a loop."
    fi

    # 5. Deferred problems: agent adding TODOs instead of solving
    if echo "$TOOL_INPUT" | grep -qEi 'TODO:?\s*(fix|hack|workaround|temporary|FIXME)' 2>/dev/null; then
        WARNINGS="${WARNINGS:+$WARNINGS | }Deferred problem detected: agent is adding TODO/FIXME instead of solving the issue now."
    fi
fi

# --- Decision ---
if [ -n "$WARNINGS" ]; then
    # Output block decision as JSON to stdout
    echo "{\"decision\": \"block\", \"reason\": \"Hawk: ${WARNINGS}\"}"
fi

# Always exit 0 per Claude Code hooks protocol
exit 0
