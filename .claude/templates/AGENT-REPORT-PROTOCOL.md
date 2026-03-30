# Agent Report Protocol

Standard compact report format for all Agentic Substrate agents. Every agent MUST use this format when completing a task and reporting back to the lead (chief-architect, /do, or user).

---

## Why This Protocol Exists

Sub-agents return raw, verbose output that floods the lead's context window. With Agent Teams (multiple parallel agents), this multiplies. The lead loses coordination capacity.

**This protocol solves that** by standardizing a compact report (<800 tokens) that the lead reads first, with drill-down available on demand.

---

## Report Format

When completing any task, deliver your final response in this exact structure:

```markdown
## Agent Report: [Agent Name]

**Task**: [1-line description of what was asked]
**Status**: [COMPLETE | COMPLETE_WITH_CONCERNS | PARTIAL | BLOCKED | FAILED]
**Duration**: [X] minutes
**Confidence**: [HIGH | MEDIUM | LOW]

### Key Findings

1. **[severity]** [Most important finding or deliverable] → [Suggested action]
2. **[severity]** [Second most important] → [Suggested action]
3. **[severity]** [Third, if applicable] → [Suggested action]

### Changes Made

- `path/to/file1.ext`: [What changed, 1 line]
- `path/to/file2.ext`: [What changed, 1 line]
- (or "No files modified" for research/analysis tasks)

### Metrics

| Metric | Value |
|--------|-------|
| [Relevant metric 1] | [Value] |
| [Relevant metric 2] | [Value] |
| [e.g., Tests passing] | [14/14] |
| [e.g., Quality score] | [87/100] |

### Blockers & Risks

- [Any unresolved issue, or "None"]
- [Any risk the lead should know about]

### Next Steps

- [Recommended follow-up action 1]
- [Recommended follow-up action 2]
- (or "No further action needed")

### Drill-Down Available

- [Name of detailed artifact, e.g., "Full ResearchPack", "Complete Audit Report"]
- Lead can request full details for any finding above
```

---

## Rules

1. **Max 800 tokens** for the report. Be concise. The lead reads this first.
2. **No raw dumps**. Never paste raw test output, full logs, or unformatted data.
3. **Findings are ranked**. Most important first. Max 5 findings.
4. **Changes are file-level**. One line per file. No code blocks in the report.
5. **Metrics are quantified**. Numbers, scores, percentages -- not prose.
6. **Blockers are actionable**. State what's needed to unblock, not just the problem.
7. **Drill-down is offered, not given**. The lead requests details only when needed.
8. **Severity is mandatory**. Every finding uses a severity tag.
9. **COMPLETE_WITH_CONCERNS** means the task is done but has flagged issues (MEDIUM severity findings, non-blocking risks). The orchestrator should log concerns but can proceed without a fix loop.

---

## Severity Levels

- **critical**: Immediate action required. Active security risk, service down, data loss.
- **high**: Action needed within 24h. Exploitable vulnerability, blocking bug, compliance gap.
- **medium**: Action needed within 1 week. Important improvement, recurring warning.
- **low**: Nice-to-have. Optimization, cleanup, minor improvement.
- **info**: Informational only. No action required.

Each finding in the Key Findings section MUST include a severity tag:
`**[critical/high/medium/low/info]** Description → Suggested action`

---

## When to Generate This Report

- After completing any task dispatched by the lead or /do
- After completing any task in an Agent Team
- After completing any phase in a /workflow execution
- When escalating a failure (status: BLOCKED or FAILED)

---

## How the Lead Consumes Reports

1. **Scan status line** across all agent reports (COMPLETE/COMPLETE_WITH_CONCERNS/BLOCKED/FAILED)
2. **Read Key Findings** from each agent (< 30 sec per agent)
3. **Detect cross-cutting issues** (same blocker across agents = systemic problem)
4. **Resolve dependency chains** (Agent A blocked on Agent B's output)
5. **Drill-down selectively** (request full details only for concerning findings)
6. **Synthesize** a unified response for the user

**Total lead overhead**: < 3000 tokens for a 5-agent team (5 x ~600 tokens).

---

## Relationship to Existing Output Formats

This compact report is a **wrapper**, not a replacement. Agents that produce detailed artifacts (ResearchPack, Implementation Plan, Analysis Report, Investigation Report, etc.) continue to produce them. The Agent Report is the summary the lead reads first. The detailed artifact is the drill-down layer.

```
Lead sees:     Agent Report (compact, <800 tokens)
                    |
Lead requests: Full artifact (ResearchPack, Plan, Audit Report, etc.)
```

---

## Pyramid Coordinator Reports

In the 3-tier pyramid orchestration, each Tier 2 coordinator uses a specialized compact report format optimized for the orchestrator to process quickly.

### Plan Coordinator Report (<500 tokens)
```markdown
## Plan Coordinator Report
**Task**: [1-line]
**Status**: [COMPLETE | COMPLETE_WITH_CONCERNS | BLOCKED]
**Plan Score**: [X/100]
**Research Done**: [Yes/No]

### Implementation Plan Summary
**Files**: [N] | **Steps**: [N] | **Est. Time**: [X min]
- `file1`: [change]
- `file2`: [change]

### Detailed Plan
[Full plan with code snippets]

### Blockers
- [Any, or "None"]
```

### Code Coordinator Report (<500 tokens)
```markdown
## Code Coordinator Report
**Task**: [1-line]
**Status**: [COMPLETE | COMPLETE_WITH_CONCERNS | PARTIAL | BLOCKED]
**Duration**: [X min]
**Self-Corrections**: [0-3]

### Changes Made
- `file1`: [change]

### Test Results
| Tests written | Tests passing | Regressions | Build |
|[N]|[N/N]|[0]|[PASS]|

### Git Commit
- Hash: [abc1234] | Rollback: `git revert [hash]`
```

### Review Coordinator Report (<600 tokens)
```markdown
## Review Coordinator Report
**Task**: Review of [feature]
**Status**: [PASS | PASS_WITH_CONCERNS | FAIL]
**Review Score**: [X/100]
**Iteration**: [1/2/3]

### Scores
| Correctness | Security | Performance | Quality | Tests |
|[X]|[X]|[X]|[X]|[X]|

### Findings
1. **[severity]** `file:line` -- [issue] -> [fix]

### Browser Testing
| Page loads | Feature flow | Console errors |
|[result]|[result]|[result]|

### Verdict
[PASS or FAIL with fix request]
```

### Why Separate Formats?

The orchestrator processes 3 coordinator reports per iteration (up to 9 for 3 iterations). Compact, typed reports allow:
- **Instant status scan**: Read 3 status lines in <5 sec
- **Targeted drill-down**: Only expand the report that needs attention
- **Fix loop efficiency**: Review FAIL report maps directly to plan-coordinator input
- **Total overhead**: ~1500 tokens per iteration (3 x ~500 tokens)

---

**Updated**: 2026-03-25 | **Version**: 7.2.0 | **Protocol**: Agent Report v1.2 (Pyramid-aware)
