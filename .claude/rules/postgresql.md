---
paths: ["**/*.prisma", "**/*.sql", "prisma/**", "migrations/**"]
---
# PostgreSQL + Prisma Rules

## Prisma Best Practices

### Schema Design
- Use `@id @default(cuid())` for IDs (not autoincrement -- better for distributed systems)
- Use `@updatedAt` on all models
- Define indexes explicitly: `@@index([field1, field2])`
- Use enums for status fields: `enum Status { PENDING ACTIVE ARCHIVED }`
- Relations: always define both sides with `@relation`

### Query Patterns
```typescript
// GOOD: Select only what you need
const users = await prisma.user.findMany({
  select: { id: true, name: true, email: true }
})

// GOOD: Include relations (avoids N+1)
const posts = await prisma.post.findMany({
  include: { author: true, tags: true }
})

// BAD: findMany without pagination
const all = await prisma.item.findMany() // unbounded!

// GOOD: Always paginate
const items = await prisma.item.findMany({
  take: 20,
  skip: page * 20,
  orderBy: { createdAt: 'desc' }
})
```

### Transactions
```typescript
// Use interactive transactions for multi-step operations
const result = await prisma.$transaction(async (tx) => {
  const user = await tx.user.create({ data: userData })
  await tx.account.create({ data: { userId: user.id, ...accountData } })
  return user
})
```

### Migrations
- Always review generated SQL: `npx prisma migrate dev --create-only`
- Name migrations descriptively: `add_user_email_index`
- Never edit a migration after it has been applied
- Test migrations on a copy of production data before deploying

## PostgreSQL Specifics

### Indexes
- Add indexes on all foreign keys (Prisma doesn't auto-create these)
- Use partial indexes for filtered queries: `@@index([status], map: "active_items") @where(status: ACTIVE)`
- Use GIN indexes for full-text search: `CREATE INDEX idx_search ON items USING GIN (to_tsvector('english', title || ' ' || description))`

### Connection Pooling
- Use `pgbouncer` or Prisma Accelerate in production
- Set `connection_limit` in Prisma: `datasource db { url = env("DATABASE_URL") }`
- For serverless (Next.js on Vercel): use `@prisma/adapter-neon` or connection pooling

### Common Anti-Patterns
- `findMany()` without `take` limit -- always paginate
- Nested creates without transactions -- use `$transaction`
- String concatenation in raw queries -- always use `$queryRaw` with tagged templates
- Missing indexes on foreign keys and frequently-filtered columns
- Not using `select` -- fetching entire rows when you need 2 fields
