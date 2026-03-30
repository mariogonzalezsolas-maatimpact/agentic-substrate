---
name: generate-docs
description: Genera la estructura de documentacion .claude/ para cualquier proyecto. Entrevista agentica, generacion en espanol, y migracion automatica de estructuras existentes.
---

# /generate-docs Command

Genera o migra la estructura `.claude/` estandar para que la IA pueda trabajar eficazmente en tu proyecto. Todo el contenido generado esta en **espanol**.

## Uso

```
/generate-docs
```

## Flujo: DETECTAR -> ENTREVISTAR -> GENERAR/MIGRAR -> VERIFICAR

### Paso 1: Deteccion Automatica

1. Comprobar si existe `.claude/` en el directorio actual
2. Comprobar si existe `CLAUDE.md` en la raiz del proyecto
3. Clasificar estado:
   - **NUEVO**: No existe `.claude/` ni `CLAUDE.md` -> generacion completa
   - **PARCIAL**: Existe `CLAUDE.md` pero no `.claude/` (o viceversa) -> completar
   - **MIGRAR**: Existe `.claude/` con estructura no estandar -> migrar
   - **COMPLETO**: Estructura estandar ya presente -> reportar, sugerir mejoras

### Paso 2: Entrevista Agentica (Obligatoria)

Antes de generar, preguntar al usuario sobre su proyecto. Usar preguntas multi-opcion con opciones concretas.

**Bloque 1 -- Proyecto**
1. Cual es el stack tecnologico?
   - a) Next.js / React
   - b) Python / Django / FastAPI
   - c) Node.js / Express
   - d) Go
   - e) Otro: ___
2. Que tipo de proyecto es?
   - a) Web app (frontend + backend)
   - b) API / backend puro
   - c) CLI / herramienta
   - d) Libreria / paquete
   - e) Monorepo
3. Cuantas personas trabajan en el proyecto?
   - a) Solo yo
   - b) 2-5 personas
   - c) 6-15 personas
   - d) 15+

**Bloque 2 -- Desarrollo**
4. Framework de testing?
   - a) Jest / Vitest
   - b) pytest
   - c) Go testing
   - d) No tenemos tests
   - e) Otro: ___
5. Como despliegan?
   - a) Vercel / Netlify
   - b) AWS (EC2/ECS/Lambda)
   - c) Docker + servidor propio
   - d) Manual (SSH/FTP)
   - e) No desplegamos todavia
6. CI/CD configurado?
   - a) GitHub Actions
   - b) GitLab CI
   - c) Jenkins / CircleCI / otro
   - d) No tenemos CI/CD

**Bloque 3 -- Preferencias IA**
7. Que tareas hace la IA mas frecuentemente en tu proyecto?
   - a) Nuevas features
   - b) Debug / investigar errores
   - c) Code review
   - d) Refactoring
   - e) Todo lo anterior
8. Hay convenciones estrictas de codigo?
   - a) Si, tenemos linter + guia de estilo
   - b) Algunas convenciones informales
   - c) No, cada quien a su manera
9. Archivos que la IA NUNCA debe tocar?
   - a) Si (especificar cuales)
   - b) No, puede tocar todo

### Paso 3: Generar Estructura

Segun las respuestas, crear la siguiente estructura adaptada:

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

#### Adaptar contenido segun respuestas:
- **Stack** -> comandos y reglas relevantes al framework detectado
- **Testing** -> regla de pruebas adaptada al framework
- **Deploy** -> comando de despliegue adaptado al metodo
- **Preferencias IA** -> comandos priorizados segun uso frecuente
- **Archivos protegidos** -> incluidos en settings.json y mencionados en CLAUDE.md

#### Templates de Contenido

**CLAUDE.md** debe incluir:
```markdown
# [Nombre del Proyecto]

## Donde Encontrar Que

| Que | Donde |
|-----|-------|
| [Componentes/modulos principales] | `src/...` |
| [Logica de negocio] | `src/services/` |
| [Tests] | `tests/` o `__tests__/` |
| [Configuracion] | Archivos raiz |

## Comandos de Desarrollo

| Comando | Descripcion |
|---------|-------------|
| `[cmd dev]` | Servidor de desarrollo |
| `[cmd build]` | Build de produccion |
| `[cmd test]` | Ejecutar tests |

## Convenciones
[Adaptadas segun entrevista]

## Archivos Protegidos
[Si los hay, segun entrevista]
```

**commands/revision.md**:
```markdown
---
name: revision
description: Revisa el codigo del ultimo cambio o de los archivos indicados.
---
Revisa el codigo buscando:
1. Errores logicos y bugs potenciales
2. Problemas de seguridad
3. Oportunidades de mejora de rendimiento
4. Adherencia a las convenciones del proyecto (ver CLAUDE.md)

Formato: lista priorizada con severidad (critico/alto/medio/bajo).
```

**commands/fix-issue.md**:
```markdown
---
name: fix-issue
description: Investiga y corrige un bug o issue reportado.
---
1. Analizar el issue/error reportado
2. Investigar la causa raiz
3. Proponer solucion minima y reversible
4. Implementar con test de regresion
5. Verificar que no rompe funcionalidad existente
```

**commands/desplegar.md**:
```markdown
---
name: desplegar
description: Ejecuta el proceso de despliegue del proyecto.
---
Antes de desplegar:
- [ ] Tests pasando
- [ ] Build exitoso
- [ ] Sin cambios sin commitear

Proceso:
1. Ejecutar build de produccion
2. Verificar artefactos
3. [Metodo de despliegue segun proyecto]
```

**rules/estilo-de-codigo.md** (adaptar segun stack):
```markdown
# Estilo de Codigo
## Nombrado
- Archivos: [segun stack]
- Funciones: [segun stack]
- Componentes: [segun stack]
## Formato
- Indentacion: [segun proyecto]
- Punto y coma: [segun proyecto]
## Patrones
- [Patrones relevantes al stack]
```

**rules/pruebas.md** (adaptar segun testing framework):
```markdown
# Convenciones de Testing
## Framework: [detectado]
## Estructura
- Tests unitarios: [ubicacion]
- Tests de integracion: [ubicacion]
## Reglas
- Todo codigo nuevo debe incluir tests
- No mockear el sistema bajo prueba
- Mocks solo para dependencias externas
```

**rules/convenciones-api.md** (solo si proyecto tiene API):
```markdown
# Convenciones de API
## Formato de Respuesta
- Exito: `{ data: ... }`
- Error: `{ error: { code: "...", message: "..." } }`
## Endpoints
- Recursos en plural
- Verbos HTTP estandar
## Validacion
- Validar inputs en el controlador
```

### Paso 4: Migracion Automatica (si `.claude/` ya existe)

1. **Inventario**: Listar todos los archivos bajo `.claude/`
2. **Clasificar cada archivo**:
   - Estandar (ubicacion correcta) -> no tocar
   - Mal ubicado -> mover automaticamente
   - Desconocido -> mover a `.claude/legacy/`
   - Faltante -> generar
3. **NUNCA borrar archivos**. Solo mover.
4. **Actualizar referencias**: Escanear CLAUDE.md para rutas afectadas
5. **Reportar**: Tabla de cambios (archivo, accion, destino)

### Paso 5: Verificacion Post-Generacion

- [ ] CLAUDE.md existe con tabla "Donde Encontrar Que"
- [ ] CLAUDE.local.md creado y en .gitignore
- [ ] .claude/settings.json existe
- [ ] Al menos 1 comando en .claude/commands/
- [ ] Al menos 1 regla en .claude/rules/
- [ ] .gitignore actualizado (CLAUDE.local.md, .claude/settings.local.json, .claude/settings.json)
- [ ] Resumen mostrado al usuario

## Idioma

Todo en **espanol**. Excepciones: claves JSON, terminos tecnicos (git, CI/CD, API), extensiones.

## Integracion

- Se activa con el skill `generate-docs` (auto-invoke)
- Compatible con `/do genera documentacion`
- Funciona en CUALQUIER proyecto
