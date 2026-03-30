---
paths: ["**/*.go", "go.mod", "go.sum"]
---
# Go Rules

## Style
- **gofmt** and **goimports** are mandatory
- Accept interfaces, return structs
- Keep interfaces small (1-3 methods)

## Error Handling
Always wrap errors with context:
```go
if err != nil {
    return fmt.Errorf("failed to create user: %w", err)
}
```

## Patterns
- **Functional Options**: `type Option func(*Server)` for configurable constructors
- **Small Interfaces**: Define where used, not where implemented
- **Dependency Injection**: Constructor functions inject dependencies

## Testing
- Framework: standard `go test` with **table-driven tests**
- Race detection: ALWAYS run with `-race` flag: `go test -race ./...`
- Coverage: `go test -cover ./...`
- Target: 80%+ coverage

Adapted from affaan-m/everything-claude-code Go rules.
