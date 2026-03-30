---
paths: ["**/*.py", "requirements.txt", "pyproject.toml", "setup.py", "setup.cfg", "Pipfile"]
---
# Python Rules

## Style
- Follow **PEP 8** conventions
- **Type annotations** on all function signatures
- Tools: **black** (formatting), **isort** (imports), **ruff** (linting)

## Data Structures
- Use `@dataclass(frozen=True)` for immutable structured data
- Use `NamedTuple` as alternative for simple immutable types

## Patterns
- **Protocol** (duck typing): Define interfaces with `typing.Protocol`
- **Dataclasses as DTOs**: Use `@dataclass` for request/response objects
- **Context Managers**: Use `with` for resource management
- **Generators**: Use for lazy evaluation and memory-efficient iteration

## Testing
- Framework: **pytest**
- Use `pytest.mark` for test categorization (`@pytest.mark.unit`, `@pytest.mark.integration`)
- Coverage: `pytest --cov=src --cov-report=term-missing`
- Target: 80%+ coverage

Adapted from affaan-m/everything-claude-code Python rules.
