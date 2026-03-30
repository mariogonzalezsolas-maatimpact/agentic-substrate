#!/usr/bin/env bash
# session-end.sh
# SessionEnd hook: Auto-capture session summary to memory
# Fires when session terminates (clear, resume, logout, exit)

if ! command -v jq &>/dev/null; then exit 0; fi

INPUT=$(cat 2>/dev/null || echo "{}")
REASON=$(echo "$INPUT" | jq -r '.reason // "unknown"' 2>/dev/null)

# Only capture for meaningful session ends (not clear/compact)
if [ "$REASON" = "clear" ]; then
    exit 0
fi

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
SESSION_LOG="$PROJECT_DIR/.claude/session-data"
mkdir -p "$SESSION_LOG" 2>/dev/null || exit 0

TODAY=$(date +%Y-%m-%d 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +%H%M%S 2>/dev/null || echo "000000")

# Get git diff summary for what was modified
CHANGES=""
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    UNCOMMITTED=$(git -C "$PROJECT_DIR" diff --stat HEAD 2>/dev/null | tail -1)
    LAST_COMMITS=$(git -C "$PROJECT_DIR" log --oneline -3 --since="today" 2>/dev/null)
    if [ -n "$UNCOMMITTED" ]; then
        CHANGES="Uncommitted: $UNCOMMITTED"
    fi
    if [ -n "$LAST_COMMITS" ]; then
        CHANGES="$CHANGES | Today's commits: $(echo "$LAST_COMMITS" | wc -l | tr -d ' ')"
    fi
fi

# Write a minimal session end marker (not a full /save-session)
cat >> "$SESSION_LOG/$TODAY-auto-session.log" << ENTRY
[$TIMESTAMP] Session ended ($REASON) | $CHANGES
ENTRY

exit 0
