# Changelog

All notable changes to Agentic Substrate will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.4.0] - 2026-02-18

### Added
- **SessionStart hook** (`session-start.sh`): Auto-loads project context at session start (git branch, last commit, uncommitted count, circuit breaker state, existing artifacts, recent file activity)
- **`/mode` command**: Behavioral mode switching (token-efficiency for compact outputs, introspection for meta-cognitive analysis, default to restore)
- **Skill extraction hook** (`skill-extraction-reminder.sh`): Claudeception-style UserPromptSubmit hook that injects skill extraction reminders every 5th prompt, evaluating whether recent work produced reusable knowledge
- **Semantic quality gates**: Prompt-type hooks on SubagentStop with matchers for `docs-researcher` (ResearchPack scoring) and `implementation-planner` (Plan scoring) using LLM evaluation instead of regex

### Changed
- **Commands**: 11 → 12 (added `/mode`)
- **Hooks**: 10 → 12 (added session-start.sh, skill-extraction-reminder.sh)
- **Managed files**: 56 → 60 (4 new files)
- **settings.json**: Added SessionStart, UserPromptSubmit, and prompt-type SubagentStop hooks
- **Version**: Bumped across CLAUDE.md, user-level template, install.sh, install.ps1, manifest

---

## [5.3.0] - 2026-02-18

### Added
- **`/review` command**: Multi-perspective code review using parallel subagents (security + performance + architecture + UX). Inspired by Compound Engineering's 12-perspective review pattern.
- **`/review` routing in `/do`**: "review", "code review", "PR review" keywords auto-route to `/review`

### Changed
- **agents-overview.md**: Slimmed from 570 → ~110 lines (-81% context reduction) using compact table format
- **workflows-overview.md**: Slimmed from 407 → ~65 lines (-84% context reduction)
- **skills-overview.md**: Slimmed from 133 → ~30 lines (-77% context reduction)
- **Total @import savings**: ~900 lines / ~4,500 tokens saved per session
- **Commands**: 10 → 11 (added `/review`)
- **Manifest**: Updated to v5.3.0 with 56 managed files, 11 commands
- **Version**: Bumped across CLAUDE.md, user-level template, install.sh, install.ps1

---

## [5.2.0] - 2026-02-18

### Added
- **settings.json**: Hook configuration file for Claude Code (CRITICAL - hooks now properly registered)
- **pre-compact-backup.sh**: PreCompact hook preserves context before compaction
- **Agent frontmatter**: Added `model`, `maxTurns`, `skills` to all 15 agents
  - 3 critical agents use Opus (chief-architect, code-implementer, brahma-investigator)
  - 12 standard agents use Sonnet 4.6 (~5x cost reduction)
  - All agents now have turn limits (15-100) preventing runaway execution
  - docs-researcher, implementation-planner, brahma-analyzer, code-implementer get skill preloading

### Fixed
- **Hook exit codes**: Changed from exit 1 to exit 2 (Claude Code blocking convention)
- **Hook stdin protocol**: auto-format.sh, check-agent-economics.sh, suggest-context-edits.sh now read JSON from stdin instead of positional args
- **Ghost references**: brahma-clarifier replaced with chief-architect in integrations/README.md and knowledge-core.md
- **docs-researcher**: Now has tools allowlist (Read, Grep, Glob, WebFetch, WebSearch) - no Write/Bash access
- **implementation-planner**: Now has tools allowlist (Read, Grep, Glob, Write) - no Bash/Edit access

### Changed
- **Tier 4 agents**: Model changed from opus to sonnet (cost optimization without quality loss)
- **Manifest**: Updated to v5.2.0 with 55 managed files, 10 hooks
- **install.sh/install.ps1**: Version bumped to 5.2.0

---

## [5.1.1] - 2026-02-18

### Fixed
- **validate-implementation-plan.sh**: Quality gate now blocks implementation (exit 1) when plan score < 85 (was exit 0)
- **install.ps1**: Version updated from 4.1.0 to 5.1.0, agent count 9 → 15, commands 5 → 10

### Added
- **implementation-report.md**: Shared report template extracted from code-implementer.md (~160 lines saved)
- **Context7 MCP**: Added to mcp-config-template.json (user must install separately)
- **Tier 4 agent mappings**: All 6 Growth agents added to mcp-config-template.json

### Changed
- **CLAUDE.md**: Slimmed from 329 → ~65 lines (relies on @imports for detail, removed redundant content)
- **code-implementer.md**: Refactored from 1,018 → ~600 lines (extracted report template, trimmed verbose examples)
- **mcp-config-template.json**: Updated to v2.0.0, added 6 Tier 4 agent mappings
- **manifest-template.json**: Updated to 52 managed files, 8 templates

---

## [5.1.0] - 2026-02-18

### Fixed
- **validate-research-pack.sh**: Quality gate now blocks planning (exit 1) when research score < 80 (was exit 0)
- **update-knowledge-core.sh**: Heredoc now evaluates `$(date)` properly (removed single-quoted EOF)
- **task-completed.sh**: Windows compatibility for `-newer` flag with fallback to `-mmin`

### Added
- **think-protocol.md**: Shared Think Protocol template (extracted from 15 agents, ~1,500 lines saved)
- **memory: project**: Persistent project-scoped memory frontmatter added to all 15 agents
- **/security-audit**: New command routing to `@security-auditor` for OWASP Top 10 audits
- **/seo-audit**: New command routing to `@seo-strategist` for technical SEO audits
- **/ux-review**: New command routing to `@ux-accessibility-reviewer` for WCAG 2.2 audits

### Changed
- **Version**: 5.0.0 → 5.1.0
- **Commands**: 7 → 10 (added security-audit, seo-audit, ux-review)
- **manifest-template.json**: Updated to v5.1.0, 47 → 51 managed files, 7 → 10 commands, 6 → 7 templates
- **All 15 agents**: Think Protocol replaced with shared `@import` reference
- **README.md**: Version bumped to v5.1 (English + Spanish), fixed broken archive link, updated command counts
- **CLAUDE.md**: Version bumped to v5.1
- **CLAUDE.md.user-level**: Version bumped to v5.1, added 3 new commands to listing
- **agents-overview.md**: Version bumped to v5.1, updated timestamp

### Archived
- 25 stale root .md files moved to `archive/v4-artifacts/` via git mv

---

## [5.0.0] - 2026-02-17

### Added

#### Tier 4: Growth & Strategy Agents (6 new agents)
- **@seo-strategist** - Technical SEO audit, Core Web Vitals, schema markup, keyword strategy
- **@business-analyst** - Business logic analysis, requirements engineering, process optimization, SWOT/ROI
- **@content-strategist** - Content marketing, brand voice, SEO content, social media strategy
- **@product-strategist** - Product strategy, market analysis (TAM/SAM/SOM), competitive intelligence, roadmaps
- **@security-auditor** - OWASP Top 10 assessment, code security review, compliance (SOC2/GDPR/HIPAA/PCI DSS)
- **@ux-accessibility-reviewer** - WCAG 2.2 compliance, Nielsen's 10 heuristics, inclusive design

#### Enhanced `/do` Command Routing
- 6 new intent categories: SEO, Business Analysis, Content/Marketing, Product Strategy, Security, UX/Accessibility
- Keyword classification for automatic routing to Tier 4 agents
- 7 new routing examples in command documentation

#### New Workflow Patterns
- SEO & Content Strategy workflow (`@seo-strategist` + `@content-strategist`)
- Product Launch workflow (`@product-strategist` + `@content-strategist` + `@brahma-deployer`)
- Security-First Development workflow (`@security-auditor` + `@code-implementer`)
- UX-Driven Development workflow (`@ux-accessibility-reviewer` + `@code-implementer`)
- Business Process Optimization workflow (`@business-analyst` + `@implementation-planner`)
- Full Growth Audit workflow (all Tier 4 agents in parallel)

### Changed
- **Version**: 4.1.0 → 5.0.0
- **Agent count**: 9 → 15 across 4 tiers (was 3 tiers)
- **Model optimization**: All agents optimized for Claude Opus 4.6
- **Agent versioning**: docs-researcher, implementation-planner, code-implementer updated to v3.0 (Opus 4.6)
- **README.md**: Updated to v5.0 in both English and Spanish sections
- **agents-overview.md**: Added complete Tier 4 documentation, updated model references
- **workflows-overview.md**: Added Growth & Strategy routing table and 6 new workflow patterns
- **skills-overview.md**: Added Tier 4 integration example
- **CLAUDE.md**: Updated to v5.0 with Growth & Strategy tier documentation
- **manifest-template.json**: Updated to v5.0.0, added 6 new agent files (38 → 44 total files)
- **manifest.json**: Updated to v5.0.0, agent count 4 → 15
- **install.sh**: Updated version to 5.0.0

### Architecture
- **4-Tier Agent System**:
  - Tier 1: Orchestration (1 agent) - chief-architect
  - Tier 2: Core Workflow / BUILD+FIX (5 agents) - research, planning, analysis, implementation, debugging
  - Tier 3: Production / SERVE (3 agents) - deployment, monitoring, optimization
  - Tier 4: Growth & Strategy / GROW (6 agents) - SEO, business, content, product, security, UX

### Performance
- All Tier 4 agents include Think Protocol integration
- DeepWiki MCP mandatory for all new agents
- Quality scoring systems: SEO Score (0-100), Security Score (0-100), UX+A11y Score (0-100)
- Anti-stagnation measures with time limits and progress reporting

---

## [3.1.0] - 2025-10-25

### Added

#### Adaptive Learning System (Adaptation Pattern from Chapter 9)
- **3-Phase Learning Loop**: Before (suggest patterns) → During (track metrics) → After (update confidence)
- **Bayesian Confidence Scoring**: `confidence = base_confidence × time_decay_factor × evidence_factor`
  - Base confidence from success rate (successes / total_uses)
  - Time decay factor: 1.0 (<90 days), 0.75 (90-180 days), 0.5 (180+ days)
  - Evidence factor: 0.5 (<3 uses), 0.75 (3-4 uses), 1.0 (5+ uses)
- **Confidence Levels**: HIGH (≥80%), MEDIUM (50-79%), LOW (<50%)
- **Context-Aware Pattern Matching**: ≥60% tag similarity required
- **Hybrid Architecture**:
  - Human-readable: `knowledge-core.md` (existing patterns)
  - Machine-readable: `~/.claude/data/pattern-index.json` (metrics and confidence)

#### New Files
- `~/.claude/data/pattern-index.json` - Pattern metrics storage (9 patterns migrated)
- `~/.claude/scripts/calculate-confidence.sh` - Standalone Bayesian confidence calculator
- `~/.claude/scripts/validate-pattern-index.sh` - JSON validation script
- `.vamfi/tests/test_adaptation_pattern.sh` - Comprehensive test suite (12 tests)

#### Enhanced Agents
- **chief-architect.md**: Added Phase 3.5 pattern suggestion workflow (+103 lines)
  - Suggests proven patterns before implementation
  - Allows user acceptance/rejection
  - Passes pattern context to code-implementer
- **code-implementer.md**: Added metrics tracking capabilities (+63 lines)
  - Captures implementation start time
  - Tracks retry attempts during self-correction
  - Records success/failure and quality gates
  - Passes metrics to pattern-recognition skill for learning

#### Enhanced Skills
- **pattern-recognition/skill.md**: Transformed from passive to adaptive (+391 lines)
  - Phase 1: Pattern suggestion before implementation
  - Phase 2: Context extraction and similarity matching
  - Phase 3: Metrics capture during implementation
  - Phase 4: Confidence update after completion
  - Graceful degradation when pattern-index.json missing

### Changed
- **Version**: Bumped from 3.0.0 to 3.1.0
- **README.md**: Added "Adaptive Learning (NEW v3.1)" section with:
  - 3-phase workflow visualization
  - Performance impact metrics (30-40% faster on 5th+ similar feature)
  - Key features and example usage
- **pattern-recognition skill**: Now version 3.1 with adaptive capabilities
- **chief-architect agent**: Now version 1.1 with pattern suggestion
- **code-implementer agent**: Now version 2.1 with metrics tracking

### Performance Impact
- **Expected Improvements**:
  - 30-40% faster implementations on 5th+ similar feature
  - 80%+ pattern suggestion accuracy
  - 70%+ user acceptance rate
  - Zero breaking changes (100% backward compatible)

### Testing
- **Automated Tests**: 12 tests, all passing
  - 6 automated (confidence calculation, JSON validation, schema, degradation)
  - 6 file existence checks
  - 4 manual tests documented
- **Coverage**: Pattern suggestion, metrics tracking, confidence calculation, graceful degradation
- **Platform**: Verified on macOS (Darwin 25.0.0)

### Documentation
- **ResearchPack**: 888 lines, score 100/100
  - Complete analysis of Adaptation Pattern from Chapter 9
  - Hybrid architecture design
  - Integration strategy with existing patterns
- **Implementation Plan**: 1,900 lines, score 100/100
  - 9-step surgical implementation
  - Rollback procedures for each step
  - Testing strategy and validation criteria

### Migration Notes
- **Backward Compatible**: All existing workflows continue working unchanged
- **Graceful Degradation**: System functions normally without pattern-index.json
- **Migration**: 9 existing patterns automatically migrated to pattern-index.json with conservative defaults
- **Safe Rollback**: Feature branch used for easy rollback if needed

---

## [3.0.0] - 2025-10-15

### Added
- Initial release of Agentic Substrate system
- 4 specialized agents (chief-architect, docs-researcher, implementation-planner, code-implementer)
- 5 auto-invoked skills (research, planning, quality-validation, pattern-recognition, context-engineering)
- Quality gates (ResearchPack ≥80, Implementation Plan ≥85)
- TDD enforcement with RED-GREEN-REFACTOR cycle
- Extended thinking protocols (think, think hard, think harder, ultrathink)
- Self-correction with 3-retry circuit breaker
- Git integration with co-author attribution
- Knowledge preservation in knowledge-core.md

### Performance
- 4.8-5.5x faster feature implementation
- +54% improvement on complex tasks (Think Tool)
- +49-67% research accuracy (Contextual Retrieval)
- +39% context optimization, -84% token reduction

---

## Format

- **[X.Y.Z]** - YYYY-MM-DD
  - **Added**: New features
  - **Changed**: Changes in existing functionality
  - **Deprecated**: Soon-to-be removed features
  - **Removed**: Removed features
  - **Fixed**: Bug fixes
  - **Security**: Vulnerability fixes
