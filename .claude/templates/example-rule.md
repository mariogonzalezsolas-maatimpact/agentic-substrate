---
paths:
  - "src/api/**"
  - "src/routes/**"
---

# API Development Rules

These rules apply automatically when working with API route files.

## Conventions

- Validate all request inputs at the handler level
- Use consistent error response format
- Include request ID in error responses for tracing
- Document endpoints with JSDoc comments

## Example Error Format

```json
{
  "error": "Validation failed",
  "code": 422,
  "requestId": "req_abc123",
  "details": ["field 'email' is required"]
}
```

## Notes

- This is an example rule file -- modify or delete as needed
- Rules without `paths` frontmatter apply to all files
- See `.claude/skills/context-engineering/skill.md` for full documentation
