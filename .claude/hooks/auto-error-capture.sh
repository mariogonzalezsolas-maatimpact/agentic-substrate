#!/usr/bin/env bash
# auto-error-capture.sh
# SubagentStop hook: Automatically captures agent failures to errors.md
# Detects FAIL/BLOCKED status in agent output and logs the error
# This creates an automatic feedback loop - the system learns from its own mistakes

if ! command -v jq &>/dev/null; then exit 0; fi

INPUT=$(cat 2>/dev/null || echo "{}")

# Guard against infinite loops when fired from Stop hook
if [ "$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null)" = "true" ]; then
    exit 0
fi

# Extract agent output from stdin
AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // .subagent_name // "unknown"' 2>/dev/null)
OUTPUT=$(echo "$INPUT" | jq -r '.output // .result // ""' 2>/dev/null)

# Only capture if there's a failure signal
if ! echo "$OUTPUT" | grep -qiE "FAIL|BLOCKED|error|circuit.breaker.*OPEN"; then
    exit 0
fi

# Find the errors.md file
ERRORS_FILE=""
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-.}"
for candidate in \
    "$PROJECT_DIR/memory/errors.md" \
    "$HOME/.claude/memory/errors.md"; do
    if [ -f "$candidate" ]; then
        ERRORS_FILE="$candidate"
        break
    fi
done

# If no errors file found, try to create in project memory
if [ -z "$ERRORS_FILE" ]; then
    ERRORS_FILE="$PROJECT_DIR/memory/errors.md"
    mkdir -p "$(dirname "$ERRORS_FILE")" 2>/dev/null || exit 0
    if [ ! -f "$ERRORS_FILE" ]; then
        # Create with template header
        cat > "$ERRORS_FILE" << 'HEADER'
# Error Log

Automatic error tracking for continuous improvement. Entries are auto-captured by hooks and manually logged by agents.

HEADER
    fi
fi

# Extract failure details (first 3 lines containing error/fail/block)
FAILURE_DETAILS=$(echo "$OUTPUT" | grep -iE "FAIL|BLOCKED|error|bug|wrong|incorrect" | head -3 | tr '\n' ' ' | cut -c1-200)

# Avoid duplicate entries (check if same error already logged today)
TODAY=$(date +%Y-%m-%d 2>/dev/null || echo "unknown")
if grep -q "$TODAY.*$AGENT_NAME" "$ERRORS_FILE" 2>/dev/null; then
    # Already logged an error for this agent today, skip
    exit 0
fi

# Append the error entry
cat >> "$ERRORS_FILE" << ENTRY

### [$TODAY] $AGENT_NAME failure (auto-captured)
- **What happened**: Agent reported failure status
- **Details**: $FAILURE_DETAILS
- **Root cause**: To be analyzed
- **Prevention**: Review and update this entry with the actual root cause and prevention rule
- **Category**: other

ENTRY

exit 0
