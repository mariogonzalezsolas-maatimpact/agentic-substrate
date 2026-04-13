# Skills Overview

41 skills that enhance agent capabilities:

### Core Workflow Skills

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **pyramid-loop** | **Any code-producing /do route** | **Manages plan->code->review loop with fix iterations (max 3)** |
| research-methodology | Library/API implementation needed | Fetches version-accurate docs, assembles ResearchPack (<2 min) |
| planning-methodology | Research -> plan transformation | Minimal-change blueprints with rollback procedures |
| quality-validation | ResearchPack or Plan completed | Scores and gates: Research 80+, Plan 85+ |
| pattern-recognition | After successful implementation | Captures patterns to knowledge-core.md |
| context-engineering | Session start, every 50 msgs, task switch | Context rot prevention (39% improvement, 84% token reduction) |
| error-learning | Mistake made, approach failed, user correction | Auto-captures errors, 6 categories, pattern escalation to rules |
| **auto-memory-capture** | Significant decision, failed approach, non-obvious solution, compaction imminent | Captures decisions, failed approaches (FAIL format), user corrections to persistent memory. Compression, deduplication, budget tracking |
| **memory-search** | Searching memory for prior decisions, failed approaches, overlapping work | Progressive disclosure search: INDEX -> SUMMARY -> DETAIL. 75-97% token savings vs read-all |
| **folder-context** | User runs `/folder-context` or asks to generate directory context | Auto-generates lightweight CLAUDE.md in subdirectories from memory observations |
| **generate-docs** | User asks to generate AI docs, configure .claude, setup project for AI | Agentic interview + .claude/ structure generation/migration (Spanish) |

### Engineering Methodology Skills

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| architecture-methodology | Architecture decisions needed | C4 diagrams, ADRs, pattern evaluation, trade-off analysis |
| api-methodology | API design decisions needed | Contract-first, OpenAPI, versioning, error design |
| testing-methodology | Test strategy decisions needed | Test pyramid, coverage targets, mock strategy, anti-flaky |
| project-organization | New project, onboarding, "organize" | 7-pillar codebase organization for agent navigation (<30s) |
| **django-patterns** | Project uses Django (manage.py, settings.py, django in requirements) | Split settings, custom User, QuerySets, DRF serializers/viewsets, service layer, caching, signals, N+1 prevention, bulk ops, indexing |
| **nextjs-firebase-gcp** | Project uses Next.js + PostgreSQL + Firebase + GCP | Server Components, Prisma ORM, Firebase Auth/Firestore, GCP Cloud Run deployment, integration patterns |

### Process & Quality Skills (NEW)

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **brainstorming-gate** | `/do` routes to FEATURE or ORCHESTRATE | Mandatory design-approval: context, questions, proposals, spec doc, self-review |
| **git-worktrees** | Workspace isolation requested, concurrent features | Git worktree creation with setup auto-detection, baseline tests, Windows-compatible |
| **verification-before-completion** | About to claim completion, commit, or move to next task | Evidence-before-claims gate: identify-run-read-verify-claim, anti-hallucination |

### Frontend & Design Skills (NEW in v7.2)

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **ui-ux-pro-max** | UI/UX design decisions, component architecture | Design tokens, typography scales, spacing systems, layout patterns, micro-interactions, form UX, dashboard design |
| **frontend-design** | Frontend architecture, component composition | Component patterns (compound, headless, render props), state management strategy, CSS architecture, error/loading/empty states, performance |
| **shadcn-ui** | Project uses shadcn/ui components | Radix UI + Tailwind CSS, CVA variants, theming with CSS variables, form patterns (react-hook-form + zod), dark mode, data tables |
| **web-accessibility** | Building user-facing web interfaces | WCAG 2.2 (A/AA/AAA), ARIA patterns, keyboard navigation, focus management, semantic HTML, accessible forms/modals, screen readers |
| **web-design-guidelines** | Visual design decisions needed | Typography, color theory, spacing (4px grid), visual hierarchy, Gestalt principles, responsive grids, whitespace, elevation system |

## How They Work Together

### Pyramid Flow (Default for code-producing tasks)
```
User: "/do Add Redis caching"
  1. pyramid-loop -> activates 3-tier orchestration
  1.5. brainstorming-gate -> design approval (FEATURE/ORCHESTRATE only)
  2. @plan-coordinator: research-methodology + planning-methodology + quality-validation (85+)
  3. @code-coordinator: TDD implementation from plan
  4. @review-coordinator: code review + browser testing + quality-validation (80+)
  5. IF review FAILS -> fix loop: plan-coordinator re-plans -> code-coordinator fixes -> review again
  6. IF review PASSES -> pattern-recognition -> knowledge-core.md
  7. context-engineering -> Archives completed, loads next task
```

### Legacy Flow (Direct agent dispatch)
```
User: "Add Redis caching"
  1. research-methodology -> ResearchPack
  2. quality-validation -> Score >= 80? Proceed
  3. planning-methodology -> Implementation Plan
  4. quality-validation -> Score >= 85? Proceed
  5. [code-implementer executes with TDD]
  6. pattern-recognition -> Captures to knowledge-core.md
  7. context-engineering -> Archives completed, loads next task

User: "Design the API for user management"
  1. api-methodology -> Contract-first design
  2. [api-designer creates OpenAPI spec]
  3. quality-validation -> API spec complete? Proceed

User: "Evaluate architecture for the payment system"
  1. architecture-methodology -> Pattern evaluation + ADR
  2. [software-architect delivers C4 + trade-off analysis]

User: "Improve test coverage for auth module"
  1. testing-methodology -> Test pyramid + coverage analysis
  2. [testing-engineer identifies gaps + writes tests]

User: "Organize this codebase for AI agents"
  1. project-organization -> Explore + audit structure
  2. [Creates docs/, rewrites CLAUDE.md, scratchpad, feedback loops]
  3. [Verifies build passes after reorganization]
```

### Security & Cybersecurity Skills (NEW in v7.3)

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **threat-hunting** | Threat detection, IOC analysis, Sigma rules | Sigma detection rules, MITRE ATT&CK mapping, log analysis |
| **computer-forensics** | Post-incident investigation, evidence collection | Disk/memory forensics, timeline reconstruction, chain of custody |
| **web-fuzzing** | Authorized pentesting, endpoint discovery | ffuf methodology, parameter/directory/vhost fuzzing |
| **supply-chain-audit** | Dependency security review | Typosquatting, dependency confusion, SBOM, license compliance |
| **semgrep-rules** | Custom SAST rule creation | Pattern writing, taint tracking, autofix, rule testing |
| **static-analysis** | SAST setup and triage | Semgrep, CodeQL, Bandit, ESLint security, SARIF parsing |
| **cloud-security** | Cloud infrastructure audit | AWS/Azure/GCP IAM, storage exposure, CIS benchmarks |
| **container-security** | Docker/K8s security review | Image scanning, RBAC audit, pod security, Falco, network policies |
| **api-security** | API penetration testing | OWASP API Top 10 (2023), BOLA/IDOR, GraphQL security |

### SaaS & Integration Skills (NEW in v7.3)

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **slack-automation** | Slack messaging, notifications, CI/CD integration | Block Kit, notification templates, MCP integration |
| **jira-automation** | Issue tracking, sprint management | JQL queries, workflow transitions, bulk operations |
| **salesforce-automation** | CRM operations, pipeline reporting | SOQL queries, lead/opportunity management, bulk data ops |

### Development Workflow Skills (NEW in v7.3)

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| **changelog-generator** | Release preparation, update summaries | Git commit categorization, user-language translation |
| **playwright-testing** | E2E testing, browser automation | Page navigation, assertions, visual regression, network mocking |
| **finishing-branch** | Branch ready for merge/PR | Pre-merge checklist, commit cleanup, PR preparation |
| **skill-generator** | Creating new skills from docs/knowledge | Meta-skill: converts documentation into structured skills |

## Commands

- `/context analyze` - Show context health
- `/context optimize` - Prune stale context
- `/context reset` - Fresh start

---

**Updated**: 2026-04-13 | **Version**: 7.3.0
