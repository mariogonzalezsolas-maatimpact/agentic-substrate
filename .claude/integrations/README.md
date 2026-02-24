# LangGraph Integration for Agentic Substrate v5.4

Optional LangGraph templates for running the Agentic Substrate workflow as a Python state machine.

> **Note**: The Agentic Substrate works fully without LangGraph. These templates are for users who want to run the workflow as a standalone Python application outside of Claude Code.

## What's Included

```
.claude/integrations/
├── README.md                              (this file)
└── langgraph/
    ├── brahma_state.py.template           (state definition + quality gates)
    ├── brahma_graph.py.template           (StateGraph workflow - runnable)
    └── quality_gates.py.template          (scoring + routing functions)
```

## When to Use This

| Scenario | Use LangGraph? |
|----------|---------------|
| Normal Claude Code usage | No - use `/do`, `/workflow`, agents directly |
| Want state persistence across crashes | Yes - PostgresSaver checkpointing |
| Building a CI/CD pipeline that runs agents | Yes - standalone Python execution |
| Need visual debugging of workflow | Yes - graph visualization |
| Running agents from your own Python app | Yes - import and invoke graph |

## Quick Start

```bash
# 1. Install dependencies
pip install langgraph>=0.6.0 langchain-anthropic

# 2. Copy templates (remove .template suffix)
cd .claude/integrations/langgraph
cp brahma_state.py.template brahma_state.py
cp brahma_graph.py.template brahma_graph.py
cp quality_gates.py.template quality_gates.py

# 3. Run the demo
python brahma_graph.py
```

Expected output:
```
============================================================
Agentic Substrate v5.4 - LangGraph Core Workflow
============================================================
  [docs-researcher] Researching: Add Redis caching to ProductService
  [implementation-planner] Planning from ResearchPack (score: 85)
  [brahma-analyzer] Analyzing plan consistency
  [code-implementer] Implementing with TDD (attempt 1/3)
  [complete] Workflow finished. 2 files modified.

============================================================
RESULT:
  Phase: complete
  Circuit breaker: closed
  Artifacts: ['src/service.py', 'tests/test_service.py']
  Retries: 0
  Tests: 12 passing, 0 failing
```

## Architecture

The graph maps directly to the Agentic Substrate workflow:

```
START
  │
  ▼
research (docs-researcher)
  │
  ├── score >= 80 ──► plan (implementation-planner)
  │                     │
  │                     ├── score >= 85 ──► analyze (brahma-analyzer)
  │                     │                     │
  │                     │                     ├── score >= 80 ──► implement (code-implementer)
  │                     │                     │                     │
  │                     │                     │                     ├── tests pass ──► complete ──► END
  │                     │                     │                     │
  │                     │                     │                     └── tests fail ──► retry
  │                     │                     │                                         │
  │                     │                     │                                         ├── retries < 3 ──► implement
  │                     │                     │                                         │
  │                     │                     │                                         └── retries >= 3 ──► CIRCUIT BREAKER OPEN
  │                     │                     │
  │                     │                     └── conflicts ──► plan (re-plan)
  │                     │
  │                     └── score < 85 ──► retry
  │
  └── score < 80 ──► retry
```

### Quality Gates

| Transition | Threshold | Agent |
|------------|-----------|-------|
| Research → Plan | Score >= 80 | docs-researcher |
| Plan → Analyze | Score >= 85 | implementation-planner |
| Analyze → Implement | Score >= 80, no conflicts | brahma-analyzer |
| Implement → Complete | All tests passing | code-implementer |

### Circuit Breaker

Opens after 3 failed retries in any phase. Reset with `/circuit-breaker reset` in Claude Code.

## Production Setup

For production, replace `InMemorySaver` with `PostgresSaver`:

```python
from langgraph.checkpoint.postgres import PostgresSaver

DB_URI = "postgresql://user:pass@localhost:5432/agentic_substrate"

with PostgresSaver.from_conn_string(DB_URI) as checkpointer:
    checkpointer.setup()  # Creates tables on first run
    graph = build_core_workflow(checkpointer=checkpointer)
    result = graph.invoke(initial_state, config)
```

Install: `pip install langgraph-checkpoint-postgres`

## Customizing

### Replace stub nodes with real agents

Each node function in `brahma_graph.py` has `# --- STUB ---` markers. Replace these with:

1. **Claude API calls** via `langchain-anthropic`
2. **Your own agent logic** (any Python code)
3. **External tool calls** (APIs, databases, file systems)

### Add Growth tier nodes

The templates include `GrowthAuditState` for parallel audits:

```python
# Add growth nodes to the graph
builder.add_node("seo_audit", seo_node)
builder.add_node("security_audit", security_node)
builder.add_node("ux_review", ux_node)

# Fan out from a trigger node
builder.add_edge("trigger_growth", "seo_audit")
builder.add_edge("trigger_growth", "security_audit")
builder.add_edge("trigger_growth", "ux_review")
```

## Requirements

- Python >= 3.9
- `langgraph >= 0.6.0`
- `langchain-anthropic` (for Claude model integration)
- PostgreSQL (optional, for production checkpointing)

---

**Version**: 5.4.0 | **Updated**: 2026-02-24 | **Status**: Templates ready
