#!/usr/bin/env bash
# SessionStart hook: Auto-load project context when a session begins
# Outputs context summary to stdout (displayed to Claude as system info)
# Exit 0 = success (always, this is informational)

set -euo pipefail
INPUT=$(cat 2>/dev/null || echo "{}")

# Detect project root
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"

echo "--- Session Context (auto-loaded) ---"

# Git context
if command -v git &>/dev/null && git -C "$PROJECT_DIR" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    BRANCH=$(git -C "$PROJECT_DIR" branch --show-current 2>/dev/null || echo "detached")
    LAST_COMMIT=$(git -C "$PROJECT_DIR" log --oneline -1 2>/dev/null || echo "none")
    UNCOMMITTED=$(git -C "$PROJECT_DIR" status --short 2>/dev/null | wc -l | tr -d ' ')
    echo "Git: branch=$BRANCH | last=$LAST_COMMIT | uncommitted=$UNCOMMITTED"
fi

# Circuit breaker state
CB_FILE="$PROJECT_DIR/.claude/.circuit-breaker-state"
if [ -f "$CB_FILE" ]; then
    # Check if any agent has 3+ failures (circuit open)
    if grep -qE '"[^"]+": *[3-9]|"[^"]+": *[1-9][0-9]+' "$CB_FILE" 2>/dev/null; then
        echo "Circuit breaker: OPEN"
    else
        echo "Circuit breaker: CLOSED"
    fi
else
    echo "Circuit breaker: CLOSED"
fi

# Existing artifacts
ARTIFACTS=""
for f in "$PROJECT_DIR"/ResearchPack*.md "$PROJECT_DIR"/.claude/ResearchPack*.md; do
    [ -f "$f" ] && ARTIFACTS="$ARTIFACTS ResearchPack" && break
done
for f in "$PROJECT_DIR"/ImplementationPlan*.md "$PROJECT_DIR"/.claude/ImplementationPlan*.md; do
    [ -f "$f" ] && ARTIFACTS="$ARTIFACTS Plan" && break
done
[ -f "$PROJECT_DIR/.claude/knowledge-core.md" ] && ARTIFACTS="$ARTIFACTS knowledge-core"
if [ -n "$ARTIFACTS" ]; then
    echo "Artifacts:$ARTIFACTS"
else
    echo "Artifacts: none"
fi

# Recent file activity (last 2 hours)
RECENT=$(find "$PROJECT_DIR" -type f \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" -o -name "*.md" \) -mmin -120 ! -path "*/node_modules/*" ! -path "*/.git/*" ! -path "*/compact-backups/*" 2>/dev/null | wc -l | tr -d ' ')
echo "Files modified (last 2h): $RECENT"

# Error memory auto-load
ERRORS_FILE=""
for candidate in \
    "$PROJECT_DIR/memory/errors.md" \
    "$HOME/.claude/memory/errors.md"; do
    [ -f "$candidate" ] && ERRORS_FILE="$candidate" && break
done
if [ -z "$ERRORS_FILE" ]; then
    for candidate in "$HOME/.claude/projects"/*/memory/errors.md; do
        [ -f "$candidate" ] && ERRORS_FILE="$candidate" && break
    done
fi
if [ -n "$ERRORS_FILE" ]; then
    # Count entries (lines starting with ### [)
    ERROR_COUNT=$(grep -c '^### \[' "$ERRORS_FILE" 2>/dev/null || echo "0")
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "--- Error Memory (auto-loaded) ---"
        echo "ERRORS_FOUND: $ERROR_COUNT documented errors"
        grep -A1 '^### \[' "$ERRORS_FILE" 2>/dev/null | head -10
        grep '^\- \*\*Prevention\*\*' "$ERRORS_FILE" 2>/dev/null | tail -5
        echo "--- End Error Memory ---"
    fi
fi

echo "--- End Session Context ---"
exit 0
