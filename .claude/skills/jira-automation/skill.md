---
name: jira-automation
description: "Automate Jira operations: create/update issues, manage sprints, track epics, transition workflows, bulk operations, and JQL queries. Integrates project management with development workflow."
auto_invoke: false
tags: [jira, automation, project-management, issues, sprints, agile]
---

# Jira Automation Skill

Automate Jira issue tracking, sprint management, and project workflows. Bridges the gap between development work and project management.

## When to Invoke

- Creating issues from code review findings or bug reports
- Updating issue status after implementation
- Sprint planning and management
- Bulk operations on issues
- JQL queries for reporting
- Linking commits/PRs to Jira issues

## Core Operations

### Issue Management

#### Create Issue
```json
{
  "project": "PROJ",
  "issuetype": "Bug",
  "summary": "Login redirect fails for OAuth users",
  "description": "## Steps to Reproduce\n1. Click 'Login with Google'\n2. Complete OAuth flow\n3. Observe redirect to /404 instead of /dashboard\n\n## Expected\nRedirect to /dashboard\n\n## Actual\nRedirect to /404\n\n## Environment\n- Browser: Chrome 125\n- OS: macOS 15",
  "priority": "High",
  "labels": ["bug", "auth", "regression"],
  "components": ["Authentication"],
  "assignee": "username"
}
```

#### Issue Types and Fields

| Type | When to Use | Required Fields |
|------|------------|----------------|
| Bug | Defect in existing functionality | Summary, Steps to Reproduce, Expected/Actual |
| Story | New user-facing functionality | Summary, Acceptance Criteria, Story Points |
| Task | Technical work, non-user-facing | Summary, Description |
| Epic | Large feature spanning multiple sprints | Summary, Description, Start/End Date |
| Sub-task | Breakdown of a Story/Task | Parent, Summary |
| Spike | Research/investigation work | Summary, Time Box, Questions to Answer |

### Workflow Transitions

Standard Jira workflow:

```
To Do -> In Progress -> In Review -> Done
  |          |             |
  +-> Blocked +-> Reopened -+
```

Common transition triggers:
- **To Do -> In Progress**: When starting implementation
- **In Progress -> In Review**: When PR is created
- **In Review -> Done**: When PR is merged
- **Any -> Blocked**: When external dependency blocks work
- **Done -> Reopened**: When regression is found

### JQL Queries

```sql
-- My open bugs, ordered by priority
assignee = currentUser() AND issuetype = Bug AND status != Done ORDER BY priority DESC

-- Sprint backlog
sprint in openSprints() AND project = PROJ ORDER BY rank ASC

-- Unresolved issues created this week
created >= startOfWeek() AND resolution = Unresolved

-- High priority blockers
priority in (Highest, High) AND status = Blocked

-- Issues without estimates
sprint in openSprints() AND (storyPoints is EMPTY OR storyPoints = 0)

-- Recently updated by team
project = PROJ AND updated >= -24h ORDER BY updated DESC

-- Security-related issues
labels in (security, vulnerability, cve) AND resolution = Unresolved

-- Epics with progress
issuetype = Epic AND status != Done AND project = PROJ
```

### Sprint Management

#### Sprint Metrics
```markdown
## Sprint Report

**Sprint**: Sprint 42 (2026-04-01 to 2026-04-14)
**Goal**: Complete authentication overhaul

| Metric | Value |
|--------|-------|
| Committed | 34 points |
| Completed | 29 points |
| Velocity | 85% |
| Bugs found | 3 |
| Bugs fixed | 5 |
| Carry-over | 2 stories (5 pts) |

### Completed
- [PROJ-101] OAuth2 integration (8pts)
- [PROJ-102] Session management (5pts)
- [PROJ-103] Password reset flow (3pts)

### Carried Over
- [PROJ-104] MFA setup wizard (3pts) - blocked on design
- [PROJ-105] SSO configuration (2pts) - scope increased
```

### Bulk Operations

| Operation | Use Case |
|-----------|----------|
| Bulk transition | Move all "In Review" to "Done" after release |
| Bulk label | Add "security-reviewed" to audited issues |
| Bulk assign | Reassign issues during team changes |
| Bulk estimate | Add story points during refinement |
| Bulk link | Link related issues after investigation |

### Issue Linking

| Link Type | When to Use |
|-----------|------------|
| blocks / is blocked by | Issue A must complete before B can start |
| duplicates / is duplicated by | Same issue reported twice |
| relates to | Issues are related but independent |
| causes / is caused by | Bug A introduced bug B |
| clones / is cloned by | Issue copied for another team/sprint |

## Integration Patterns

### Git Commit -> Jira

Include Jira issue key in commit messages:
```
PROJ-123: Fix OAuth redirect for Google provider

- Updated callback URL validation
- Added fallback redirect path
- Tests: 3 new, all passing
```

### PR -> Jira Transition

When a PR is created mentioning `PROJ-123`:
1. Transition issue to "In Review"
2. Add PR link to issue
3. Add reviewer as watcher

When PR is merged:
1. Transition issue to "Done"
2. Add resolution "Fixed"
3. Comment with merge commit hash

### With Agentic Substrate

- `/do` creates Jira issues for FEATURE route tasks
- `@review-coordinator` findings can create bug issues
- `@security-auditor` findings create security-labeled issues
- `@incident-commander` creates incident-tracking epics
- Sprint velocity feeds `@business-analyst` capacity planning

## API Reference

Base URL: `https://your-domain.atlassian.net/rest/api/3/`

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/issue` | POST | Create issue |
| `/issue/{key}` | GET/PUT | Read/update issue |
| `/issue/{key}/transitions` | GET/POST | Get/execute transitions |
| `/search` | POST | JQL search |
| `/sprint` | GET | List sprints |
| `/board/{id}/sprint` | GET | Sprints for a board |

## Source
Adapted from ComposioHQ/awesome-claude-skills jira-automation patterns and Atlassian API documentation.
