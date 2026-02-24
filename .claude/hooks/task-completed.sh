#!/usr/bin/env bash
# Agent Teams hook: Verify task output quality before allowing completion
# Exit 0 = allow completion, Exit 2 = block + stderr feedback

set -euo pipefail

cd "${CLAUDE_PROJECT_DIR:-.}"

# Guard: jq is required for JSON parsing
if ! command -v jq &>/dev/null; then
    exit 0
fi

INPUT=$(cat 2>/dev/null || echo "{}")
TASK_SUBJECT=$(echo "$INPUT" | jq -r '.task_subject // "unknown"' 2>/dev/null)

# Check: implementation tasks must have recently modified test files
if echo "$TASK_SUBJECT" | grep -iqE "implement|build|create|add|feature"; then
    # Look for test files modified in the last 60 minutes
    RECENT_TESTS=$(find . \( -name "*test*" -o -name "*spec*" \) \( -name "*.ts" -o -name "*.js" -o -name "*.py" -o -name "*.go" -o -name "*.rs" \) \
        -mmin -60 ! -path "*/node_modules/*" ! -path "*/.git/*" 2>/dev/null | head -1)
    if [ -z "$RECENT_TESTS" ]; then
        echo "Implementation task completed without tests. Add tests before marking complete." >&2
        exit 2
    fi

    # Check circuit breaker state if available
    CB_FILE="${HOME}/.claude/.circuit-breaker-state"
    if [ -f "$CB_FILE" ]; then
        CB_STATE=$(cat "$CB_FILE" 2>/dev/null | head -1)
        if [ "$CB_STATE" = "OPEN" ]; then
            echo "Circuit breaker is OPEN. Fix failures before completing implementation tasks." >&2
            exit 2
        fi
    fi
fi

exit 0
