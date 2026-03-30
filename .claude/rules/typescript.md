---
paths: ["**/*.ts", "**/*.tsx", "**/*.js", "**/*.jsx", "tsconfig.json", "package.json"]
---
# TypeScript / JavaScript Rules

## Types
- Add explicit types to exported functions, public APIs, and component props
- Let TypeScript infer local variable types
- Use `unknown` over `any` for external/untrusted input, then narrow safely
- Use `interface` for object shapes, `type` for unions/intersections/utilities
- Prefer string literal unions over `enum`
- Do NOT use `React.FC` -- define props separately

## Validation
- Use **Zod** for schema-based validation; infer types from schema

## Patterns
- **API Response**: Generic `ApiResponse<T>` with success, data, error, metadata
- **Repository Pattern**: Generic `Repository<T>` with findAll, findById, create, update, delete
- **Custom Hooks**: Extract reusable logic into `use[Name]` hooks

## Testing
- E2E: Use **Playwright**
- Unit/Integration: Use **Vitest** or **Jest**
- No `console.log` in production code

## Immutability
- Use spread operator for object/array updates
- Use `async/await` with `try/catch` (narrow `unknown` errors)

Adapted from affaan-m/everything-claude-code TypeScript rules.
