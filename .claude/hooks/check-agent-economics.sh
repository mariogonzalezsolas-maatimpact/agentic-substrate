#!/usr/bin/env bash
# check-agent-economics.sh
# SubagentStart hook: Check if multi-agent spawning is economically viable
# Reads subagent info from stdin JSON
# Exit 0 = allow, Exit 2 = block

set -euo pipefail

if ! command -v jq &>/dev/null; then exit 0; fi

INPUT=$(cat 2>/dev/null || echo "{}")
AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // "unknown"' 2>/dev/null)

# Always allow single-agent spawns - economics are checked at orchestration level
echo "Subagent starting: $AGENT_NAME"
exit 0
