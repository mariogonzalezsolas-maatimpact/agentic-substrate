# Example Agent Report

This document shows a concrete example of a well-formed Agent Report from @brahma-investigator, following the protocol defined in `agent-report-protocol.md`.

---

## Agent Report: brahma-investigator

**Task**: Investigate intermittent 503 errors on POST /api/payments endpoint
**Status**: COMPLETE
**Duration**: 8 minutes
**Confidence**: HIGH

### Key Findings

1. Root cause: Connection pool exhaustion in PaymentService due to unclosed database connections in the error handling path (`src/services/payment.ts:87`)
2. The `catch` block calls `stripe.refund()` but doesn't release the DB connection acquired at line 72, causing pool drain under load
3. Issue only manifests at >200 req/min because pool size is 20 and leaked connections timeout after 30s

### Changes Made

- No files modified (investigation only -- fix ready for @code-implementer)

### Metrics

| Metric | Value |
|--------|-------|
| Hypotheses tested | 3 |
| Root cause confirmed | Yes (reproduced) |
| Affected endpoint | POST /api/payments |
| Error frequency | ~15/hour at current traffic |
| Retry attempts used | 2 of 3 |

### Blockers & Risks

- None -- root cause confirmed and reproducible

### Next Steps

- @code-implementer: Add `finally` block at `payment.ts:87` to release DB connection
- @code-implementer: Add regression test simulating payment failure under concurrent load
- Consider increasing pool size from 20 to 50 as a safety margin

### Drill-Down Available

- Full Investigation Report with stack traces, hypothesis timeline, and reproduction steps
- Lead can request details for any finding above

---

## Why This Report Is Good

- **Under 800 tokens**: The lead gets the full picture in seconds
- **Status line**: COMPLETE + HIGH confidence = no follow-up needed
- **Finding #1 has the root cause** with exact file:line reference
- **Finding #3 explains the trigger condition** (why it's intermittent)
- **Metrics are quantified**: 3 hypotheses, 2 retries, 15/hour frequency
- **Next steps are specific**: exact file, exact fix, exact test to write
- **Drill-down offered**: full report available but not forced on the lead
