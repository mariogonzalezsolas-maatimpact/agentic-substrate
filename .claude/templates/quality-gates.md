# Quality Gates

Standard quality gates for all workflow routes in the Agentic Substrate. Gates ensure outputs meet quality thresholds before advancing to the next phase.

---

## Gate Definitions

### Research Gate
- **Threshold**: Score >= 80/100
- **Evaluator**: quality-validation skill
- **Blocks**: Plan phase cannot start until research passes

### Plan Gate
- **Threshold**: Score >= 85/100
- **Evaluator**: quality-validation skill
- **Blocks**: Implementation cannot start until plan passes

### Analysis Gate
- **Threshold**: Score >= 80/100
- **Evaluator**: brahma-analyzer
- **Blocks**: Implementation cannot start until analysis passes

### Implementation Gate
- **Threshold**: All tests pass, circuit breaker closed
- **Evaluator**: Test runner + circuit breaker state
- **Blocks**: Cannot mark task complete with failing tests

---

## Gates Per Route

| Route | Gates | Gate Sequence |
|-------|-------|---------------|
| FEATURE | 3 | Research (80+) -> Plan (85+) -> Tests Pass |
| DEBUG | 2 | Investigation Complete -> Fix Verified |
| REVIEW | 1 | Review Complete |
| DEPLOY | 2 | Pre-deploy Checks -> Post-deploy Validation |
| RESEARCH | 1 | ResearchPack (80+) |
| PLAN | 1 | Plan Score (85+) |
| IMPLEMENT | 1 | Tests Pass |
| OPTIMIZE | 2 | Baseline Measured -> Improvement Verified |
| MONITOR | 1 | Three Pillars Configured |
| SEO | 1 | Audit Score Delivered |
| SECURITY | 1 | Audit Score Delivered |
| UX | 1 | Audit Score Delivered |
| BUSINESS | 1 | Analysis Report Delivered |
| CONTENT | 1 | Strategy Report Delivered |
| PRODUCT | 1 | Strategy Report Delivered |
| CONTEXT | 0 | None (utility command) |
| ORCHESTRATE | N | Per-phase gates (delegated to chief-architect) |
| SIMPLE | 0 | None (direct answer) |

---

## Gate Evaluation Format

When evaluating a gate, report:

```
GATE: [Gate Name]
SCORE: [X/100] or [PASS/FAIL]
VERDICT: [PASS | FAIL | WARN]
REASON: [1-line explanation]
BLOCKERS: [None | List of issues preventing pass]
```

### Verdicts
- **PASS**: Score meets threshold, no blockers -- proceed
- **WARN**: Score meets threshold with caveats -- proceed with caution
- **FAIL**: Score below threshold or critical blockers -- stop and fix

---

## Circuit Breaker

Tracks consecutive implementation failures. Opens after 3 failures to prevent infinite loops.

### States
- **CLOSED** (normal): Implementation proceeds
- **OPEN** (blocked): 3 consecutive failures, implementation halted

### Triggers
- Test failure after self-correction attempt -> increment counter
- Build failure after fix attempt -> increment counter
- 3 consecutive failures -> circuit breaker OPENS

### Recovery
```bash
/circuit-breaker status    # Check current state
/circuit-breaker reset     # Reset to CLOSED
```

### Rules When OPEN
1. Cannot start new implementation tasks
2. Must diagnose root cause first (use @brahma-investigator)
3. Reset requires explicit user action
4. Previous work is preserved (not rolled back)

---

## Quality Score Rubrics

### Research Score (80+ to pass)

| Criteria | Points | Description |
|----------|--------|-------------|
| Source authority | 0-25 | Official docs, DeepWiki verification |
| Version accuracy | 0-20 | Correct library version documented |
| API completeness | 0-25 | All needed APIs with signatures |
| Code examples | 0-15 | Working examples from official sources |
| Gotchas documented | 0-15 | Known issues and workarounds noted |

### Plan Score (85+ to pass)

| Criteria | Points | Description |
|----------|--------|-------------|
| Completeness | 0-25 | All files, steps, and tests listed |
| Minimal change | 0-20 | Fewest files touched, surgical edits |
| Rollback plan | 0-20 | Complete rollback procedure documented |
| API fidelity | 0-20 | APIs match ResearchPack exactly |
| Risk assessment | 0-15 | Risks identified with mitigations |

### Analysis Score (80+ to pass)

| Criteria | Points | Description |
|----------|--------|-------------|
| Constitution alignment | 0-20 | Principles respected |
| Coverage completeness | 0-25 | All requirements traced |
| Consistency validation | 0-25 | No conflicts between artifacts |
| Conflict resolution | 0-20 | Conflicts resolved with reasoning |
| Documentation quality | 0-10 | Clear, actionable report |

---

## Integration

### With /do Command
`/do` enforces gates based on the detected route:
1. Classify intent -> determine route
2. Show plan with applicable gates
3. Execute phases, evaluating gates between each
4. Block advancement if gate fails
5. Report final status

### With Agent Teams
Each teammate's deliverable passes through the relevant gate before the lead accepts it.

### With Circuit Breaker
Checked before every implementation phase. If OPEN, `/do` refuses to start implementation and suggests diagnostics.

---

**Updated**: 2026-02-24 | **Version**: 6.0.0 | **Gates**: 4 defined, 18 routes covered
