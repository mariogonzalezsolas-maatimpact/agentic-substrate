---
name: finishing-branch
description: "Guided workflow for completing development branches. Covers pre-merge checklist, test verification, PR preparation, commit cleanup, and merge strategy selection. Prevents incomplete merges."
auto_invoke: false
tags: [git, workflow, branch, merge, pr, release]
---

# Finishing a Development Branch

Structured workflow for completing development work on a branch before merge. Prevents incomplete merges and ensures quality.

## When to Invoke

- Branch is ready for merge/PR
- Sprint work is complete and needs packaging
- Feature is done but needs cleanup before merge
- User says "finish this branch", "prepare for merge", "ready to ship"

## Pre-Merge Checklist

### Step 1: Verify Completeness

```bash
# What's changed vs main
git diff main...HEAD --stat

# Uncommitted changes
git status

# Check for TODO/FIXME left behind
grep -rn "TODO\|FIXME\|HACK\|XXX" --include="*.{ts,js,py,go,rs}" .
```

**Gate**: No uncommitted changes. No unresolved TODOs in new code.

### Step 2: Test Verification

```bash
# Run full test suite
npm test  # or pytest, cargo test, go test ./...

# Check coverage
npm run test:coverage

# Build verification
npm run build
```

**Gate**: All tests pass. No regressions. Build succeeds.

### Step 3: Commit Cleanup

Evaluate commit history:

```bash
git log --oneline main..HEAD
```

**Options**:
- **Clean history** (few logical commits) -> Ready to merge
- **Messy history** (WIP, fixup, temp commits) -> Interactive rebase

```bash
# Squash WIP commits into logical units
git rebase -i main
# Mark fixup/WIP commits as 'squash' or 'fixup'
```

### Step 4: Rebase on Latest Main

```bash
git fetch origin main
git rebase origin/main

# Resolve any conflicts
# Test again after rebase
```

### Step 5: PR Preparation

```markdown
## PR Template

### Summary
[1-3 bullets: what this PR does and why]

### Changes
- `file1.ts`: [what changed]
- `file2.ts`: [what changed]

### Testing
- [ ] Unit tests added/updated
- [ ] Integration tests pass
- [ ] Manual testing done
- [ ] Edge cases covered

### Screenshots (if UI change)
[Before/After screenshots]

### Security Considerations
- [ ] No hardcoded secrets
- [ ] Input validation added
- [ ] No new attack surface

### Rollback Plan
`git revert <commit-hash>`
```

### Step 6: Merge Strategy

| Situation | Strategy | Command |
|-----------|----------|---------|
| Small feature, clean history | Merge commit | `git merge --no-ff` |
| Feature with many commits | Squash merge | `gh pr merge --squash` |
| Hotfix | Fast-forward | `git merge --ff-only` |
| Long-running branch | Rebase + merge | Rebase first, then merge |

## Post-Merge Cleanup

```bash
# Delete local branch
git branch -d feature/xyz

# Delete remote branch
git push origin --delete feature/xyz

# Verify main is clean
git checkout main && git pull && npm test
```

## Integration with Agentic Substrate

- Final step before `@brahma-deployer` takes over
- `@review-coordinator` runs during Step 5
- `changelog-generator` skill uses the commit history
- `@devops-engineer` handles CI/CD pipeline for the merge

## Source
Adapted from obra/superpowers finishing-a-development-branch workflow.
