---
name: retro
description: Show a retrospective of recent sessions with trends, averages, and anomalies from recorded metrics.
---

# /retro

Analyze session metrics and show trends from `memory/events.jsonl`.

## Process

### Step 1: Load Data

Read `memory/events.jsonl` from the project root. Each line is a JSON object:

```json
{"date":"2026-03-30T14:22:00Z","tasks_completed":3,"files_changed":7,"test_pass_rate":1.0,"iterations":1,"duration_minutes":45,"route":"STANDARD"}
```

If the file does not exist or is empty, respond:
> No session data yet. Events are recorded automatically at session end.

### Step 2: Summary Table

Show the **last 10 sessions** as a table:

| Date | Tasks | Files | Tests | Iters | Duration | Route |
|------|-------|-------|-------|-------|----------|-------|

### Step 3: Trends

Calculate and display:
- **Avg tasks/session**
- **Avg test pass rate** (as percentage)
- **Avg iterations/session**
- **Most used routes** (top 3 with counts)
- **Total sessions recorded**

### Step 4: Anomalies

Flag sessions where:
- `iterations > 3` (exceeded retry budget)
- `test_pass_rate < 0.8` (low test reliability)
- `duration_minutes > 120` (unusually long session)

If no anomalies, say "No anomalies detected."

## Output

Present everything in a single, readable report. Keep commentary brief -- let the numbers speak.
