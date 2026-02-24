# Portable Paths Fix

**Date:** 2025-10-23
**Issue:** Hook paths not portable across users
**Status:** ✅ FIXED

---

## 🐛 Problem

The original settings.json had hardcoded user-specific paths:

```json
{
  "hooks": {
    "PreToolUse": [{
      "command": "~/.claude/hooks/check-agent-economics.sh"  // ❌ Not portable
    }]
  }
}
```

**Impact:**
- ❌ Won't work for other users
- ❌ Breaks on different systems
- ❌ Not suitable for public OSS distribution

---

## ✅ Solution

Use **$HOME environment variable** for portable paths:

```json
{
  "hooks": {
    "PreToolUse": [{
      "command": "$HOME/.claude/hooks/check-agent-economics.sh"  // ✅ Portable
    }]
  },
  "agents": {
    "path": "$HOME/.claude/agents"  // ✅ Portable
  },
  "skills": {
    "path": "$HOME/.claude/skills"  // ✅ Portable
  }
}
```

**Benefits:**
- ✅ Works on any macOS/Linux system
- ✅ No hardcoded usernames
- ✅ Expands to correct home directory automatically
- ✅ Public OSS ready

---

## 📁 Path Strategy

### Global Config (~/.claude/settings.json)

**Use $HOME for absolute paths:**

```json
{
  "hooks": {
    "PreToolUse": [{
      "command": "$HOME/.claude/hooks/script.sh"
    }]
  },
  "agents": {
    "path": "$HOME/.claude/agents"
  }
}
```

### Project Config (.claude/settings.json)

**Use relative paths from project root:**

```json
{
  "hooks": {
    "PreToolUse": [{
      "command": ".claude/hooks/script.sh"  // Relative to project root
    }]
  },
  "agents": {
    "path": ".claude/agents"  // Relative to project root
  }
}
```

---

## 🔧 Update Instructions

### For Existing Users

If you have the old hardcoded paths:

```bash
# Update your global config
cd ~/.claude
# Manually edit settings.json to replace:
#   /Users/YOUR_USERNAME/.claude/  →  $HOME/.claude/
```

**Or reinstall:**

```bash
cd ~/path/to/claude-user-memory
git pull origin main
cp -r .claude ~/
```

### For New Users

The install script now uses portable paths automatically:

```bash
curl -fsSL https://raw.githubusercontent.com/mariogonzalezsolas-maatimpact/claude-user-memory/main/install.sh | bash
```

---

## 🧪 Verification

After fixing paths, verify with:

```bash
# Test path expansion
echo $HOME/.claude/hooks/check-agent-economics.sh

# Should show your actual home directory:
# /home/alice/.claude/hooks/check-agent-economics.sh  (Linux)
# /Users/bob/.claude/hooks/check-agent-economics.sh   (macOS)

# Run doctor to check configuration
/doctor
```

**Expected result:**
- ✅ No "No such file or directory" errors
- ✅ Hooks resolve correctly
- ✅ Agents load successfully

---

## 📊 Supported Path Formats

| Format | Example | Use Case | Portable? |
|--------|---------|----------|-----------|
| `$HOME` | `$HOME/.claude/hooks/script.sh` | Global config | ✅ Yes |
| `~` | `~/.claude/hooks/script.sh` | Shell expansion | ⚠️ Maybe* |
| Relative | `.claude/hooks/script.sh` | Project config | ✅ Yes |
| Absolute | `~/.claude/hooks/script.sh` | N/A | ❌ No |

\* Tilde `~` expansion depends on shell context - use `$HOME` for reliability

---

## 🚀 Distribution Strategy

### Repository Files

**Template (.claude/settings.json):**
- Use relative paths for project context
- Users copy this to their projects

**Global Template (for installation):**
- Use $HOME for all absolute paths
- install.sh copies to ~/.claude/

### Install Script

The `install.sh` handles:

```bash
# Copy to user's home with portable paths
cp -r .claude ~/.

# No path substitution needed - already using $HOME
```

---

## 🐛 Common Issues

### Issue: "No such file or directory"

**Cause:** Paths not resolving correctly

**Solution:**
1. Check settings.json uses `$HOME` or relative paths
2. Verify files exist: `ls $HOME/.claude/hooks/`
3. Check execute permissions: `chmod +x $HOME/.claude/hooks/*.sh`

### Issue: Hooks not firing

**Cause:** Invalid hook configuration or path resolution

**Solution:**
1. Run `/doctor` to validate config
2. Check Claude Code version (need v2.0.20+)
3. Verify hooks have correct matcher (e.g., "Task" for PreToolUse)

---

## ✅ Checklist for Contributors

When adding new hooks or paths:

- [ ] Use `$HOME` instead of absolute paths
- [ ] Use relative paths for project-specific files
- [ ] Test on different users/systems
- [ ] Document in README.md
- [ ] Update install.sh if needed
- [ ] Verify with `/doctor`

---

## 📖 Related Documentation

- [GITHUB-ISSUE-1-RESOLUTION.md](GITHUB-ISSUE-1-RESOLUTION.md) - Orchestrator invocation fix
- [README.md](README.md) - Installation instructions
- [install.sh](install.sh) - Installation script

---

**This fix ensures the Agentic Substrate works for ALL users, not just the original author. OSS-ready! 🎉**
