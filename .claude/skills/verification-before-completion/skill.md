---
name: verification-before-completion
description: "Evidence-before-claims gate. Enforces that NO completion claim is made without fresh verification evidence. Requires identify-run-read-verify-claim sequence before any success assertion, commit, or task completion."
auto_invoke: true
tags: [verification, anti-hallucination, evidence, quality, completion]
---

# Verification Before Completion Skill

**Iron Law: NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE.**

Every claim of success must be backed by evidence gathered in the current context. "I believe it works" is never acceptable. "Tests pass (12/12, including 3 new)" is required.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- About to claim a task is complete
- About to express satisfaction with work done
- About to commit code or create a PR
- About to move to the next task
- About to report success to the orchestrator

**This skill applies to ALL agents, ALL routes, ALL contexts.** No exceptions.

## The Gate Function

```
IDENTIFY -> RUN -> READ -> VERIFY -> CLAIM

1. IDENTIFY: What specific evidence would prove this claim?
   - "Tests pass" -> need test output
   - "Build succeeds" -> need build output
   - "Feature works" -> need test or manual verification
   - "Bug is fixed" -> need reproduction test output

2. RUN: Execute the verification command
   - npm test / pytest / cargo test / go test ./...
   - npm run build / cargo build
   - The specific check that proves the claim

3. READ: Read the FULL output
   - All test output, not just summary
   - Check for warnings, not just errors
   - Look for partial failures hidden in success

4. VERIFY: Does the output ACTUALLY confirm the claim?
   - "5 tests passed" -- does that include YOUR new tests?
   - "Build succeeded" -- with warnings?
   - "No errors" -- but did it test what you changed?

5. CLAIM: Only NOW state the result
   - Include evidence: "Tests pass (12/12, including 3 new)"
   - Reference output: "Build succeeds with 0 warnings"
   - Be specific: "Bug fix verified -- reproduction test passes"
```

## Red Flags (Self-Monitor)

| Red Flag | Meaning | Action |
|----------|---------|--------|
| "should work" | Haven't verified | Run verification |
| "probably fixed" | Guessing | Run the test |
| "seems to be working" | No evidence | Get evidence |
| "I believe" | Opinion, not fact | Get facts |
| "looks good" | Visual impression | Run automated check |
| "that should do it" | Premature conclusion | Verify first |

## Rationalization Prevention

| Rationalization | Why It's Wrong | Do Instead |
|----------------|---------------|------------|
| "The change is trivial" | Trivial changes cause 40% of outages | Run tests anyway |
| "I just ran tests 5 min ago" | Changes since then | Run tests AGAIN |
| "The error was obvious" | Obvious fixes miss edge cases | Write test, run it |
| "It compiled, so it works" | Compiling proves syntax, not logic | Run logic tests |
| "Same pattern as before" | Copy-paste introduces subtle bugs | Verify THIS instance |
| "I'll test after next change" | You'll forget or compound errors | Test NOW |

## Integration with Coordinators

### Code-Coordinator
Before reporting COMPLETE:
1. Run ALL tests (not just new ones)
2. Read full test output
3. Verify build passes
4. Include test counts in report

### Review-Coordinator
Before reporting PASS:
1. Verify all review checks were actually executed
2. Include evidence for each score dimension
3. Don't claim "no issues" without checking each category

### Plan-Coordinator
Before reporting plan COMPLETE:
1. Verify all referenced files exist (Glob/Read)
2. Verify APIs exist (via research, not memory)
3. Check each requirement is covered

## Common Verification Commands

| Claim | Command | What to Read |
|-------|---------|-------------|
| Tests pass | `npm test` / `pytest` / `cargo test` | Full output + counts |
| Build succeeds | `npm run build` / `cargo build` | Exit code + warnings |
| Lint clean | `npm run lint` / `ruff check` | Full output |
| Type-safe | `tsc --noEmit` / `mypy` | Full output |
| File created | `ls path/to/file` | Verify exists |
| No regressions | Full test suite | Compare counts |

## Test Failure Triage Protocol

When tests fail during implementation, classify each failure before acting:

### Classification
1. **Run tests on base branch first** (`git stash && npm test && git stash pop` or equivalent) to establish baseline
2. A failure is **in-branch** ONLY if it passes on the base branch but fails on your branch
3. A failure is **pre-existing** ONLY if it also fails on the base branch (with proof)
4. NEVER assume a failure is pre-existing without running the baseline

### Actions by Classification
- **In-branch failure**: Fix it. This is your responsibility.
- **Pre-existing failure**: Document it (`PREEXISTING: [test name] — fails on main too`). Do NOT fix unrelated failures — they are out of scope.
- **Ambiguous**: Run baseline. If you cannot run baseline, treat as in-branch (safer default).

### Forbidden
- Claiming "this was already broken" without baseline evidence
- Skipping or disabling pre-existing tests to make the suite green

## Quality Checklist

- [ ] Every success claim has fresh evidence
- [ ] Test output was READ, not just checked for exit code
- [ ] No red flag words in completion statement
- [ ] Evidence cited in report (test counts, build output)
- [ ] Verification was LAST thing done before claiming
