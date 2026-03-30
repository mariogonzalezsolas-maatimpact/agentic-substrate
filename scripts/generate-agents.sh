#!/usr/bin/env bash
# generate-agents.sh -- Generate agent .md files from YAML configs + template
# Usage: ./scripts/generate-agents.sh [--dry-run] [agent-name]
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIGS_DIR="$ROOT_DIR/.claude/agent-configs"
OUTPUT_DIR="$ROOT_DIR/.claude/agents"
DRY_RUN=false; TARGET=""; GENERATED=0; ERRORS=0

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;; --help|-h) echo "Usage: $0 [--dry-run] [agent-name]"; exit 0 ;;
    *) TARGET="$arg" ;;
  esac
done
[ -d "$CONFIGS_DIR" ] || { echo "ERROR: $CONFIGS_DIR not found" >&2; exit 1; }

# Pure awk YAML helpers -- handle scalars, lists, and block scalars
yget() { # file key -> scalar value (strips quotes)
  awk -v k="$1" '/^[a-zA-Z_]+:/{f=$0; sub(/:.*$/,"",f); if(f==k){v=substr($0,length(f)+3);
    gsub(/^"/,"",v);gsub(/"$/,"",v);print v}}' "$2"
}
ylist() { # file key -> bullet list
  awk -v k="$1" 'BEGIN{s=0} /^[a-zA-Z_]+:/{if(s)exit; f=$0;sub(/:.*$/,"",f);
    if(f==k){s=1;next}} s&&/^  - /{v=substr($0,5);gsub(/^"/,"",v);gsub(/"$/,"",v);
    print "- "v} s&&/^[^ ]/&&!/^  -/{exit}' "$2"
}
yblock() { # file key -> multiline block content
  awk -v k="$1" 'BEGIN{s=0} /^[a-zA-Z_]+:/{if(s)exit; f=$0;sub(/:.*$/,"",f);
    r=substr($0,length(f)+3); if(f==k){if(r~/\|[[:space:]]*$/){s=1;next}else{
    gsub(/^"/,"",r);gsub(/"$/,"",r);print r;exit}}} s&&/^[a-zA-Z_]+:/&&!/^  /{exit}
    s{sub(/^  /,"",$0);print}' "$2"
}
yskills() { # file -> skills frontmatter block (or empty)
  awk 'BEGIN{s=0}/^skills:/{s=1;print;next} s&&/^  - /{print} s&&/^[^ ]/{exit}' "$1"
}

generate_agent() {
  local cf="$1" name out
  name=$(basename "$cf" .yaml); out="$OUTPUT_DIR/$name.md"
  echo "  $name"

  local n d m t mt mem pr ti
  n=$(yget name "$cf"); d=$(yget description "$cf"); m=$(yget model "$cf")
  t=$(yget tools "$cf"); mt=$(yget maxTurns "$cf"); mem=$(yget memory "$cf")
  pr=$(yget priority "$cf"); ti=$(yget title "$cf")

  local role phil exp sdo sdn sb fo cs cust qg sk comm=""
  role=$(yblock role "$cf"); phil=$(ylist philosophy "$cf")
  exp=$(ylist expertise "$cf"); sdo=$(ylist scope_do "$cf")
  sdn=$(ylist scope_dont "$cf"); sb=$(yblock scope_boundary "$cf")
  fo=$(ylist file_ownership "$cf"); cs=$(yblock communication_style "$cf")
  cust=$(yblock custom_sections "$cf")
  qg=$(ylist quality_gates "$cf" | sed 's/^- /- [ ] /')
  sk=$(yskills "$cf")
  [ -n "$cs" ] && comm="## Communication Style
$cs

"
  local skf=""; [ -n "$sk" ] && skf="$sk
"
  local content="---
name: $n
description: $d
tools: $t
model: $m
maxTurns: $mt
${skf}memory: $mem
priority: $pr
---

# $ti

## Role
$role

## Philosophy
$phil

## Technical Expertise
$exp

## Scope

### What You DO
$sdo

### What You DON'T Do
$sdn

### Scope Boundary
$sb

### File Ownership
$fo

${comm}## Think Protocol
@.claude/templates/think-protocol.md

$cust

## Quality Gates
Before declaring task complete:
$qg

## Output Protocol

@.claude/templates/agent-report-protocol.md"

  if [ "$DRY_RUN" = true ]; then
    echo "    DRY RUN: $(echo "$content" | wc -l) lines -> $out"
  else
    echo "$content" > "$out"
  fi
  GENERATED=$((GENERATED + 1))
}

# --- Main ---
if [ -n "$TARGET" ]; then
  cf="$CONFIGS_DIR/$TARGET.yaml"
  [ -f "$cf" ] || { echo "ERROR: Config not found: $cf" >&2; exit 1; }
  generate_agent "$cf"
else
  for cf in "$CONFIGS_DIR"/*.yaml; do
    [ -f "$cf" ] || continue
    generate_agent "$cf" || { ERRORS=$((ERRORS + 1)); echo "  WARN: failed $cf" >&2; }
  done
fi
echo "Done: $GENERATED generated, $ERRORS errors"
