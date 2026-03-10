#!/usr/bin/env bash
# post-compact-reinject.sh
# SessionStart hook (compact matcher): Re-injects critical context after compaction
# Compaction summarizes conversation but can lose important details
# This hook outputs text to stdout which gets added to Claude's context

echo "=== Post-Compaction Context Reinject ==="
echo ""
echo "CRITICAL REMINDERS (survived compaction):"
echo "- Follow research-first philosophy: NEVER code from memory"
echo "- Quality gates: Research >= 80, Plan >= 85, Tests pass"
echo "- Error self-tracking: Log mistakes to memory/errors.md"
echo "- TDD mandatory: RED -> GREEN -> REFACTOR"
echo "- Circuit breaker: 3 consecutive failures = STOP"
echo ""

# Show recent git changes for context
if command -v git &>/dev/null && git rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
    echo "Recent changes (last 5 commits):"
    git log --oneline -5 2>/dev/null || true
    echo ""

    # Show any uncommitted changes
    CHANGES=$(git status --porcelain 2>/dev/null | head -10)
    if [ -n "$CHANGES" ]; then
        echo "Uncommitted changes:"
        echo "$CHANGES"
        echo ""
    fi
fi

# Load recent errors if they exist
ERRORS_FILE=""
for candidate in \
    "${CLAUDE_PROJECT_DIR:-.}/memory/errors.md" \
    "$HOME/.claude/memory/errors.md"; do
    if [ -f "$candidate" ]; then
        ERRORS_FILE="$candidate"
        break
    fi
done

if [ -n "$ERRORS_FILE" ]; then
    ERROR_COUNT=$(grep -c "^## Error:" "$ERRORS_FILE" 2>/dev/null || echo "0")
    if [ "$ERROR_COUNT" -gt 0 ]; then
        echo "Active errors to avoid ($ERROR_COUNT logged):"
        grep "^## Error:" "$ERRORS_FILE" 2>/dev/null | tail -3 | sed 's/^/  - /'
        echo ""
    fi
fi

echo "=== End Reinject ==="
exit 0
