# Skills Overview

10 skills that enhance agent capabilities:

| Skill | Triggers When | Key Function |
|-------|--------------|--------------|
| research-methodology | Library/API implementation needed | Fetches version-accurate docs, assembles ResearchPack (<2 min) |
| planning-methodology | Research -> plan transformation | Minimal-change blueprints with rollback procedures |
| quality-validation | ResearchPack or Plan completed | Scores and gates: Research 80+, Plan 85+ |
| pattern-recognition | After successful implementation | Captures patterns to knowledge-core.md |
| context-engineering | Session start, every 50 msgs, task switch | Context rot prevention (39% improvement, 84% token reduction) |
| architecture-methodology | Architecture decisions needed | C4 diagrams, ADRs, pattern evaluation, trade-off analysis |
| api-methodology | API design decisions needed | Contract-first, OpenAPI, versioning, error design |
| testing-methodology | Test strategy decisions needed | Test pyramid, coverage targets, mock strategy, anti-flaky |
| project-organization | New project, onboarding, "organize" | 6-pillar codebase organization for agent navigation (<30s) |
| error-learning | Mistake made, approach failed, user correction | Auto-captures errors, 6 categories, pattern escalation to rules |

## How They Work Together

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

**Updated**: 2026-03-10 | **Version**: 7.1.0
