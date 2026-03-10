# Agentic Substrate v7.0

**Research-first development system for Claude Code CLI**

> 25 agents. 22 commands. 9 auto-invoked skills. 13 lifecycle hooks. Zero API hallucinations. Research first, code second.

[English](#english) | [Espanol](#espanol)

---

<a name="english"></a>

## Quick Start

```bash
git clone https://github.com/mariogonzalezsolas-maatimpact/claude-user-memory.git
cd claude-user-memory
python setup.py
```

Then in Claude Code:

```bash
/do add authentication to my API
```

That's it. `/do` classifies your intent, shows a plan, waits for confirmation, and executes.

---

## What This Is

A drop-in enhancement for [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) that installs to `~/.claude/` and transforms it into a research-first development system with:

- **25 specialized agents** across 5 tiers (Orchestration, Core, Engineering, Infrastructure, Growth & Quality)
- **9 auto-invoked skills** (research, planning, validation, pattern recognition, context management, architecture, API, testing, project organization)
- **22 slash commands** (`/do`, `/workflow`, `/research`, `/plan`, `/implement`, `/review`, `/mode`, `/context`, `/circuit-breaker`, `/security-audit`, `/seo-audit`, `/ux-review`, `/responsive-review`, `/theme-review`, `/i18n-review`, `/architecture`, `/database`, `/api-design`, `/test-strategy`, `/devops`, `/secdevops`, `/tech-debt`)
- **13 lifecycle hooks** (quality gates, auto-formatting, knowledge capture, session management, hawk oversight)
- **Quality gates** with scoring rubrics (Research >= 80, Plan >= 85, Tests pass)
- **Circuit breaker** that stops infinite loops after 3 consecutive failures
- **Persistent memory** via knowledge-core.md across sessions
- **Agent Teams** (experimental) for parallel multi-agent collaboration

---

## Architecture

### 25 Agents, 5 Tiers, 3 Models

| Tier | Agents | Model | Purpose |
|------|--------|-------|---------|
| **Orchestration** | chief-architect | Opus | Multi-domain coordination, agent selection |
| **Core (BUILD+FIX)** | docs-researcher, implementation-planner, brahma-analyzer, code-implementer, brahma-investigator | Opus + Sonnet | Research, plan, analyze, implement, debug |
| **Engineering** | software-architect, programmer, database-architect, api-designer, testing-engineer | Opus + Sonnet | Architecture, coding, databases, APIs, testing |
| **Infrastructure** | devops-engineer, secdevops-engineer, brahma-deployer, brahma-monitor, brahma-optimizer | Sonnet | CI/CD, security pipelines, deploy, monitor, optimize |
| **Growth & Quality** | seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer | Haiku + Sonnet | SEO, business, content, product, security, UX, responsive, themes, i18n |

### Model Distribution

| Model | Count | Rationale |
|-------|-------|-----------|
| **Opus 4.6** | 5 | Orchestration + deep reasoning + complex coding (chief-architect, code-implementer, brahma-investigator, software-architect, programmer) |
| **Sonnet 4.6** | 12 | Analysis + code generation + infrastructure (docs-researcher, implementation-planner, brahma-analyzer, brahma-deployer, brahma-monitor, brahma-optimizer, security-auditor, database-architect, api-designer, testing-engineer, devops-engineer, secdevops-engineer) |
| **Haiku 4.5** | 8 | Checklist + content + review tasks (seo-strategist, business-analyst, content-strategist, product-strategist, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer) |

### Core Workflow

```
Research (<2 min) -> Plan (<3 min) -> Analyze (<2 min) -> Implement (5-25 min)
   Score >= 80        Score >= 85       Score >= 80        Tests pass
```

Quality gates block advancement between phases. Circuit breaker opens after 3 consecutive implementation failures.

---

## Usage

### Universal Command (recommended)

```bash
/do add authentication to my API        # FEATURE -> full workflow
/do why is the login failing?            # DEBUG -> investigation
/do deploy v2.0                          # DEPLOY -> canary rollout
/do research Redis for Node.js           # RESEARCH -> docs fetch
/do review the payment module            # REVIEW -> multi-perspective
/do optimize database queries            # OPTIMIZE -> profiling
/do security audit on auth module        # SECURITY -> OWASP Top 10
/do design the user management API       # API -> contract-first design
/do review responsive layout             # RESPONSIVE -> mobile-first audit
/do check dark mode implementation       # THEME -> theme audit
```

`/do` auto-classifies into one of 33 routes and dispatches to the right agent.

### Full Automation

```bash
/workflow Add Redis caching to ProductService
```

Runs the complete pipeline: research -> plan -> analyze -> implement with quality gates.

### Step-by-Step

```bash
/research Redis for Node.js v5.0     # Fetch version-accurate docs
/plan Redis caching implementation    # Create minimal-change blueprint
/implement                            # Execute with TDD + self-correction
```

### Direct Agent Invocation

```bash
@chief-architect Build payment system
@docs-researcher Research Stripe API v14
@software-architect Design microservice architecture
@programmer Prototype the caching layer
@database-architect Review schema for user module
@api-designer Design REST API for orders
@testing-engineer Improve test coverage for auth
@devops-engineer Set up CI/CD pipeline
@secdevops-engineer Security audit on pipeline
@brahma-deployer Deploy v2.5.0
@security-auditor OWASP Top 10 audit
@ux-accessibility-reviewer WCAG 2.2 compliance
@responsive-reviewer Mobile layout audit
@theme-reviewer Dark mode implementation review
@i18n-reviewer Translation coverage check
@seo-strategist Technical SEO audit
@business-analyst Analyze onboarding process
@content-strategist Create launch content strategy
@product-strategist Evaluate market opportunity
```

### Agent Teams (experimental)

```bash
# /do auto-detects when parallel teammates would help
/do add Stripe payment integration   # proposes Agent Team (multi-layer)
/do fix auth bug                     # uses sub-agents (focused task)
/do add auth, simple                 # forces sequential mode
```

### Utility Commands

```bash
/circuit-breaker status              # Check if implementation is blocked
/circuit-breaker reset               # Reset after fixing issues
/context analyze                     # Check context health
/context optimize                    # Prune stale context
/mode token-efficiency               # Compact output mode
/mode introspection                  # Meta-cognitive analysis mode
/mode default                        # Restore standard behavior
```

### Thinking Modes

Add a keyword to any prompt for extended reasoning:

| Keyword | Duration | Use Case |
|---------|----------|----------|
| **think** | 30-60s | Standard analysis |
| **think hard** | 1-2 min | Complex debugging |
| **think harder** | 2-4 min | Architecture decisions |
| **ultrathink** | 5-10 min | Deep system analysis |

---

## Installation

### Requirements

- **Python 3** (or Python 2.7)
- **Git**
- **Claude Code CLI** v2.0.20+

### Supported Platforms

macOS, Linux, WSL, Windows (Git Bash, MSYS2, PowerShell)

### Install

```bash
git clone https://github.com/mariogonzalezsolas-maatimpact/claude-user-memory.git
cd claude-user-memory
python setup.py
```

`setup.py` provides an interactive menu:

| Option | Description |
|--------|-------------|
| Install | Full installation to `~/.claude/` |
| Update | Pull latest + update changed files only |
| Verify | Check installation health |
| Configure | Set up MCP servers |
| Uninstall | Remove (preserves knowledge data) |
| Diagnose | Troubleshoot common issues |
| Status | Show current installation info |

### Direct CLI Mode

```bash
python setup.py install        # Non-interactive install
python setup.py verify         # Check health
python setup.py status         # Show info
python setup.py diagnose       # Troubleshoot
```

### Manual Scripts

```bash
# Unix (macOS, Linux, WSL, Git Bash)
bash scripts/unix/install.sh          # Full install
bash scripts/unix/update.sh           # Update changed files
bash scripts/unix/customize.sh        # Configure MCP servers
bash scripts/unix/uninstall.sh        # Remove (preserves data)

# Windows (PowerShell)
powershell scripts/windows/install.ps1
powershell scripts/windows/verify-installation.ps1
```

### What Gets Installed

~92 managed files into `~/.claude/`:

| Directory | Files | Contents |
|-----------|-------|----------|
| `agents/` | 25 | Agent definitions (5 tiers) |
| `commands/` | 21 | Slash command definitions |
| `skills/` | 9 | Auto-invoked skills |
| `hooks/` | 12 | Lifecycle hooks |
| `templates/` | 13 | Shared templates and overviews |
| `validators/` | 2 | API matcher + circuit breaker |
| `metrics/` | 1 | Workflow metrics tracker |
| `data/` | 1 | MCP config template |
| `integrations/` | 4 | LangGraph templates |
| `rules/` | 1 | Path-specific rules |

Existing data, customizations, and knowledge files are preserved on upgrades.

---

## Quality Gates

| Transition | Gate | Threshold |
|------------|------|-----------|
| Research -> Plan | ResearchPack score | >= 80/100 |
| Plan -> Implement | Plan score | >= 85/100 |
| Analysis | Consistency score | >= 80/100 |
| Implementation | Tests + circuit breaker | All pass, breaker closed |

### Scoring Rubrics

**Research (80+ to pass):** Source authority (25), Version accuracy (20), API completeness (25), Code examples (15), Gotchas documented (15)

**Plan (85+ to pass):** Completeness (25), Minimal change (20), Rollback plan (20), API fidelity (20), Risk assessment (15)

### Circuit Breaker

Tracks consecutive implementation failures. Opens after 3 failures to prevent infinite retry loops.

- **CLOSED** (normal): Implementation proceeds
- **OPEN** (blocked): Must diagnose root cause, then `/circuit-breaker reset`

---

## Repository Structure

```
claude-user-memory/
├── .claude/                    # Core system (installed to ~/.claude/)
│   ├── agents/                 # 25 agent definitions
│   ├── commands/               # 22 slash commands
│   ├── skills/                 # 9 auto-invoked skills
│   ├── hooks/                  # 13 lifecycle hooks
│   ├── templates/              # Shared templates + overviews
│   ├── validators/             # Quality gate validators
│   ├── metrics/                # Workflow metrics tracker
│   ├── data/                   # MCP config template
│   ├── integrations/           # LangGraph integration templates
│   ├── rules/                  # Path-specific rules
│   ├── agent-teams.md          # Agent Teams guide
│   ├── knowledge-core.md       # Persistent pattern memory
│   └── settings.json           # Hook + permission configuration
├── scripts/
│   ├── unix/                   # install.sh, update.sh, customize.sh, uninstall.sh
│   ├── windows/                # install.ps1, verify-installation.ps1
│   ├── manifest.json           # File manifest for installations
│   └── manifest-template.json  # Template for packaging
├── docs/
│   ├── CHANGELOG.md            # Version history (v3.0 - v7.0)
│   ├── CONTRIBUTING.md         # Contributing guidelines
│   ├── INSTALLATION-BEHAVIOR.md # Installation details
│   ├── TROUBLESHOOTING.md      # Common issues + fixes
│   ├── PHILOSOPHY.md           # Design philosophy
│   ├── FRAMEWORK-COMPARISON.md # Comparison with alternatives
│   ├── research/               # Benchmarking research
│   ├── validation-reports/     # Quality validation reports
│   └── marketing/              # Launch materials
├── dev/                        # Development tools, archives, R&D
├── setup.py                    # Cross-platform installer (interactive menu)
├── CLAUDE.md                   # Project instructions
├── LICENSE                     # MIT
└── README.md                   # This file
```

---

## Key Features

- **Research-First Philosophy**: Never code from stale training data. Fetch version-accurate docs before every implementation.
- **TDD Mandatory**: RED -> GREEN -> REFACTOR cycle enforced by code-implementer.
- **Minimal Changes**: Every edit is surgical and reversible with documented rollback procedures.
- **Self-Correction**: Up to 3 intelligent retries before circuit breaker opens.
- **Pattern Learning**: Successful implementations are captured to knowledge-core.md with Bayesian confidence scoring.
- **Context Management**: Active context curation prevents context rot (39% improvement, 84% token reduction).
- **Cross-Platform**: Native support for macOS, Linux, WSL, Windows (Git Bash, MSYS2, PowerShell).
- **Agent Teams**: Experimental parallel collaboration with shared task lists and real-time coordination.

---

## Performance

Based on [Anthropic research](https://www.anthropic.com/research) (2024-2025):

| Metric | Improvement |
|--------|-------------|
| Complex task performance | +54% (Extended Thinking) |
| Research accuracy | +49-67% (Contextual Retrieval) |
| Multi-agent orchestration | +90.2% performance gain |
| Context optimization | +39% quality, -84% tokens |
| Feature implementation speed | 4.8-5.5x faster |
| Pattern reuse (5th+ similar feature) | 30-40% faster |

---

## Documentation

| Document | Description |
|----------|-------------|
| [Agents Overview](.claude/templates/agents-overview.md) | All 25 agents, tiers, models |
| [Workflows Overview](.claude/templates/workflows-overview.md) | Routing table, workflow patterns |
| [Skills Overview](.claude/templates/skills-overview.md) | 9 auto-invoked skills reference |
| [Quality Gates](.claude/templates/quality-gates.md) | Scoring rubrics, circuit breaker |
| [Agent Teams](.claude/agent-teams.md) | Parallel collaboration guide |
| [Changelog](docs/CHANGELOG.md) | Version history (v3.0 - v7.0) |
| [Installation Behavior](docs/INSTALLATION-BEHAVIOR.md) | Data preservation details |
| [Contributing](docs/CONTRIBUTING.md) | How to contribute |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Common issues and fixes |
| [Philosophy](docs/PHILOSOPHY.md) | Design principles |
| [Framework Comparison](docs/FRAMEWORK-COMPARISON.md) | Comparison with alternatives |

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| **7.0** | 2026-02-27 | 10 new agents (25 total), 5 tiers, 9 new commands (21 total), 4 new skills (9 total), Agent Report Protocol |
| **6.0** | 2026-02-24 | Agent Teams default on, v6.0 across all references, Opus 4.6 optimization |
| **5.4** | 2026-02-18 | SessionStart hook, `/mode` command, semantic quality gates |
| **5.3** | 2026-02-18 | `/review` command, massive context reduction (-81% to -84%) |
| **5.2** | 2026-02-18 | settings.json hooks, agent frontmatter (model, maxTurns, skills) |
| **5.1** | 2026-02-18 | Think protocol template, 3 audit commands, project memory |
| **5.0** | 2026-02-17 | Tier 4 launch: 6 Growth & Strategy agents (9 -> 15 total) |
| **3.1** | 2025-10-25 | Adaptive Learning, Bayesian confidence scoring |
| **3.0** | 2025-10-15 | Initial release (4 agents, 5 skills) |

---

## License

MIT License - See [LICENSE](LICENSE)

---

<a name="espanol"></a>

# Agentic Substrate v7.0 (Espanol)

**Sistema de desarrollo basado en investigacion para Claude Code CLI**

> 25 agentes. 22 comandos. 9 habilidades auto-invocadas. 13 hooks de ciclo de vida. Cero alucinaciones de APIs. Investigar primero, programar despues.

---

## Inicio Rapido

```bash
git clone https://github.com/mariogonzalezsolas-maatimpact/claude-user-memory.git
cd claude-user-memory
python setup.py
```

Luego en Claude Code:

```bash
/do agregar autenticacion a mi API
```

Eso es todo. `/do` clasifica tu intencion, muestra un plan, espera confirmacion y ejecuta.

---

## Que Es Esto

Una extension drop-in para [Claude Code CLI](https://docs.anthropic.com/en/docs/claude-code) que se instala en `~/.claude/` y lo transforma en un sistema de desarrollo basado en investigacion con:

- **25 agentes especializados** en 5 niveles (Orquestacion, Core, Ingenieria, Infraestructura, Crecimiento y Calidad)
- **9 habilidades auto-invocadas** (investigacion, planificacion, validacion, reconocimiento de patrones, gestion de contexto, arquitectura, API, testing, organizacion de proyecto)
- **22 comandos slash** (`/do`, `/workflow`, `/research`, `/plan`, `/implement`, `/review`, `/mode`, `/context`, `/circuit-breaker`, `/security-audit`, `/seo-audit`, `/ux-review`, `/responsive-review`, `/theme-review`, `/i18n-review`, `/architecture`, `/database`, `/api-design`, `/test-strategy`, `/devops`, `/secdevops`, `/tech-debt`)
- **13 hooks de ciclo de vida** (puertas de calidad, auto-formato, captura de conocimiento, gestion de sesion, vigilancia hawk)
- **Puertas de calidad** con rubricas de puntuacion (Investigacion >= 80, Plan >= 85, Tests pasan)
- **Circuit breaker** que detiene bucles infinitos despues de 3 fallos consecutivos
- **Memoria persistente** via knowledge-core.md entre sesiones
- **Agent Teams** (experimental) para colaboracion multi-agente en paralelo

---

## Arquitectura

### 25 Agentes, 5 Niveles, 3 Modelos

| Nivel | Agentes | Modelo | Proposito |
|-------|---------|--------|-----------|
| **Orquestacion** | chief-architect | Opus | Coordinacion multi-dominio |
| **Core (BUILD+FIX)** | docs-researcher, implementation-planner, brahma-analyzer, code-implementer, brahma-investigator | Opus + Sonnet | Investigar, planificar, analizar, implementar, depurar |
| **Ingenieria** | software-architect, programmer, database-architect, api-designer, testing-engineer | Opus + Sonnet | Arquitectura, codigo, bases de datos, APIs, testing |
| **Infraestructura** | devops-engineer, secdevops-engineer, brahma-deployer, brahma-monitor, brahma-optimizer | Sonnet | CI/CD, seguridad de pipelines, desplegar, monitorizar, optimizar |
| **Crecimiento y Calidad** | seo-strategist, business-analyst, content-strategist, product-strategist, security-auditor, ux-accessibility-reviewer, responsive-reviewer, theme-reviewer, i18n-reviewer | Haiku + Sonnet | SEO, negocio, contenido, producto, seguridad, UX, responsive, temas, i18n |

### Flujo de Trabajo Core

```
Investigar (<2 min) -> Planificar (<3 min) -> Analizar (<2 min) -> Implementar (5-25 min)
   Score >= 80          Score >= 85          Score >= 80          Tests pasan
```

---

## Uso

### Comando Universal (recomendado)

```bash
/do agregar autenticacion a mi API       # FEATURE -> workflow completo
/do por que falla el login?              # DEBUG -> investigacion
/do desplegar v2.0                       # DEPLOY -> despliegue canario
/do investigar Redis para Node.js        # RESEARCH -> buscar docs
/do revisar el modulo de pagos           # REVIEW -> multi-perspectiva
/do optimizar consultas de base de datos # OPTIMIZE -> profiling
/do auditoria de seguridad en auth       # SECURITY -> OWASP Top 10
/do disenar API de gestion de usuarios   # API -> diseno contract-first
/do revisar layout responsive            # RESPONSIVE -> auditoria mobile-first
/do verificar implementacion modo oscuro # THEME -> auditoria de tema
```

`/do` auto-clasifica en una de 33 rutas y despacha al agente correcto.

### Automatizacion Completa

```bash
/workflow Agregar cache Redis a ProductService
```

### Paso a Paso

```bash
/research Redis para Node.js v5.0
/plan Implementacion de cache Redis
/implement
```

### Agentes Directos

```bash
@chief-architect Construir sistema de pagos
@docs-researcher Investigar API de Stripe v14
@software-architect Disenar arquitectura de microservicios
@programmer Prototipar la capa de caching
@database-architect Revisar schema del modulo de usuarios
@api-designer Disenar API REST para pedidos
@testing-engineer Mejorar cobertura de tests en auth
@devops-engineer Configurar pipeline CI/CD
@secdevops-engineer Auditoria de seguridad en pipeline
@brahma-deployer Desplegar v2.5.0
@security-auditor Auditoria OWASP Top 10
@ux-accessibility-reviewer Auditoria WCAG 2.2
@responsive-reviewer Auditoria de layout movil
@theme-reviewer Revision de implementacion modo oscuro
@i18n-reviewer Verificar cobertura de traducciones
@seo-strategist Auditoria tecnica SEO
@business-analyst Analizar proceso de onboarding
@content-strategist Estrategia de contenidos para lanzamiento
@product-strategist Evaluar oportunidad de mercado
```

### Agent Teams (experimental)

```bash
/do agregar integracion de pagos Stripe   # propone Agent Team (multi-capa)
/do arreglar bug de auth                  # usa sub-agents (tarea focalizada)
/do agregar auth, simple                  # fuerza modo secuencial
```

### Modos de Pensamiento

Agrega una palabra clave para razonamiento extendido:

| Palabra Clave | Duracion | Caso de Uso |
|---------------|----------|-------------|
| **think** | 30-60s | Analisis estandar |
| **think hard** | 1-2 min | Depuracion compleja |
| **think harder** | 2-4 min | Decisiones de arquitectura |
| **ultrathink** | 5-10 min | Analisis profundo de sistemas |

---

## Instalacion

### Requisitos

- **Python 3** (o Python 2.7)
- **Git**
- **Claude Code CLI** v2.0.20+

### Plataformas Soportadas

macOS, Linux, WSL, Windows (Git Bash, MSYS2, PowerShell)

```bash
git clone https://github.com/mariogonzalezsolas-maatimpact/claude-user-memory.git
cd claude-user-memory
python setup.py
```

Se instala en `~/.claude/` (o `%USERPROFILE%\.claude` en Windows). Preserva datos existentes al actualizar.

### Scripts Manuales

```bash
# Unix
bash scripts/unix/install.sh          # Instalacion completa
bash scripts/unix/update.sh           # Actualizar solo archivos cambiados
bash scripts/unix/customize.sh        # Configurar servidores MCP
bash scripts/unix/uninstall.sh        # Desinstalar (preserva datos)

# Windows (PowerShell)
powershell scripts/windows/install.ps1
powershell scripts/windows/verify-installation.ps1
```

---

## Puertas de Calidad

| Transicion | Umbral |
|------------|--------|
| Investigacion -> Plan | Score >= 80/100 |
| Plan -> Implementacion | Score >= 85/100 |
| Analisis | Score >= 80/100 |
| Implementacion | Tests pasan, circuit breaker cerrado |

### Circuit Breaker

3 fallos consecutivos = STOP. Verificar: `/circuit-breaker status`. Resetear: `/circuit-breaker reset`.

---

## Caracteristicas Clave

- **Filosofia Research-First**: Nunca programar desde datos de entrenamiento obsoletos.
- **TDD Obligatorio**: Ciclo RED -> GREEN -> REFACTOR enforced.
- **Cambios Minimos**: Cada edicion es quirurgica y reversible.
- **Auto-Correccion**: Hasta 3 reintentos inteligentes.
- **Aprendizaje de Patrones**: Implementaciones exitosas capturadas con puntuacion Bayesiana.
- **Gestion de Contexto**: Prevencion de degradacion de contexto (39% mejora, 84% reduccion de tokens).
- **Multi-Plataforma**: macOS, Linux, WSL, Windows nativo.
- **Agent Teams**: Colaboracion paralela experimental con listas de tareas compartidas.

---

## Rendimiento

| Metrica | Mejora |
|---------|--------|
| Tareas complejas | +54% (Extended Thinking) |
| Precision de investigacion | +49-67% (Contextual Retrieval) |
| Orquestacion multi-agente | +90.2% rendimiento |
| Optimizacion de contexto | +39% calidad, -84% tokens |
| Velocidad de implementacion | 4.8-5.5x mas rapido |

---

## Documentacion

| Documento | Descripcion |
|-----------|-------------|
| [Agents Overview](.claude/templates/agents-overview.md) | 25 agentes, niveles, modelos |
| [Workflows Overview](.claude/templates/workflows-overview.md) | Tabla de rutas, patrones |
| [Skills Overview](.claude/templates/skills-overview.md) | 9 habilidades auto-invocadas |
| [Quality Gates](.claude/templates/quality-gates.md) | Rubricas, circuit breaker |
| [Agent Teams](.claude/agent-teams.md) | Guia de colaboracion paralela |
| [Changelog](docs/CHANGELOG.md) | Historial de versiones (v3.0 - v7.0) |
| [Troubleshooting](docs/TROUBLESHOOTING.md) | Problemas comunes |

---

## Historial de Versiones

| Version | Fecha | Destacado |
|---------|-------|-----------|
| **7.0** | 2026-02-27 | 10 nuevos agentes (25 total), 5 niveles, 9 nuevos comandos (21 total), 4 nuevas habilidades (9 total), Agent Report Protocol |
| **6.0** | 2026-02-24 | Agent Teams por defecto, optimizacion Opus 4.6 |
| **5.4** | 2026-02-18 | Hook SessionStart, comando `/mode`, quality gates semanticas |
| **5.3** | 2026-02-18 | Comando `/review`, reduccion de contexto (-84%) |
| **5.0** | 2026-02-17 | Nivel 4: 6 agentes de Crecimiento y Estrategia |
| **3.0** | 2025-10-15 | Lanzamiento inicial (4 agentes, 5 habilidades) |

---

## Licencia

MIT License - Ver [LICENSE](LICENSE)

---

**Version:** 7.0.0 | **Fecha:** 2026-02-27 | **Agentes:** 25 (5 Opus + 12 Sonnet + 8 Haiku) | **Comandos:** 21 | **Skills:** 9 | **Hooks:** 12
