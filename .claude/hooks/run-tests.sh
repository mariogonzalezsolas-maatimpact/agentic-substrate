#!/usr/bin/env bash
# run-tests.sh
# PostToolUse hook: Run tests after code implementation
# OPT-IN: Not registered in settings.json by default.
# To enable, add to settings.json under hooks.PostToolUse:
#   { "matcher": "Write|Edit",
#     "hooks": [{ "type": "command",
#       "command": "bash \"$HOME/.claude/hooks/run-tests.sh\"",
#       "timeout": 60 }] }
# WARNING: Only enable when your test suite runs in <30 seconds

set -e

cd "${CLAUDE_PROJECT_DIR:-.}"

echo "🧪 Running tests..."

# Detect test framework and run appropriate command
if [ -f "package.json" ]; then
    if grep -q "\"test\":" package.json; then
        npm test 2>&1 | head -50  # Limit output
        exit ${PIPESTATUS[0]}
    fi
elif [ -f "pytest.ini" ] || [ -f "pyproject.toml" ]; then
    pytest --quiet 2>&1 | head -50
    exit ${PIPESTATUS[0]}
elif [ -f "go.mod" ]; then
    go test ./... 2>&1 | head -50
    exit ${PIPESTATUS[0]}
elif [ -f "Cargo.toml" ]; then
    cargo test --quiet 2>&1 | head -50
    exit ${PIPESTATUS[0]}
fi

echo "⚠️  No test framework detected"
exit 0
