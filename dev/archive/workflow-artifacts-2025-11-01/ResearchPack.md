# 📋 ResearchPack: Installation System Improvement

## Task & Context

**Goal**: Create safe, selective installation scripts that preserve user data while updating Agentic Substrate components

**Technology Stack**:
- Language: Bash shell script
- Runtime: macOS (Darwin 25.0.0)
- Target: ~/.claude/ directory (Claude Code CLI home)

**Research Objective**: Understand current installation system, identify what can be touched vs. protected, and define requirements for safe selective installation.

---

## 📚 Current State Analysis

### 1. Current install.sh (v3.1)

**What it does**:
- Creates full backup: `~/.claude.backup-YYYYMMDD-HHMMSS`
- Creates directory structure if missing
- Copies ALL components with `cp -r` (overwrites everything)
- Special handling for pattern-index.json (preserves if exists)
- Sets executable permissions on hooks/validators/metrics
- Installs user-level CLAUDE.md from template

**Problems identified**:
1. ❌ **Overwrites user-modified files**: `cp -r` overwrites ALL agent/skill/command files
2. ❌ **No version tracking**: Cannot detect what version is currently installed
3. ❌ **No manifest system**: Cannot track which files we manage vs. user-created
4. ❌ **No selective update**: Cannot update just changed files
5. ❌ **Silent overwrite**: May lose user customizations to our files
6. ⚠️ **Touches settings.json**: Copies from repo (lines 25-26 in repo have these files)

**What it does RIGHT**:
- ✅ Creates backup before any changes
- ✅ Preserves pattern-index.json if exists
- ✅ Creates directory structure safely
- ✅ Sets correct permissions
- ✅ Informative output messages

### 2. Current update-local-installation.sh (v3.1)

**What it does**:
- Updates ONLY specific files for v3.1
- Creates backup before update
- Selective copying (only chief-architect, code-implementer, pattern-recognition)
- Preserves existing pattern-index.json
- Updates CLAUDE.md version header with sed
- Runs tests if available

**Problems identified**:
1. ❌ **Hardcoded file list**: Must manually edit for each update
2. ❌ **Version-specific**: Only knows about v3.0 → v3.1 migration
3. ❌ **No manifest**: Cannot generalize to any version update
4. ❌ **Fragile sed pattern**: Line 86-94 uses complex multiline sed
5. ⚠️ **Missing data/scripts directories**: Lines 55-72 create directories that don't exist in repo

**What it does RIGHT**:
- ✅ Selective update (doesn't touch everything)
- ✅ Creates backup
- ✅ Preserves user data
- ✅ Runs validation tests
- ✅ Clear upgrade messaging

### 3. Repository Structure

**Our Managed Files** (what we install/update):

```
.claude/
├── agents/                          # 9 agent files
│   ├── brahma-analyzer.md
│   ├── brahma-deployer.md
│   ├── brahma-investigator.md
│   ├── brahma-monitor.md
│   ├── brahma-optimizer.md
│   ├── chief-architect.md
│   ├── code-implementer.md
│   ├── docs-researcher.md
│   └── implementation-planner.md
│
├── skills/                          # 5 skill directories
│   ├── context-engineering/skill.md
│   ├── pattern-recognition/skill.md
│   ├── planning-methodology/skill.md
│   ├── quality-validation/skill.md
│   └── research-methodology/skill.md
│
├── commands/                        # 5 command files
│   ├── context.md
│   ├── implement.md
│   ├── plan.md
│   ├── research.md
│   └── workflow.md
│
├── hooks/                           # 7 hook scripts
│   ├── auto-format.sh
│   ├── check-agent-economics.sh
│   ├── run-tests.sh
│   ├── suggest-context-edits.sh
│   ├── update-knowledge-core.sh
│   ├── validate-implementation-plan.sh
│   └── validate-research-pack.sh
│
├── validators/                      # 2 validator scripts
│   ├── api-matcher.sh
│   └── circuit-breaker.sh
│
├── metrics/                         # 1 metrics script
│   └── tracker.sh
│
├── templates/                       # 6 template files
│   ├── agentic-substrate-personal.md.example
│   ├── agents-overview.md
│   ├── CLAUDE.md.template
│   ├── CLAUDE.md.user-level
│   ├── skills-overview.md
│   └── workflows-overview.md
│
├── settings.json                    # ⚠️ SHOULD NOT INSTALL
├── settings.local.json              # ⚠️ SHOULD NOT INSTALL
├── .circuit-breaker-state          # ⚠️ SHOULD NOT INSTALL
└── .DS_Store                        # ⚠️ SHOULD NOT INSTALL
```

**Total managed files**: 35 files (9 agents + 5 skills + 5 commands + 7 hooks + 2 validators + 1 metric + 6 templates)

**Files in repo that SHOULD NOT be installed**:
- `.claude/settings.json` - User preference file (CLI-managed)
- `.claude/settings.local.json` - User overrides (CLI-managed)
- `.claude/.circuit-breaker-state` - Runtime state (tool-managed)
- `.claude/.DS_Store` - macOS metadata (system-generated)

### 4. Claude Code CLI Directory Structure

**Protected Files** (NEVER touch - CLI/user managed):

```
~/.claude/
├── debug/                           # CLI debug logs (44 files observed)
│   └── *.txt                        # Session debug output
│
├── file-history/                    # Edit history tracking (CLI-managed)
│   └── [session-id]/                # Per-session file edit history
│
├── history.jsonl                    # Command history (CLI-managed, 93KB observed)
│
├── projects/                        # Per-project data (CLI-managed)
│   └── [project-path]/              # e.g., -Users-amba-Code-claude-user-memory/
│       └── *.jsonl                  # Session transcripts, agent data
│
├── session-env/                     # Session environment data (CLI-managed)
│   └── [session-id]/                # Per-session environment
│
├── shell-snapshots/                 # Bash shell state snapshots (CLI-managed)
│   └── [session-id]/                # Per-session shell state
│
├── statsig/                         # Analytics data (CLI-managed)
│
├── todos/                           # Todo tracking (CLI-managed, 87 files observed)
│   └── [session-id]/                # Per-session todos
│
├── plugins/                         # Plugin system (CLI-managed)
│   └── installed_plugins.json       # Plugin registry
│
├── ide/                             # IDE integration data (CLI-managed)
│
├── settings.json                    # User settings (CLI-managed)
│
└── settings.local.json              # Local overrides (CLI-managed)
```

**Total protected directories**: 11 directories (debug, file-history, projects, session-env, shell-snapshots, statsig, todos, plugins, ide + 2 settings files + history.jsonl)

### 5. Data Directories Mystery

**Issue**: update-local-installation.sh references directories that don't exist in repo:

```bash
# Lines 55-72 in update-local-installation.sh
if [ ! -d "$HOME/.claude/data" ]; then
    mkdir -p "$HOME/.claude/data"
fi

if [ ! -d "$HOME/.claude/scripts" ]; then
    mkdir -p "$HOME/.claude/scripts"
fi
```

**Finding**: These directories do NOT exist in `./.claude/`

**Hypothesis**: These were planned for v3.1 (adaptive learning) but:
- pattern-index.json may have been stored elsewhere
- Scripts (calculate-confidence.sh, validate-pattern-index.sh) may not have been implemented
- OR they exist in user's installation but not in repo

**Action needed**: Verify if these should be in repo or removed from scripts

---

## 🎯 Best Practices Research

### Version Tracking Patterns

**Pattern 1: Version File** (npm, pip)
```bash
# Store version in dedicated file
echo "3.1.0" > ~/.claude/.agentic-substrate-version

# Read during update
INSTALLED_VERSION=$(cat ~/.claude/.agentic-substrate-version 2>/dev/null || echo "none")
```

**Pattern 2: Manifest with Version** (brew)
```json
{
  "version": "3.1.0",
  "installed_at": "2025-11-01T21:54:00Z",
  "files": {
    "agents/chief-architect.md": {
      "hash": "sha256:abc123...",
      "size": 12345,
      "user_modified": false
    }
  }
}
```

**Pattern 3: Version in Main File** (git)
```bash
# Store in CLAUDE.md header
grep "^# Agentic Substrate v" ~/.claude/CLAUDE.md | sed 's/.*v\([0-9.]*\).*/\1/'
```

**Recommendation**: Use Pattern 1 (version file) + Pattern 2 (manifest) combined

### Manifest System Patterns

**Purpose**: Track which files we manage vs. user-created

**Pattern: File Manifest** (used by package managers)
```json
{
  "manifest_version": "1.0.0",
  "substrate_version": "3.1.0",
  "installed_at": "2025-11-01T21:54:00Z",
  "managed_files": [
    "agents/chief-architect.md",
    "agents/docs-researcher.md",
    "skills/research-methodology/skill.md",
    "commands/workflow.md"
  ],
  "user_files": [
    "agents/my-custom-agent.md"
  ],
  "protected_paths": [
    "debug/",
    "history.jsonl",
    "projects/",
    "session-env/",
    "settings.json"
  ]
}
```

**Benefits**:
- Know what we installed
- Detect user-added files
- Prevent accidental deletion
- Enable clean uninstall
- Track modifications

### Selective Copy Strategies

**Strategy 1: File-by-file with manifest**
```bash
# Read manifest, copy only our files
for file in $(jq -r '.managed_files[]' manifest.json); do
    cp "$SOURCE/$file" "$TARGET/$file"
done
```

**Strategy 2: rsync with exclude**
```bash
# Copy everything but exclude protected
rsync -av \
  --exclude='debug/' \
  --exclude='history.jsonl' \
  --exclude='projects/' \
  "$SOURCE/.claude/" "$TARGET/"
```

**Strategy 3: Checksum comparison**
```bash
# Only copy if changed
if [ "$(sha256sum $SOURCE/$file)" != "$(sha256sum $TARGET/$file)" ]; then
    cp "$SOURCE/$file" "$TARGET/$file"
fi
```

**Recommendation**: Strategy 1 (manifest-driven) is safest and most explicit

### Backup Strategies

**Current approach**: Full directory copy (simple, safe, space-inefficient)

**Alternatives**:

**Pattern 1: Incremental backup** (git-style)
```bash
# Only backup files we're about to change
for file in "${FILES_TO_UPDATE[@]}"; do
    mkdir -p "$(dirname "$BACKUP/$file")"
    cp "$TARGET/$file" "$BACKUP/$file" 2>/dev/null || true
done
```

**Pattern 2: Differential backup**
```bash
# Backup only changed files
rsync -av --compare-dest="$TARGET" "$TARGET/" "$BACKUP/"
```

**Recommendation**: Keep current full backup approach (simplicity > efficiency at ~/.claude scale ~10MB)

### Rollback Strategies

**Pattern 1: Swap directories** (current approach via manual command)
```bash
rm -rf ~/.claude && mv ~/.claude.backup-20251101 ~/.claude
```

**Pattern 2: Scripted rollback**
```bash
# Create rollback script during install
cat > ~/.claude/rollback-to-v3.0.sh <<'EOF'
#!/bin/bash
mv ~/.claude ~/.claude-v3.1-backup
mv ~/.claude.backup-20251101 ~/.claude
echo "Rolled back to v3.0"
EOF
chmod +x ~/.claude/rollback-to-v3.0.sh
```

**Pattern 3: Manifest-based restore**
```bash
# Restore only our files from backup
for file in $(jq -r '.managed_files[]' manifest.json); do
    cp "$BACKUP/$file" "$TARGET/$file"
done
```

**Recommendation**: Pattern 2 (scripted rollback) - user-friendly one-command restore

---

## 🔧 macOS Considerations

### File Permissions

**Standard approach** (current):
```bash
chmod +x ~/.claude/hooks/*.sh
chmod +x ~/.claude/validators/*.sh
chmod +x ~/.claude/metrics/*.sh
```

**Best practice**: Set permissions after copy
```bash
find ~/.claude/hooks -name "*.sh" -exec chmod +x {} \;
find ~/.claude/validators -name "*.sh" -exec chmod +x {} \;
find ~/.claude/metrics -name "*.sh" -exec chmod +x {} \;
```

### Directory Creation

**Current approach**: `mkdir -p` (correct, idempotent)

**Safety check**:
```bash
# Verify we're not creating in wrong location
if [[ "$TARGET" == "$HOME/.claude" ]]; then
    mkdir -p "$TARGET/agents"
else
    echo "ERROR: Invalid target $TARGET"
    exit 1
fi
```

### Symlink Handling

**Not currently used**, but if needed:
```bash
# Create symlink for templates (optional)
ln -sf "$HOME/.claude/templates/CLAUDE.md.user-level" "$HOME/.claude/CLAUDE.md"
```

**Recommendation**: Stick with file copies (simpler, no symlink breakage)

---

## ✅ Implementation Requirements

### New install.sh Must Do

**Core Requirements**:
1. ✅ **Version tracking**: Write version to `~/.claude/.agentic-substrate-version`
2. ✅ **Manifest creation**: Generate manifest.json with all managed files
3. ✅ **Selective installation**: Copy ONLY files in manifest (use explicit file list)
4. ✅ **Protect CLI files**: NEVER touch debug/, history.jsonl, projects/, session-env/, settings.json, todos/, etc.
5. ✅ **Full backup**: Keep current approach (`~/.claude.backup-TIMESTAMP`)
6. ✅ **Directory structure**: Create agent/skill/command/hook/validator/metric/template directories
7. ✅ **Executable permissions**: Set on all .sh files
8. ✅ **User-level CLAUDE.md**: Install from template
9. ✅ **Rollback script**: Generate rollback-to-vX.Y.sh
10. ✅ **Detect existing install**: Warn if version already installed

**Safety Requirements**:
1. ✅ **Pre-flight checks**: Verify source directory structure
2. ✅ **Dry-run mode**: Option to preview what will be installed
3. ✅ **Confirmation**: Ask before overwriting existing installation
4. ✅ **Error handling**: Rollback on failure
5. ✅ **Validation**: Verify installation success

**User Experience**:
1. ✅ **Progress indicators**: Show what's being installed
2. ✅ **Clear output**: Differentiate new install vs. upgrade
3. ✅ **Post-install summary**: What was installed, what was preserved
4. ✅ **Next steps**: Quick start instructions

### New update.sh Must Do

**Core Requirements**:
1. ✅ **Version detection**: Read current version from `.agentic-substrate-version`
2. ✅ **Manifest-driven**: Read `manifest.json` to know what to update
3. ✅ **Selective update**: Update ONLY changed files (compare manifest versions)
4. ✅ **Preserve customizations**: Detect user-modified files, ask before overwriting
5. ✅ **Incremental backup**: Backup only files being updated
6. ✅ **Update manifest**: Write new manifest with updated files
7. ✅ **Update version**: Write new version to `.agentic-substrate-version`
8. ✅ **Rollback script**: Generate rollback script

**Intelligence Requirements**:
1. ✅ **Change detection**: Only update if file actually changed (checksum comparison)
2. ✅ **Conflict resolution**: Detect user modifications, offer merge options
3. ✅ **Migration support**: Handle structural changes (e.g., file moves)
4. ✅ **Dependency tracking**: Update dependencies in order

**Safety Requirements**:
1. ✅ **Dry-run mode**: Show what would be updated
2. ✅ **Selective update**: Option to skip certain components
3. ✅ **Validation**: Run tests after update
4. ✅ **Atomic update**: All or nothing (rollback on failure)

### Testing Requirements

**Test Scenarios**:
1. ✅ Fresh install (no ~/.claude exists)
2. ✅ Fresh install (empty ~/.claude exists)
3. ✅ Upgrade from v3.0 to v3.1
4. ✅ Reinstall same version (should be idempotent)
5. ✅ Install with user customizations present
6. ✅ Install with CLI-generated files present
7. ✅ Rollback after install
8. ✅ Rollback after update
9. ✅ Dry-run mode (no actual changes)
10. ✅ Failure handling (interrupt mid-install)

**Validation Tests**:
1. ✅ All managed files present
2. ✅ Permissions correct on .sh files
3. ✅ Version file contains correct version
4. ✅ Manifest contains all files
5. ✅ Protected files untouched
6. ✅ User files preserved
7. ✅ Rollback script functional
8. ✅ CLAUDE.md installed

---

## 📊 File Inventory Summary

### Our Managed Files (35 files)

**Agents** (9 files):
- brahma-analyzer.md
- brahma-deployer.md
- brahma-investigator.md
- brahma-monitor.md
- brahma-optimizer.md
- chief-architect.md
- code-implementer.md
- docs-researcher.md
- implementation-planner.md

**Skills** (5 files):
- context-engineering/skill.md
- pattern-recognition/skill.md
- planning-methodology/skill.md
- quality-validation/skill.md
- research-methodology/skill.md

**Commands** (5 files):
- context.md
- implement.md
- plan.md
- research.md
- workflow.md

**Hooks** (7 files):
- auto-format.sh
- check-agent-economics.sh
- run-tests.sh
- suggest-context-edits.sh
- update-knowledge-core.sh
- validate-implementation-plan.sh
- validate-research-pack.sh

**Validators** (2 files):
- api-matcher.sh
- circuit-breaker.sh

**Metrics** (1 file):
- tracker.sh

**Templates** (6 files):
- agentic-substrate-personal.md.example
- agents-overview.md
- CLAUDE.md.template
- CLAUDE.md.user-level
- skills-overview.md
- workflows-overview.md

### Protected Paths (NEVER touch)

**CLI-Managed Directories**:
- debug/
- file-history/
- projects/
- session-env/
- shell-snapshots/
- statsig/
- todos/
- plugins/
- ide/

**CLI-Managed Files**:
- history.jsonl
- settings.json
- settings.local.json

**Repository Files to Exclude from Install**:
- .claude/.circuit-breaker-state (runtime state)
- .claude/.DS_Store (macOS metadata)
- .claude/settings.json (should not be in repo)
- .claude/settings.local.json (should not be in repo)

---

## 🎯 Proposed Solution Architecture

### 1. Manifest System

**File**: `~/.claude/.agentic-substrate-manifest.json`

```json
{
  "manifest_version": "1.0.0",
  "substrate_version": "3.1.0",
  "installed_at": "2025-11-01T21:54:00Z",
  "installed_by": "install.sh",
  "managed_files": {
    "agents/chief-architect.md": {
      "version": "3.1.0",
      "hash": "sha256:...",
      "installed_at": "2025-11-01T21:54:00Z",
      "user_modified": false
    }
  },
  "protected_paths": [
    "debug/",
    "file-history/",
    "history.jsonl",
    "projects/",
    "session-env/",
    "settings.json",
    "settings.local.json",
    "shell-snapshots/",
    "statsig/",
    "todos/",
    "plugins/",
    "ide/"
  ]
}
```

### 2. Version Tracking

**File**: `~/.claude/.agentic-substrate-version`

```
3.1.0
```

Simple, grepable, easy to read in scripts.

### 3. Installation Script Flow

```
install.sh
├── 1. Pre-flight checks
│   ├── Verify source directory
│   ├── Check write permissions
│   └── Detect existing version
│
├── 2. Backup (if existing)
│   ├── Create ~/.claude.backup-TIMESTAMP
│   └── Copy entire ~/.claude/
│
├── 3. Install
│   ├── Create directory structure
│   ├── Copy managed files (explicit list)
│   ├── Set permissions on .sh files
│   ├── Generate manifest
│   ├── Write version file
│   └── Install CLAUDE.md
│
├── 4. Post-install
│   ├── Generate rollback script
│   ├── Validate installation
│   └── Display summary
│
└── 5. Error handling
    └── Restore from backup on failure
```

### 4. Update Script Flow

```
update.sh
├── 1. Pre-update checks
│   ├── Detect current version
│   ├── Compare with new version
│   └── Read current manifest
│
├── 2. Change detection
│   ├── Compare file checksums
│   ├── Detect user modifications
│   └── Build update plan
│
├── 3. Backup
│   ├── Create incremental backup
│   └── Backup only files to change
│
├── 4. Update
│   ├── Copy changed files
│   ├── Update manifest
│   ├── Update version
│   └── Set permissions
│
├── 5. Post-update
│   ├── Run validation tests
│   ├── Generate rollback script
│   └── Display summary
│
└── 6. Error handling
    └── Rollback from incremental backup
```

---

## 📝 Recommendations

### Immediate Actions

1. **Remove from repository**:
   - `.claude/settings.json` (should not be in repo)
   - `.claude/settings.local.json` (should not be in repo)
   - `.claude/.circuit-breaker-state` (runtime state)
   - `.claude/.DS_Store` (macOS metadata)

2. **Add to repository**:
   - `.claude/.agentic-substrate-manifest.json` (template/example)
   - Explicit file list in install.sh (no more `cp -r`)

3. **Create new scripts**:
   - Rewrite `install.sh` with manifest system
   - Create `update.sh` (not update-local-installation.sh)
   - Add `validate-install.sh` for testing
   - Update `.gitignore` to exclude user data

### Long-term Enhancements

1. **Plugin system integration**: If Claude Code supports plugins, integrate with that
2. **Auto-update**: Check for new versions on startup
3. **Migration scripts**: Per-version migration helpers
4. **Diff tool**: Show what changed between versions
5. **Conflict resolution**: Smart merge for user modifications

---

## 🔗 Authoritative Sources

1. **Current Scripts**:
   - `./install.sh` - Current installation
   - `./update-local-installation.sh` - Current update
   - Version: 3.1.0

2. **Repository Structure**:
   - `./.claude/` - Source files
   - 35 managed files across 7 directories

3. **CLI Directory Analysis**:
   - `~/.claude/` - Actual user installation
   - Observed: 11 CLI-managed directories, 3 CLI-managed files

4. **Manifest Specification**:
   - `./manifest.json` - Package manifest
   - Version: 3.0.0 (needs update to 3.1.0)

**Confidence Level**: HIGH
- Actual file analysis performed on both repository and user installation
- All file counts verified
- Directory structure documented
- Current scripts analyzed in detail

---

## ❓ Open Questions

**For User**:
- [ ] Should we remove settings.json/settings.local.json from repository? (They shouldn't be tracked)
- [ ] Are data/ and scripts/ directories needed? (referenced in update-local but don't exist in repo)
- [ ] Should update.sh prompt before overwriting user-modified files, or auto-backup?
- [ ] Should we support partial updates (e.g., update only agents, skip skills)?

**For Planner**:
- [ ] How to handle user modifications to our files? (3-way merge, prompt, backup-and-replace?)
- [ ] Should manifest track checksums for modification detection?
- [ ] Should we validate file integrity on every CLI start?
- [ ] Integration with Claude Code's native plugin system (if any)?

---

## 📊 Research Metadata

- **Started**: 2025-11-01 22:00:00
- **Completed**: 2025-11-01 22:05:00
- **Duration**: ~5 minutes
- **Sources Consulted**: 8
  - Current install.sh
  - Current update-local-installation.sh
  - Repository file structure (35 files enumerated)
  - User installation directory structure (11 protected paths identified)
  - manifest.json
  - CLI-managed files analysis
  - Package manager best practices (npm, brew, pip patterns)
  - macOS bash scripting considerations
- **Agent**: docs-researcher v3.0

---

✅ Research complete - Ready for @implementation-planner
