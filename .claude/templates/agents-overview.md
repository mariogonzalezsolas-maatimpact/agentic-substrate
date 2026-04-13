# Agents Overview

**32 agents** across 5 tiers + pyramid coordinators. Models: Opus (8 critical) + Sonnet (16 analysis) + Haiku (8 checklist).

## Pyramid Coordinators (NEW in v7.2)

| # | Agent | Model | Use When |
|---|-------|-------|----------|
| P1 | plan-coordinator | opus | All pyramid routes: research + plan the implementation |
| P2 | code-coordinator | opus | All pyramid routes: TDD implementation from plan |
| P3 | review-coordinator | sonnet | All pyramid routes: code review + browser testing via Playwright |

These 3 coordinators form the **default execution model** for all code-producing `/do` routes. See @.claude/templates/pyramid-orchestration.md

## Quick Reference

| # | Agent | Tier | Model | Use When |
|---|-------|------|-------|----------|
| 1 | chief-architect | Orchestration | opus | 3+ capabilities, multi-domain, uncertain scope |
| 2 | docs-researcher | Core | sonnet | External libraries/APIs need documentation |
| 3 | implementation-planner | Core | sonnet | ResearchPack ready, need execution blueprint |
| 4 | brahma-analyzer | Core | sonnet | Pre-implementation consistency check |
| 5 | code-implementer | Core | opus | Plan ready, TDD implementation needed |
| 6 | brahma-investigator | Core | opus | Complex bugs, production incidents |
| 7 | software-architect | Engineering | opus | System design, patterns, ADRs, module boundaries |
| 8 | programmer | Engineering | opus | Exploratory coding, prototyping, algorithms, pair programming |
| 9 | database-architect | Engineering | sonnet | Schema design, migrations, query optimization, indexes |
| 10 | api-designer | Engineering | sonnet | REST/GraphQL/gRPC design, OpenAPI specs, contracts |
| 11 | testing-engineer | Engineering | sonnet | Test strategy, coverage gaps, TDD coaching, flaky tests |
| 12 | devops-engineer | Infrastructure | sonnet | CI/CD pipelines, Docker, K8s, Terraform, IaC |
| 13 | secdevops-engineer | Infrastructure | sonnet | SAST/DAST, secret scanning, supply chain, pipeline security |
| 14 | brahma-deployer | Infrastructure | sonnet | Deploy to production, canary rollout |
| 15 | brahma-monitor | Infrastructure | sonnet | Observability, SLI/SLO, alerting |
| 16 | brahma-optimizer | Infrastructure | sonnet | Performance, scaling, cost optimization |
| 17 | seo-strategist | Growth | haiku | SEO audits (12 sub-commands), GEO, Core Web Vitals |
| 18 | business-analyst | Growth | haiku | Requirements, ROI, process optimization |
| 19 | content-strategist | Growth | haiku | Content marketing, brand voice, social media |
| 20 | product-strategist | Growth | haiku | Market analysis, roadmaps, GTM strategy |
| 21 | security-auditor | Growth | sonnet | OWASP Top 10, compliance, vulnerability scanning |
| 22 | ux-accessibility-reviewer | Quality | haiku | WCAG 2.2, usability heuristics, inclusive design |
| 23 | responsive-reviewer | Quality | haiku | Breakpoints, mobile-first, touch targets, fluid layouts |
| 24 | theme-reviewer | Quality | haiku | Dark/light mode, design tokens, contrast per theme |
| 25 | i18n-reviewer | Quality | haiku | Translations, RTL, pluralization, locale handling |
| 26 | technical-writer | Quality | sonnet | READMEs, API references, tutorials, changelogs, migration guides |
| 27 | mcp-builder | Engineering | opus | MCP server design, tool interfaces, Zod/Pydantic validation |
| 28 | data-engineer | Engineering | sonnet | ETL/ELT pipelines, data lakes, streaming, data quality |
| 29 | incident-commander | Infrastructure | sonnet | Incident response, severity classification, post-mortems, runbooks |

## Model Distribution

| Model | Count | Agents | Rationale |
|-------|-------|--------|-----------|
| Opus | 8 | chief-architect, code-implementer, brahma-investigator, software-architect, programmer, **plan-coordinator**, **code-coordinator**, **mcp-builder** | Orchestration + deep reasoning + complex coding + pyramid planning/coding + MCP design |
| Sonnet | 16 | docs-researcher, implementation-planner, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, security-auditor, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer, **review-coordinator**, **technical-writer**, **data-engineer**, **incident-commander** | Analysis + code generation + infrastructure + pyramid review + docs + data + incidents |
| Haiku | 8 | seo-strategist, business-analyst, content-strategist, product-strategist, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer | Checklist + content + review tasks |

---

## Agent Format (v7.1)

Every agent follows a standardized professional structure:

| Section | Purpose |
|---------|---------|
| **Role** | 3-sentence identity: who, what, how |
| **Philosophy** | 5-bullet guiding principles |
| **Technical Expertise** | 7-10 focused skills |
| **Scope** | What You DO / DON'T Do / File Ownership |
| **Communication Style** | Report format and tone |
| **Think Protocol** | Shared template reference |
| **[Protocol]** | Agent-specific operational sections |
| **Quality Gates** | Checklist before marking complete |
| **Output Protocol** | Agent Report format reference |

---

## Tier 1: Orchestration

### chief-architect
Master orchestrator. Decomposes complex projects into specialized tasks, selects agent teams, manages handoffs, coordinates parallel execution. Use for multi-step features or cross-domain tasks. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch, Task.

---

## Tier 2: Core Workflow (Research -> Plan -> Analyze -> Implement -> Debug)

### docs-researcher
Fetches version-accurate docs from official sources in <2 min. Delivers ResearchPack (must score 80+). **Tools**: Read, Grep, Glob, WebFetch, WebSearch.

### implementation-planner
Transforms ResearchPacks into minimal-change blueprints with rollback procedures. Plan must score 85+. **Tools**: Read, Grep, Glob, Write.

### brahma-analyzer
Validates alignment between specs, plans, tasks, and code. Detects gaps and conflicts before implementation. Analysis must score 80+. **Tools**: Read, Grep, Glob, Write.

### code-implementer
Executes plans with TDD (RED->GREEN->REFACTOR). Self-corrects with 3 retries + circuit breaker. All tests must pass. **Tools**: Read, Write, Edit, Bash, Grep, Glob.

### brahma-investigator
Systematic root cause analysis for complex bugs and production incidents. Progressive thinking: think -> think hard -> think harder. 3-retry limit. **Tools**: Read, Grep, Glob, Bash.

---

## Tier 3: Engineering (Architecture -> Code -> Database -> API -> Tests)

### software-architect
Designs system architecture, evaluates patterns (Clean, Hexagonal, Event-Driven, Microservices), creates C4 diagrams, writes ADRs, defines module boundaries, enforces SOLID/DDD. Output: Architecture Score 0-100. **Tools**: Read, Write, Edit, Grep, Glob, WebFetch, WebSearch.

### programmer
General-purpose coding specialist. Writes code from requirements without formal plans. Algorithms, data structures, prototyping, refactoring, pair programming. More flexible than code-implementer. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### database-architect
Schema design, migrations, query optimization, index strategies, SQL vs NoSQL evaluation, ORM anti-pattern detection (N+1). Output: Database Score 0-100. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### api-designer
REST, GraphQL, gRPC API design. OpenAPI specs, versioning strategies, rate limiting, pagination, error responses (RFC 7807). Output: API Design Score 0-100. **Tools**: Read, Write, Edit, Grep, Glob, WebFetch, WebSearch.

### testing-engineer
Test strategy, unit/integration/e2e test writing, mocking, coverage analysis, flaky test fixing, TDD coaching. Output: Testing Score 0-100. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### mcp-builder
MCP server specialist. Designs and builds Model Context Protocol tools with clean interfaces, structured error handling, and sub-500ms response times. Zod/Pydantic validation, tool description quality for agent selection. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### data-engineer
Data pipeline specialist. ETL/ELT pipelines, Medallion Architecture (Bronze/Silver/Gold), streaming (Kafka, Flink), data quality (Great Expectations, dbt tests), orchestration (Airflow, Dagster). **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

---

## Tier 4: Infrastructure (DevOps -> SecDevOps -> Deploy -> Monitor -> Optimize)

### devops-engineer
CI/CD pipelines, Docker, Kubernetes, Terraform/Pulumi, environment management, GitOps. Builds the delivery pipeline. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### secdevops-engineer
SAST/DAST integration, secret scanning, container scanning, SBOM, artifact signing (Sigstore), policy-as-code, pipeline hardening. Secures the delivery pipeline. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

### brahma-deployer
Safe deployments with canary rollout (5%->25%->50%->100%). Auto-rollback on error rate >1% or latency >500ms. **Tools**: Bash, Read, Write, Grep, WebFetch.

### brahma-monitor
Three pillars: Metrics + Logs + Traces. SLI/SLO tracking, proactive incident detection, runbook automation. **Tools**: Bash, Read, Write, WebFetch, Grep.

### brahma-optimizer
Performance profiling, scaling strategies, caching (Redis/CDN/app-level), DB query optimization. Profile first, optimize second. **Tools**: Bash, Read, Write, WebFetch, Grep.

### incident-commander
Incident response coordinator. Manages live incidents from detection through resolution and post-mortem. Severity classification (SEV1-SEV4), blameless post-mortems, runbook creation, SLO/SLI management. Complements @brahma-investigator (root cause) with human coordination. **Tools**: Read, Write, Edit, Bash, Grep, Glob, WebFetch, WebSearch.

---

## Tier 5: Growth, Strategy & Quality

### seo-strategist
Technical SEO audits with 12 sub-commands, GEO (AI search readiness), schema markup with deprecation tracking, programmatic SEO quality gates, industry-specific strategies. Output: SEO Score 0-100 (7 categories). **Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch.

### business-analyst
Requirements (MoSCoW), process mapping, SWOT/ROI analysis, KPI definition. Output: Business Analysis Report. **Tools**: Read, Write, Edit, Glob, Grep, WebFetch, WebSearch.

### content-strategist
Brand voice, SEO content, content calendars, audience personas, content pillars. Output: Content Strategy. **Tools**: Read, Write, Edit, WebFetch, WebSearch, Glob, Grep.

### product-strategist
Market sizing (TAM/SAM/SOM), competitive intelligence, RICE prioritization, roadmaps (Now/Next/Later). Output: Product Strategy. **Tools**: Read, Write, WebSearch, WebFetch, Glob, Grep.

### security-auditor
OWASP Top 10, code security patterns, dependency scanning, compliance (SOC2/GDPR/HIPAA/PCI DSS). Output: Security Score 0-100. **Tools**: Read, Grep, Glob, Write, WebSearch, WebFetch.

### ux-accessibility-reviewer
Nielsen's 10 heuristics, WCAG 2.2 (A/AA/AAA), keyboard/screen reader testing, color contrast. Output: UX+A11y Score 0-100. **Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch.

### responsive-reviewer
CSS breakpoint architecture, mobile-first patterns, touch target sizing, fluid typography, container queries, cross-device layout consistency. Output: Responsive Score 0-100. **Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch.

### theme-reviewer
Dark/light mode implementation, design token systems, CSS custom properties, color contrast per theme variant, FOUC prevention, theme transitions. Output: Theme Score 0-100. **Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch.

### i18n-reviewer
Hardcoded string detection, translation file structure, RTL support, ICU pluralization, Intl API formatting, locale routing, hreflang SEO. Output: i18n Readiness Score 0-100. **Tools**: Read, Write, Grep, Glob, WebFetch, WebSearch.

### technical-writer
Technical documentation specialist. READMEs (30-second orientation), API references, tutorials (time-to-first-success < 15 min), changelogs, migration guides, doc site frameworks (Mintlify, Docusaurus, VitePress). **Tools**: Read, Write, Edit, Grep, Glob, WebFetch, WebSearch.

---

## Quality Gates

| Transition | Gate | Threshold |
|------------|------|-----------|
| Research -> Plan | ResearchPack score | >= 80 |
| Plan -> Analyze | Plan score | >= 85 |
| Analyze -> Implement | Analysis score | >= 80 |
| Implement -> Done | Tests pass, circuit breaker closed | All green |

Full gate definitions: @.claude/templates/quality-gates.md

---

## Invocation

```bash
# Universal (recommended)
/do [anything]

# Full workflow
/workflow [feature]

# Direct
@chief-architect [complex task]
@docs-researcher [research topic]
@software-architect [design task]
@programmer [code task]
@database-architect [schema review]
@api-designer [API design]
@testing-engineer [test strategy]
@devops-engineer [pipeline task]
@secdevops-engineer [security pipeline]
```

---

**Updated**: 2026-04-13 | **Version**: 7.3.0 | **Agents**: 32 (8 Opus + 16 Sonnet + 8 Haiku)
