---
paths: ["next.config.*", "app/**", "pages/**", "**/*.tsx", "**/*.ts"]
---
# Next.js Rules

## App Router Patterns (Next.js 14+)

### Server vs Client Components
- **Default to Server Components** -- only add `'use client'` when you need interactivity, hooks, or browser APIs
- Server Components: data fetching, DB access, sensitive logic
- Client Components: forms, event handlers, useState/useEffect, browser APIs
- **Never import server-only code in client components** -- use `server-only` package to enforce boundaries

### Data Fetching
- Use `async` Server Components for data fetching (not getServerSideProps)
- Use `fetch()` with Next.js caching: `fetch(url, { next: { revalidate: 3600 } })`
- For database: query directly in Server Components via Prisma
- For mutations: use Server Actions (`'use server'`)

### Route Organization
```
app/
├── (auth)/           → grouped routes sharing auth layout
│   ├── login/
│   └── register/
├── (dashboard)/      → grouped routes sharing dashboard layout
│   ├── page.tsx      → dashboard home
│   └── settings/
├── api/              → API routes (only when needed for webhooks/external)
├── layout.tsx        → root layout
├── loading.tsx       → streaming loading UI
├── error.tsx         → error boundary
└── not-found.tsx     → 404 page
```

### Server Actions
```typescript
'use server'

export async function createItem(formData: FormData) {
  const data = schema.parse(Object.fromEntries(formData))
  await db.item.create({ data })
  revalidatePath('/items')
}
```
- Always validate input with Zod in Server Actions
- Use `revalidatePath()` or `revalidateTag()` after mutations
- Return typed responses, never throw raw errors to client

### Performance
- Use `next/image` for all images (auto optimization)
- Use `next/font` for fonts (no layout shift)
- Use `next/link` for navigation (prefetching)
- Use `loading.tsx` for streaming + Suspense boundaries
- Use `generateStaticParams()` for static paths
- Use `dynamic = 'force-static'` where possible

### Environment Variables
- `NEXT_PUBLIC_*` for client-side (exposed to browser)
- Everything else: server-only (never prefix with NEXT_PUBLIC_ if sensitive)
- Validate with Zod at startup: `env.ts` with `z.object({ DATABASE_URL: z.string() })`

### Common Anti-Patterns
- Using `'use client'` on every component (kills SSR benefits)
- Fetching data in useEffect instead of Server Components
- Using API routes for internal data fetching (use Server Actions)
- Not using `loading.tsx` for streaming
- Importing large client libraries in Server Components

Adapted from Next.js 14+ App Router documentation and best practices.
