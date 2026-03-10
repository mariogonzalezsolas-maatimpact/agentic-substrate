#!/usr/bin/env bash
# protect-files.sh
# PreToolUse hook: Deterministically blocks writes to sensitive files
# Unlike CLAUDE.md rules (advisory), this hook GUARANTEES protection via exit 2

INPUT=$(cat 2>/dev/null || echo "{}")

# Extract file path from tool input
FILE_PATH=""
if command -v jq &>/dev/null; then
    FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.filename // empty' 2>/dev/null)
else
    # Fallback: grep for file_path
    FILE_PATH=$(echo "$INPUT" | grep -oP '"file_path"\s*:\s*"([^"]*)"' | head -1 | sed 's/.*"file_path"\s*:\s*"//;s/"$//')
fi

[ -z "$FILE_PATH" ] && exit 0

# Protected patterns - deterministic blocking
PROTECTED_PATTERNS=(
    ".env"
    ".env.local"
    ".env.production"
    ".env.staging"
    "credentials"
    "secret"
    ".git/"
    "id_rsa"
    "id_ed25519"
    ".pem"
    ".key"
    "package-lock.json"
    "yarn.lock"
    "pnpm-lock.yaml"
)

for pattern in "${PROTECTED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == *"$pattern"* ]]; then
        echo "BLOCKED: Cannot modify '$FILE_PATH' - matches protected pattern '$pattern'. This file is protected by the protect-files hook." >&2
        exit 2
    fi
done

exit 0
