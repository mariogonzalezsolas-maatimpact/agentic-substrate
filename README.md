# Agentic Substrate v5.4

**Research-first development system for Claude Code CLI - Optimized for Claude Opus 4.6**

> 15 agents across 4 tiers. No API hallucinations. No coding from stale training data. Research -> Plan -> Implement -> Grow.

[English](#english) | [Espanol](#espanol)

---

<a name="english"></a>
## Quick Start

### 1. Clone

```bash
git clone <this-repo-url>
cd claude-user-memory
```

### 2. Install

```bash
./install.sh          # macOS / Linux / WSL / Git Bash
.\install.ps1         # Windows PowerShell
```

### Use

```bash
# Universal command - just say what you want
/do add authentication to my API

# Or use specific workflows
/workflow Add Redis caching to ProductService
```

---

## What You Get

- **15 Agents** across 4 tiers:
  - **BUILD+FIX** - Research, planning, analysis, implementation, debugging
  - **SERVE** - Deployment, monitoring, optimization
  - **GROW** - SEO, business analysis, content marketing, product strategy, security, UX/accessibility
- **5 Skills** - Auto-invoked capabilities for research, planning, validation, patterns, context
- **12 Commands** - `/do`, `/workflow`, `/research`, `/plan`, `/implement`, `/review`, `/mode`, `/context`, `/circuit-breaker`, `/security-audit`, `/seo-audit`, `/ux-review`
- **Quality Gates** - Research >= 80, Plans >= 85, Tests passing, 3-retry circuit breaker
- **Memory** - Knowledge graph persists across sessions
- **Opus 4.6 + Sonnet 4.6** - 3 critical agents use Opus 4.6, 12 use Sonnet 4.6

---

## Usage

**Universal command (recommended):**
```bash
/do add authentication to my API
/do why is this function slow?
/do deploy to production
```

**Full automation:**
```bash
/workflow Add authentication with JWT tokens
```

**Step-by-step:**
```bash
/research Redis for Node.js v5.0
/plan Redis caching implementation
/implement
```

**Direct agents:**
```bash
@chief-architect Build payment system
@docs-researcher Research Stripe API
@brahma-deployer Deploy v2.5.0

# Growth & Strategy agents
@seo-strategist Audit SEO and create optimization roadmap
@business-analyst Analyze customer onboarding process
@content-strategist Create content strategy for launch
@product-strategist Evaluate market opportunity
@security-auditor OWASP Top 10 security audit
@ux-accessibility-reviewer WCAG 2.2 compliance audit
```

**Agent Teams (experimental):**
```bash
# /do automatically detects when parallel teammates would help
# Just use /do normally -- it will propose a team when beneficial
/do add Stripe payment integration   # proposes Agent Team (multi-layer)
/do fix auth bug                     # uses sub-agents (focused task)
```

**Circuit breaker management:**
```bash
/circuit-breaker status    # Check if blocked
/circuit-breaker reset     # Reset after fixing issues
```

---

## How It Works

1. **Research** (< 2 min) - Fetch version-accurate docs before coding
2. **Plan** (< 3 min) - Create minimal-change blueprint with rollback
3. **Implement** (< 10 min) - Execute with TDD + self-correction
4. **Learn** - Auto-capture patterns to knowledge graph

Quality gates block bad inputs. Circuit breaker stops infinite loops.

---

## Installation

### Platform Support

| Platform | Script | Status |
|----------|--------|--------|
| macOS | `./install.sh` | Full support |
| Linux | `./install.sh` | Full support |
| WSL | `./install.sh` | Full support |
| Windows (Git Bash) | `./install.sh` | Full support |
| Windows (MSYS2) | `./install.sh` | Full support |
| Windows (PowerShell) | `.\install.ps1` | Full support |
| Windows (cmd) | N/A | Use PowerShell |

### Requirements

**Minimal:** bash and git only (for install.sh) or PowerShell 5.1+ (for install.ps1)

**Optional:** python3/python for enhanced JSON handling

### What Gets Installed

**Location:** `~/.claude/` (or `%USERPROFILE%\.claude` on Windows)

**Preserves:**
- All data in `~/.claude/data/`
- Your `CLAUDE.md` customizations (smart-merged)
- Modified files (detected by checksum)
- Knowledge files and patterns

### Upgrade

```bash
./install.sh          # bash
.\install.ps1         # PowerShell
```

Your data and customizations are automatically preserved.

### Selective Update

```bash
./update.sh    # Only update changed files
```

---

## Configuration

```bash
./customize.sh                              # Interactive menu
./customize.sh --enable-mcp memory          # Enable MCP servers
./customize.sh --list-mcps                  # View configuration
```

---

## Uninstall

```bash
./uninstall.sh --dry-run    # Preview what will be removed
./uninstall.sh              # Remove (preserves data)
```

---

## Documentation

- [Agents Overview](.claude/templates/agents-overview.md) - All 15 agents across 4 tiers
- [Skills Overview](.claude/templates/skills-overview.md) - Auto-invoked capabilities
- [Workflows Overview](.claude/templates/workflows-overview.md) - Development + Growth patterns
- [Installation Behavior](INSTALLATION-BEHAVIOR.md) - Data preservation details
- [Changelog](CHANGELOG.md) - Complete version history
- [Legacy Release Notes](archive/v4-artifacts/RELEASE-NOTES-V4.md) - v4.0/4.1 features

---

## Research Foundation

Built on Anthropic research (2024-2025):
- Extended Thinking: 54% improvement on complex tasks
- Multi-Agent Orchestration: 90.2% performance improvement
- Contextual Retrieval: 49-67% better accuracy

---

## Features

- **Native Windows Support** - Works with Git Bash, MSYS2, and PowerShell
- **PowerShell Installer** - `install.ps1` for Windows users without bash
- **Path Conversion** - Automatic Unix-to-Windows path conversion for Python
- **Dynamic Python Detection** - Works with `python3` or `python`
- **Bilingual Documentation** - English and Spanish

---

## License

MIT License - See [LICENSE](LICENSE)

---

<a name="espanol"></a>
# Agentic Substrate v5.4 (Espanol)

**Sistema de desarrollo basado en investigacion para Claude Code CLI - Optimizado para Claude Opus 4.6**

> 15 agentes en 4 niveles. Sin alucinaciones de APIs. Sin codigo basado en datos de entrenamiento obsoletos. Investigar -> Planificar -> Implementar -> Crecer.

---

## Inicio Rapido

### 1. Clonar

```bash
git clone <url-de-este-repo>
cd claude-user-memory
```

### 2. Instalar

```bash
./install.sh          # macOS / Linux / WSL / Git Bash
.\install.ps1         # Windows PowerShell
```

### Uso

```bash
# Comando universal - solo di lo que quieres
/do agregar autenticacion a mi API

# O usa workflows especificos
/workflow Agregar cache Redis a ProductService
```

---

## Que Incluye

- **15 Agentes** en 4 niveles:
  - **BUILD+FIX** - Investigacion, planificacion, analisis, implementacion, depuracion
  - **SERVE** - Despliegue, monitorizacion, optimizacion
  - **GROW** - SEO, analisis de negocio, marketing de contenidos, estrategia de producto, seguridad, UX/accesibilidad
- **5 Habilidades** - Capacidades auto-invocadas para investigacion, planificacion, validacion, patrones, contexto
- **12 Comandos** - `/do`, `/workflow`, `/research`, `/plan`, `/implement`, `/review`, `/mode`, `/context`, `/circuit-breaker`, `/security-audit`, `/seo-audit`, `/ux-review`
- **Puertas de Calidad** - Investigacion >= 80, Planes >= 85, Tests pasando, circuit breaker de 3 reintentos
- **Memoria** - Grafo de conocimiento persistente entre sesiones
- **Opus 4.6 + Sonnet 4.6** - 3 agentes criticos usan Opus 4.6, 12 usan Sonnet 4.6

---

## Uso

**Comando universal (recomendado):**
```bash
/do agregar autenticacion a mi API
/do por que esta funcion es lenta?
/do desplegar a produccion
```

**Automatizacion completa:**
```bash
/workflow Agregar autenticacion con tokens JWT
```

**Paso a paso:**
```bash
/research Redis para Node.js v5.0
/plan Implementacion de cache Redis
/implement
```

**Agentes directos:**
```bash
@chief-architect Construir sistema de pagos
@docs-researcher Investigar API de Stripe
@brahma-deployer Desplegar v2.5.0

# Agentes de Crecimiento y Estrategia
@seo-strategist Auditar SEO y crear plan de optimizacion
@business-analyst Analizar proceso de onboarding de clientes
@content-strategist Crear estrategia de contenidos para lanzamiento
@product-strategist Evaluar oportunidad de mercado
@security-auditor Auditoria de seguridad OWASP Top 10
@ux-accessibility-reviewer Auditoria de accesibilidad WCAG 2.2
```

**Agent Teams (experimental):**
```bash
# /do detecta automaticamente cuando companeros paralelos serian utiles
# Solo usa /do normalmente -- propondra un equipo cuando sea beneficioso
/do agregar integracion de pagos Stripe   # propone Agent Team (multi-capa)
/do arreglar bug de autenticacion         # usa sub-agents (tarea focalizada)
```

**Gestion del circuit breaker:**
```bash
/circuit-breaker status    # Ver si esta bloqueado
/circuit-breaker reset     # Resetear despues de corregir problemas
```

---

## Como Funciona

1. **Investigar** (< 2 min) - Obtener documentacion actualizada antes de programar
2. **Planificar** (< 3 min) - Crear plan de cambios minimos con rollback
3. **Implementar** (< 10 min) - Ejecutar con TDD + auto-correccion
4. **Aprender** - Capturar patrones automaticamente al grafo de conocimiento

Las puertas de calidad bloquean entradas incorrectas. El circuit breaker detiene bucles infinitos.

---

## Instalacion

### Soporte de Plataformas

| Plataforma | Script | Estado |
|------------|--------|--------|
| macOS | `./install.sh` | Soporte completo |
| Linux | `./install.sh` | Soporte completo |
| WSL | `./install.sh` | Soporte completo |
| Windows (Git Bash) | `./install.sh` | Soporte completo |
| Windows (MSYS2) | `./install.sh` | Soporte completo |
| Windows (PowerShell) | `.\install.ps1` | Soporte completo |
| Windows (cmd) | N/A | Usar PowerShell |

### Requisitos

**Minimos:** solo bash y git (para install.sh) o PowerShell 5.1+ (para install.ps1)

**Opcional:** python3/python para manejo mejorado de JSON

### Que Se Instala

**Ubicacion:** `~/.claude/` (o `%USERPROFILE%\.claude` en Windows)

**Preserva:**
- Todos los datos en `~/.claude/data/`
- Tus personalizaciones de `CLAUDE.md` (fusion inteligente)
- Archivos modificados (detectados por checksum)
- Archivos de conocimiento y patrones

### Actualizar

```bash
./install.sh          # bash
.\install.ps1         # PowerShell
```

Tus datos y personalizaciones se preservan automaticamente.

---

## Caracteristicas

- **Soporte Nativo de Windows** - Funciona con Git Bash, MSYS2 y PowerShell
- **Instalador PowerShell** - `install.ps1` para usuarios de Windows sin bash
- **Conversion de Rutas** - Conversion automatica de rutas Unix a Windows para Python
- **Deteccion Dinamica de Python** - Funciona con `python3` o `python`
- **Documentacion Bilingue** - Ingles y Espanol

---

**Version:** 5.4.0
**Lanzamiento:** Febrero 18, 2026
**Estado:** Listo para Produccion

*Investigar -> Planificar -> Implementar -> Aprender*
