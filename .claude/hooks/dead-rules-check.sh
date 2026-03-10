#!/usr/bin/env bash
# dead-rules-check.sh
# Utility: Detects .claude/rules/ files whose paths: globs don't match any real files
# Run manually or via SessionStart to clean up stale rules

RULES_DIR="${CLAUDE_PROJECT_DIR:-.}/.claude/rules"

if [ ! -d "$RULES_DIR" ]; then
    exit 0
fi

DEAD_COUNT=0

for rule_file in "$RULES_DIR"/*.md; do
    [ -f "$rule_file" ] || continue

    # Extract paths from YAML frontmatter
    IN_FRONTMATTER=false
    IN_PATHS=false

    while IFS= read -r line; do
        if [[ "$line" == "---" ]]; then
            if $IN_FRONTMATTER; then
                break  # End of frontmatter
            else
                IN_FRONTMATTER=true
                continue
            fi
        fi

        if $IN_FRONTMATTER && [[ "$line" =~ ^paths: ]]; then
            IN_PATHS=true
            continue
        fi

        if $IN_PATHS; then
            if [[ "$line" =~ ^[[:space:]]*-[[:space:]]*\"(.+)\" ]] || [[ "$line" =~ ^[[:space:]]*-[[:space:]]*(.+) ]]; then
                GLOB_PATTERN="${BASH_REMATCH[1]}"
                # Check if any files match this glob
                MATCHES=$(find "${CLAUDE_PROJECT_DIR:-.}" -path "*/$GLOB_PATTERN" 2>/dev/null | head -1)
                if [ -z "$MATCHES" ]; then
                    echo "DEAD RULE: $(basename "$rule_file") - pattern '$GLOB_PATTERN' matches no files"
                    DEAD_COUNT=$((DEAD_COUNT + 1))
                fi
            elif [[ ! "$line" =~ ^[[:space:]] ]]; then
                IN_PATHS=false
            fi
        fi
    done < "$rule_file"
done

if [ "$DEAD_COUNT" -gt 0 ]; then
    echo ""
    echo "Found $DEAD_COUNT dead rule pattern(s). Consider updating or removing them."
fi

exit 0
