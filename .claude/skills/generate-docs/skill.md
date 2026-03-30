---
name: generate-docs
description: "Genera o migra la estructura .claude/ para cualquier proyecto. Se activa cuando el usuario pide configurar Claude para su proyecto, generar documentacion IA, o setup .claude."
auto_invoke: true
tags: [documentation, generation, migration, spanish, setup, claude]
---

# Generate Docs Skill

Genera la estructura de documentacion `.claude/` estandar para cualquier proyecto, adaptada mediante entrevista agentica. Todo el contenido en espanol.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when the user says:
- "genera documentacion para la IA" / "genera docs para claude"
- "configura claude para este proyecto" / "configurar .claude"
- "setup .claude" / "crear estructura .claude"
- "preparar proyecto para IA" / "inicializar claude"
- "documentacion para la inteligencia artificial"
- "/generate-docs"

**Do NOT invoke when:**
- User is editing existing .claude files (not creating structure)
- User is working within the Agentic Substrate source repo itself
- User says "organize" without mentioning .claude or AI docs (use project-organization instead)
- User is asking about what .claude is or how it works (just explain)

## Estructura Estandar Objetivo

Esta es la estructura EXACTA que el skill debe crear. Todos los directorios y archivos base deben existir al finalizar:

```
tu-proyecto/
├── CLAUDE.md                    <- instrucciones de equipo, confirmadas por git
├── CLAUDE.local.md              <- anotaciones personales, ignoradas por git
├── .claude/
│   ├── settings.json            <- permisos + configuracion, confirmados
│   ├── settings.local.json      <- permisos personales, ignorados por git
│   ├── commands/                <- comandos slash personalizados
│   │   └── (project-specific commands)
│   ├── rules/                   <- archivos de instrucciones modulares
│   │   └── (coding standards, conventions, etc.)
│   ├── skills/                  <- flujos de trabajo invocados automaticamente
│   │   └── skill-name/
│   │       └── skill.md
│   └── agents/                  <- personas subagentes
│       └── (project-specific agents)
```

## Protocolo de Ejecucion

### Fase 1: Deteccion del Estado

1. `Glob .claude/**/*` para inventariar estructura existente
2. `Glob CLAUDE.md` y `Glob CLAUDE.local.md` en la raiz
3. Verificar existencia de cada directorio: `commands/`, `rules/`, `skills/`, `agents/`
4. Verificar existencia de cada archivo base: `settings.json`, `settings.local.json`
5. Comprobar `.gitignore` por las entradas requeridas
6. Clasificar:
   - **NUEVO**: No existe `.claude/` ni `CLAUDE.md` -> generacion completa
   - **PARCIAL**: Solo parte de la estructura existe -> completar lo que falta
   - **MIGRAR**: `.claude/` existe pero no sigue la estructura estandar -> migrar
   - **COMPLETO**: Estructura estandar presente -> reportar, sugerir mejoras

### Fase 2: Entrevista Agentica

Presentar 3 bloques de preguntas multi-opcion en espanol. Ver `/generate-docs` command para la lista completa de preguntas.

Mapear respuestas a templates:
- Stack -> que comandos/reglas generar
- Tipo de proyecto -> estructura de tabla de navegacion en CLAUDE.md
- Testing -> contenido de pruebas.md
- Deploy -> contenido de desplegar.md
- Tamano equipo -> reglas de colaboracion
- Tareas IA -> prioridad de comandos
- Convenciones -> contenido de estilo-de-codigo.md
- Archivos protegidos -> deny list en settings.json + warning en CLAUDE.md

### Fase 3: Creacion de Estructura

Ejecutar en este orden estricto. **NUNCA sobrescribir archivos existentes.**

#### Paso 3.1: Crear directorios

Crear todos los directorios que no existan:

```bash
mkdir -p .claude/commands
mkdir -p .claude/rules
mkdir -p .claude/skills
mkdir -p .claude/agents
```

#### Paso 3.2: Crear archivos base

Para cada archivo, verificar si existe ANTES de crear. Si existe, NO sobrescribir.

**CLAUDE.md** -- Solo si no existe. Debe ser LEAN (40-60 lineas max):

```markdown
# [Nombre del Proyecto]

[Descripcion de 1-2 lineas detectada de package.json, pyproject.toml, go.mod, o entrevista]

## Stack

- **Lenguaje**: [detectado]
- **Framework**: [detectado]
- **Testing**: [detectado]
- **Deploy**: [detectado]

## Donde Encontrar Que

| Que | Donde |
|-----|-------|
| [Codigo principal] | `src/` |
| [Tests] | `tests/` o `__tests__/` |
| [Configuracion] | Archivos raiz |
| [Reglas IA] | `.claude/rules/` |
| [Comandos IA] | `.claude/commands/` |

## Comandos de Desarrollo

| Comando | Descripcion |
|---------|-------------|
| `[cmd dev]` | Servidor de desarrollo |
| `[cmd build]` | Build de produccion |
| `[cmd test]` | Ejecutar tests |
| `[cmd lint]` | Linter |

## Convenciones

- [Convenciones adaptadas segun entrevista -- max 5-7 bullets]

## Archivos Protegidos

[Si los hay segun entrevista, listar. Si no, omitir seccion.]

## Estructura .claude/

| Directorio | Contenido |
|------------|-----------|
| `.claude/commands/` | Comandos slash del proyecto |
| `.claude/rules/` | Reglas de codigo y convenciones |
| `.claude/skills/` | Flujos automaticos |
| `.claude/agents/` | Subagentes especializados |
```

**CLAUDE.local.md** -- Solo si no existe:

```markdown
# Notas Personales

Este archivo es para tus anotaciones personales. Esta ignorado por git.

## Notas

[Escribe aqui tus notas personales sobre el proyecto]
```

**.claude/settings.json** -- Solo si no existe:

```json
{
  "permissions": {
    "allow": [
      "Read",
      "Write",
      "Edit",
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(git *)",
      "Glob",
      "Grep"
    ],
    "deny": [
      "Bash(rm -rf *)",
      "Bash(git push --force *)"
    ]
  }
}
```

Adaptar `allow` segun stack detectado:
- Python: `Bash(python *), Bash(pip *), Bash(pytest *)`
- Go: `Bash(go *)`
- Node: `Bash(npm run *), Bash(npx *)`
- Incluir archivos protegidos de la entrevista en `deny`

**.claude/settings.local.json** -- Solo si no existe:

```json
{
  "permissions": {
    "allow": [],
    "deny": []
  }
}
```

#### Paso 3.3: Crear contenido adaptado

Segun las respuestas de la entrevista, crear:

- **Al menos 1 comando** en `.claude/commands/` (revision.md como minimo)
- **Al menos 1 regla** en `.claude/rules/` (estilo-de-codigo.md como minimo)
- Contenido adaptado al stack, NO generico

Ver `/generate-docs` command para templates detallados de cada archivo.

#### Paso 3.4: Actualizar .gitignore

Verificar y agregar estas entradas si no existen:

```
CLAUDE.local.md
.claude/settings.local.json
.claude/settings.json
```

Usar `Grep` para verificar si cada linea ya existe antes de agregar.

### Fase 4: Migracion (cuando `.claude/` ya existe parcialmente)

Protocolo de migracion -- **NUNCA sobrescribir, NUNCA borrar**:

1. **Inventariar** todos los archivos existentes bajo `.claude/`
2. **Clasificar** cada archivo:
   - **Estandar** (ubicacion correcta) -> preservar, no tocar
   - **Mal ubicado** -> mover automaticamente a ubicacion correcta
   - **Desconocido** -> mover a `.claude/legacy/`
   - **Faltante** -> crear con contenido adaptado
3. **Crear** solo lo que falta (directorios y archivos base)
4. **Actualizar** referencias en CLAUDE.md si se movieron archivos
5. **Reportar** tabla de cambios al usuario

### Fase 5: Post-Generacion

#### 5.1: Verificacion

Verificar que TODA la estructura existe:

- [ ] `CLAUDE.md` existe con tabla "Donde Encontrar Que"
- [ ] `CLAUDE.local.md` existe
- [ ] `.claude/` directorio existe
- [ ] `.claude/settings.json` existe
- [ ] `.claude/settings.local.json` existe
- [ ] `.claude/commands/` directorio existe con al menos 1 comando
- [ ] `.claude/rules/` directorio existe con al menos 1 regla
- [ ] `.claude/skills/` directorio existe
- [ ] `.claude/agents/` directorio existe
- [ ] `.gitignore` tiene: `CLAUDE.local.md`, `.claude/settings.local.json`, `.claude/settings.json`

#### 5.2: Reporte al Usuario

Mostrar SIEMPRE el diagrama ASCII de la estructura creada, con indicadores de estado:

```
tu-proyecto/
├── CLAUDE.md                    [CREADO | PRESERVADO | ACTUALIZADO]
├── CLAUDE.local.md              [CREADO | PRESERVADO] (gitignored)
├── .claude/
│   ├── settings.json            [CREADO | PRESERVADO] (gitignored)
│   ├── settings.local.json      [CREADO | PRESERVADO] (gitignored)
│   ├── commands/
│   │   ├── revision.md          [CREADO | PRESERVADO]
│   │   ├── fix-issue.md         [CREADO | PRESERVADO]
│   │   └── desplegar.md         [CREADO | PRESERVADO]
│   ├── rules/
│   │   ├── estilo-de-codigo.md  [CREADO | PRESERVADO]
│   │   └── pruebas.md           [CREADO | PRESERVADO]
│   ├── skills/                  [CREADO | PRESERVADO]
│   └── agents/                  [CREADO | PRESERVADO]
```

Incluir tabla resumen:

| Accion | Cantidad |
|--------|----------|
| Archivos creados | N |
| Archivos preservados | N |
| Archivos movidos | N |
| Directorios creados | N |

#### 5.3: Siguiente paso sugerido

Sugerir al usuario:
- "Revisa CLAUDE.md y ajusta las convenciones a tu gusto"
- "Anade reglas adicionales en `.claude/rules/` para tu stack"
- "Crea comandos custom en `.claude/commands/` para tus flujos"

## Reglas Criticas

1. **NUNCA sobrescribir archivos existentes** -- crear solo lo que falta
2. **NUNCA borrar archivos** -- en migracion, mover a `.claude/legacy/`
3. **CLAUDE.md debe ser LEAN** -- 40-60 lineas, sin @import bloat
4. **Contenido adaptado** -- cada archivo refleja el stack y preferencias del usuario
5. **Diagrama ASCII obligatorio** -- siempre mostrar la estructura al usuario
6. **Verificacion antes de reportar** -- comprobar que cada archivo/directorio existe

## Calidad

- [ ] Estructura completa creada (9 items base verificados)
- [ ] CLAUDE.md tiene tabla "Donde Encontrar Que" y es lean (40-60 lineas)
- [ ] Contenido adaptado a respuestas (no generico)
- [ ] .gitignore actualizado con las 3 entradas
- [ ] Si migracion: ningun archivo borrado, todos movidos
- [ ] Diagrama ASCII mostrado al usuario con estados
- [ ] Tabla resumen de acciones mostrada

## Idioma

Todo en **espanol**. Excepciones: claves JSON, terminos tecnicos (git, CI/CD, API), extensiones, nombres de archivos estandar (CLAUDE.md, settings.json).
