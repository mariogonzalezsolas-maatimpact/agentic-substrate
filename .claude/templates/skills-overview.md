# Skills Overview

16 skills that enhance agent capabilities:

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

### Engineering Methodology Skills

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| architecture-methodology | Architecture decisions needed | C4 diagrams, ADRs, pattern evaluation, trade-off analysis |
| api-methodology | API design decisions needed | Contract-first, OpenAPI, versioning, error design |
| testing-methodology | Test strategy decisions needed | Test pyramid, coverage targets, mock strategy, anti-flaky |
| project-organization | New project, onboarding, "organize" | 6-pillar codebase organization for agent navigation (<30s) |

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

## Commands

- `/context analyze` - Show context health
- `/context optimize` - Prune stale context
- `/context reset` - Fresh start

---

**Updated**: 2026-03-25 | **Version**: 7.2.0
