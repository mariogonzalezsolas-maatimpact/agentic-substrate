---
name: changelog-generator
description: "Generate customer-friendly changelogs from git commits. Smart categorization, semantic grouping, technical-to-user language translation, and multiple output formats (CHANGELOG.md, release notes, app store)."
auto_invoke: false
tags: [changelog, release-notes, git, versioning, documentation]
---

# Changelog Generator Skill

Converts technical git commits into polished, customer-facing release notes.

## When to Invoke

- Preparing a release and need changelog
- Generating periodic update summaries (weekly, monthly)
- Creating app store submission notes
- Building release announcements for stakeholders

## Generation Protocol

### Step 1: Gather Commits

```bash
# Between tags
git log v1.2.0..v1.3.0 --pretty=format:"%h %s (%an)" --no-merges

# Last N days
git log --since="7 days ago" --pretty=format:"%h %s (%an)" --no-merges

# Between dates
git log --after="2026-04-01" --before="2026-04-14" --pretty=format:"%h %s (%an)" --no-merges
```

### Step 2: Categorize

Map commits to user-facing categories:

| Commit Prefix | Category | Emoji |
|--------------|----------|-------|
| feat: | New Features | - |
| fix: | Bug Fixes | - |
| perf: | Performance | - |
| security: | Security | - |
| docs: | Documentation | - |
| refactor: | Improvements | - |
| deps: | Dependencies | - |
| breaking: | Breaking Changes | - |

**Filter out** (internal, not user-facing):
- chore:, ci:, test:, style:, build:
- Merge commits
- Version bumps

### Step 3: Translate to User Language

| Technical Commit | User-Facing Entry |
|-----------------|-------------------|
| fix: null pointer in auth middleware | Fixed an issue where some users couldn't log in |
| feat: add Redis caching to /api/users | User profile pages now load 3x faster |
| perf: batch SQL queries in report gen | Report generation is significantly faster |
| security: upgrade jsonwebtoken to 9.0.2 | Improved security for session handling |
| fix: race condition in payment webhook | Fixed rare issue with duplicate payment processing |

### Step 4: Format Output

#### CHANGELOG.md Format
```markdown
## [1.3.0] - 2026-04-14

### New Features
- Added bulk export for transaction history
- Users can now set custom notification preferences
- New dashboard widget for real-time metrics

### Bug Fixes
- Fixed login issues for users with special characters in email
- Resolved intermittent timeout on large file uploads
- Fixed pagination in search results

### Performance
- Dashboard loads 40% faster with optimized queries
- Image uploads are now 2x faster with parallel processing

### Security
- Updated authentication tokens for improved security
- Fixed potential data exposure in error messages

### Breaking Changes
- API v1 endpoints are now deprecated (use v2)
- Minimum supported browser version updated to Chrome 100+
```

#### Release Announcement (Slack/Email)
```markdown
**v1.3.0 Release Notes**

Highlights:
- Bulk export for transactions
- 40% faster dashboard
- Custom notification preferences

Full changelog: [link]
```

#### App Store Notes
```
What's New in v1.3.0:
- Export your transaction history in bulk
- Customize your notification preferences
- Faster dashboard with real-time metrics
- Bug fixes and performance improvements
```

## Integration with Agentic Substrate

- Run after `@brahma-deployer` completes a release
- Feed output to `slack-automation` skill for announcement
- `@technical-writer` can refine generated changelogs
- Version tags from `@devops-engineer` CI/CD pipeline

## Source
Adapted from ComposioHQ/awesome-claude-skills changelog-generator.
