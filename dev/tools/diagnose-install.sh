#!/usr/bin/env bash
# Installation diagnostic script
# Run this to diagnose installation issues

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔍 Agentic Substrate Installation Diagnostics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# System info
echo "🖥️  System Information:"
echo "  OS: $(uname -s)"
echo "  Architecture: $(uname -m)"
echo "  Shell: $SHELL"
echo "  Home: $HOME"
echo ""

# Check if .claude exists
echo "📁 Installation Directory:"
if [ -d "$HOME/.claude" ]; then
    echo "  ✅ $HOME/.claude exists"
    echo "  Size: $(du -sh "$HOME/.claude" 2>/dev/null | cut -f1)"
else
    echo "  ❌ $HOME/.claude does NOT exist"
    echo "  → Installation has not run or failed"
    exit 1
fi
echo ""

# Check version
echo "📋 Version:"
if [ -f "$HOME/.claude/.agentic-substrate-version" ]; then
    VERSION=$(cat "$HOME/.claude/.agentic-substrate-version")
    echo "  ✅ v$VERSION"
else
    echo "  ❌ Version file missing"
    echo "  → Installation may be incomplete"
fi
echo ""

# CLAUDE.md health check
echo "📄 CLAUDE.md Health:"
if [ -f "$HOME/.claude/CLAUDE.md" ]; then
    MD_LINES=$(wc -l < "$HOME/.claude/CLAUDE.md" | tr -d ' ')
    MD_BYTES=$(wc -c < "$HOME/.claude/CLAUDE.md" | tr -d ' ')
    MD_COPIES=$(grep -c "^# Agentic Substrate v" "$HOME/.claude/CLAUDE.md" 2>/dev/null || echo "0")
    echo "  Lines: $MD_LINES (target: <120)"
    echo "  Size: $MD_BYTES bytes (target: <5000)"
    echo "  Template copies: $MD_COPIES (should be 1)"
    if [ "$MD_COPIES" -gt 1 ]; then
        echo "  ❌ BLOATED: $MD_COPIES copies detected. Run: ./install.sh --force"
    elif [ "$MD_BYTES" -gt 10000 ]; then
        echo "  ⚠️  Large file ($MD_BYTES bytes). Run: ./install.sh --force"
    else
        echo "  ✅ Healthy"
    fi
else
    echo "  ❌ Not found"
fi
echo ""

# Count each component
echo "📊 Component Counts:"
echo ""

AGENT_COUNT=$(find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "  Agents: $AGENT_COUNT/15"
if [ "$AGENT_COUNT" -eq 15 ]; then
    echo "    ✅ All agents present"
else
    echo "    ❌ Missing $((15 - AGENT_COUNT)) agents"
    echo "    Found:"
    find "$HOME/.claude/agents" -name "*.md" 2>/dev/null | while read -r f; do basename "$f"; done | sed 's/^/      - /'
fi
echo ""

SKILL_COUNT=$(find "$HOME/.claude/skills" -name "skill.md" 2>/dev/null | wc -l | tr -d ' ')
echo "  Skills: $SKILL_COUNT/5"
if [ "$SKILL_COUNT" -eq 5 ]; then
    echo "    ✅ All skills present"
else
    echo "    ❌ Missing $((5 - SKILL_COUNT)) skills"
    echo "    Found:"
    ls -d "$HOME/.claude/skills"/*/ 2>/dev/null | while read -r f; do basename "$f"; done | sed 's/^/      - /'
fi
echo ""

COMMAND_COUNT=$(find "$HOME/.claude/commands" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
echo "  Commands: $COMMAND_COUNT/12"
if [ "$COMMAND_COUNT" -eq 12 ]; then
    echo "    ✅ All commands present"
else
    echo "    ❌ Missing $((12 - COMMAND_COUNT)) commands"
    echo "    Found:"
    find "$HOME/.claude/commands" -name "*.md" 2>/dev/null | while read -r f; do basename "$f" .md; done | sed 's/^/      \/ /'
fi
echo ""

HOOK_COUNT=$(find "$HOME/.claude/hooks" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
echo "  Hooks: $HOOK_COUNT/12"
if [ "$HOOK_COUNT" -lt 12 ]; then
    echo "    ⚠️  Missing $((12 - HOOK_COUNT)) hooks"
fi
echo ""

VALIDATOR_COUNT=$(find "$HOME/.claude/validators" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
echo "  Validators: $VALIDATOR_COUNT/2"
if [ "$VALIDATOR_COUNT" -lt 2 ]; then
    echo "    ⚠️  Missing $((2 - VALIDATOR_COUNT)) validators"
fi
echo ""

METRIC_COUNT=$(find "$HOME/.claude/metrics" -name "*.sh" 2>/dev/null | wc -l | tr -d ' ')
echo "  Metrics: $METRIC_COUNT/1"
echo ""

TEMPLATE_COUNT=$(find "$HOME/.claude/templates" -type f 2>/dev/null | wc -l | tr -d ' ')
echo "  Templates: $TEMPLATE_COUNT/8"
if [ "$TEMPLATE_COUNT" -lt 8 ]; then
    echo "    ⚠️  Missing $((8 - TEMPLATE_COUNT)) templates"
fi
echo ""

# Check manifest
echo "📜 Installation Manifest:"
if [ -f "$HOME/.claude/.agentic-substrate-manifest.json" ]; then
    echo "  ✅ Present"
    if command -v python3 &> /dev/null; then
        MANIFEST_FILES=$(python3 -c "import json; print(len(json.load(open('$HOME/.claude/.agentic-substrate-manifest.json'))['managed_files']))" 2>/dev/null || echo "?")
        echo "  Files tracked: $MANIFEST_FILES"
    fi
else
    echo "  ❌ Missing"
fi
echo ""

# Summary
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
TOTAL=$((AGENT_COUNT + SKILL_COUNT + COMMAND_COUNT + HOOK_COUNT + VALIDATOR_COUNT + METRIC_COUNT + TEMPLATE_COUNT))
echo "📊 Total files: $TOTAL/60"
echo ""

if [ "$TOTAL" -eq 60 ] && [ "$COMMAND_COUNT" -eq 12 ] && [ "$SKILL_COUNT" -eq 5 ]; then
    echo "✅ INSTALLATION COMPLETE"
    echo ""
    echo "All components installed correctly!"
elif [ "$COMMAND_COUNT" -lt 12 ] || [ "$SKILL_COUNT" -lt 5 ]; then
    echo "❌ INSTALLATION INCOMPLETE"
    echo ""
    echo "Problem: Commands and/or Skills are missing"
    echo ""
    echo "Likely causes:"
    echo "  1. Old version of install.sh (before curl fix)"
    echo "  2. Installation was interrupted"
    echo "  3. Permissions issue"
    echo ""
    echo "Solution:"
    echo "  Run installation again with latest version:"
    echo "  curl -fsSL https://raw.githubusercontent.com/VAMFI/claude-user-memory/main/install.sh | bash -s -- --force"
else
    echo "⚠️  INSTALLATION PARTIALLY COMPLETE"
    echo ""
    echo "Some files are missing. Run with --force to reinstall:"
    echo "  curl -fsSL https://raw.githubusercontent.com/VAMFI/claude-user-memory/main/install.sh | bash -s -- --force"
fi
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Detailed file listing if requested
if [ "$1" = "--verbose" ] || [ "$1" = "-v" ]; then
    echo "📝 Detailed File Listing:"
    echo ""
    find "$HOME/.claude" -type f 2>/dev/null | grep -v ".DS_Store" | sort | sed 's|'"$HOME/.claude/"'||' | sed 's/^/  /'
    echo ""
fi
