#!/usr/bin/env bash
# auto-format.sh
# PostToolUse hook: Automatically format code after Write/Edit operations
# Reads tool input from stdin JSON

if ! command -v jq &>/dev/null; then exit 0; fi

INPUT=$(cat 2>/dev/null || echo "{}")
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // empty' 2>/dev/null)

# If no file path from JSON, exit silently
if [ -z "$FILE_PATH" ]; then
    exit 0
fi

# Only format code files (not markdown, json, etc.)
case "$FILE_PATH" in
    *.ts|*.tsx|*.js|*.jsx)
        if command -v prettier &> /dev/null; then
            prettier --write "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.py)
        if command -v black &> /dev/null; then
            black "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.go)
        if command -v gofmt &> /dev/null; then
            gofmt -w "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
    *.rs)
        if command -v rustfmt &> /dev/null; then
            rustfmt "$FILE_PATH" 2>/dev/null || true
        fi
        ;;
esac

exit 0  # Never block on formatting
