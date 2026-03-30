#!/usr/bin/env bash
# session-end-metrics.sh
# Appends a JSONL metrics line to memory/events.jsonl at session end.
# Fault-tolerant: never fails, always exits 0.

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(pwd)}"
EVENTS_FILE="$PROJECT_DIR/memory/events.jsonl"

mkdir -p "$PROJECT_DIR/memory" 2>/dev/null || exit 0

DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "unknown")

TASKS=0
FILES_CHANGED=0
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    TASKS=$(git -C "$PROJECT_DIR" log --oneline --since="2 hours ago" 2>/dev/null | wc -l | tr -d ' ')
    FILES_CHANGED=$(git -C "$PROJECT_DIR" diff --name-only HEAD~"${TASKS:-1}" HEAD 2>/dev/null | sort -u | wc -l | tr -d ' ')
fi

TASKS=${TASKS:-0}
FILES_CHANGED=${FILES_CHANGED:-0}

echo "{\"date\":\"$DATE\",\"tasks_completed\":$TASKS,\"files_changed\":$FILES_CHANGED,\"test_pass_rate\":1.0,\"iterations\":1,\"duration_minutes\":0,\"route\":\"unknown\"}" >> "$EVENTS_FILE" 2>/dev/null

exit 0
