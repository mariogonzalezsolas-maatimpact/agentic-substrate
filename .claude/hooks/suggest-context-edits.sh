#!/usr/bin/env bash
# suggest-context-edits.sh
# SubagentStop hook: Suggest context optimizations after subagent completes
# Reads subagent result from stdin JSON

set -euo pipefail

if ! command -v jq &>/dev/null; then exit 0; fi

INPUT=$(cat 2>/dev/null || echo "{}")
AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // "unknown"' 2>/dev/null)

# After research agents, suggest archiving findings
case "$AGENT_NAME" in
    docs-researcher|implementation-planner)
        echo "Tip: Archive research findings to knowledge-core.md for future reference"
        ;;
    brahma-analyzer)
        echo "Tip: Review analysis results and update CLAUDE.md if patterns changed"
        ;;
esac

# Always exit successfully (suggestions are non-blocking)
exit 0
