---
name: frontend-design
description: Frontend architecture and design patterns inspired by Anthropic's design philosophy. Clean, conversational interfaces with thoughtful component composition, state management, rendering strategies, CSS architecture, error/loading/empty states, and performance patterns. Claude invokes this when frontend architecture decisions are needed.
auto_invoke: true
tags: [frontend, architecture, components, state-management, css, performance, anthropic]
---

# Frontend Design Skill

This skill provides a systematic methodology for frontend architecture decisions, inspired by Anthropic's design philosophy: clarity, restraint, and human-centered interfaces.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- `/do` involves frontend architecture, component design, or UI implementation
- Building React/Next.js/Vue/Svelte components with complex state
- Designing component APIs, prop interfaces, or composition patterns
- Making CSS architecture decisions (Tailwind, CSS modules, styled-components)
- Implementing loading, error, empty, and transition states

**Do NOT invoke when:**
- Task is backend-only
- Task is design system token definition (use ui-ux-pro-max skill)
- Task is accessibility audit only (use web-accessibility skill)

## Core Principles (Anthropic Design Philosophy)

1. **Clarity over cleverness** — Code and interfaces should be immediately understandable
2. **Restraint** — Add elements only when they serve the user's goal. Less is more
3. **Conversational interfaces** — Guide users through flows with natural, progressive interactions
4. **Forgiving design** — Allow undo, support recovery, never punish mistakes
5. **Performance as a feature** — Perceived speed matters as much as actual speed

## Frontend Architecture Protocol

### Step 1: Component Architecture Assessment

**Component classification**:

| Type | Purpose | State | Examples |
|------|---------|-------|---------|
| **Presentational** | Renders UI from props | None/minimal | Button, Card, Badge, Avatar |
| **Container** | Manages state + data | Complex | UserList, Dashboard, FormWizard |
| **Layout** | Page structure | None | PageLayout, Sidebar, Grid |
| **Feature** | Complete feature unit | Own state + side effects | AuthFlow, CheckoutWizard |
| **Utility** | Cross-cutting concern | Context-based | ErrorBoundary, ThemeProvider |

**Component API design rules**:
1. **Props should be obvious** — `<Button variant="primary" size="lg">` not `<Button v="p" s="l">`
2. **Boolean props for binary states** — `disabled`, `loading`, `selected`
3. **Union types for variants** — `variant: "primary" | "secondary" | "ghost" | "destructive"`
4. **Composition over configuration** — Prefer children/slots over deep prop trees
5. **Forward refs and spread remaining props** — Components should be extensible

### Step 2: Component Composition Patterns

**Compound Components** (for related UI groups):
```tsx
<Select>
  <Select.Trigger />
  <Select.Content>
    <Select.Item value="a">Option A</Select.Item>
    <Select.Item value="b">Option B</Select.Item>
  </Select.Content>
</Select>
```

**Render Props** (for flexible rendering logic):
```tsx
<DataTable
  data={users}
  renderRow={(user) => <UserRow key={user.id} user={user} />}
  renderEmpty={() => <EmptyState message="No users found" />}
/>
```

**Headless Components** (logic without UI):
```tsx
const { isOpen, toggle, close } = useDisclosure();
const { field, error } = useFormField("email", { required: true });
```

**When to use which**:
- Compound: Related UI that shares implicit state (Tabs, Accordion, Select)
- Render Props: When parent needs control over child rendering
- Headless: When logic is reusable but UI varies completely

### Step 3: State Management Strategy

**State location decision tree**:
```
Is this state used by only one component?
  → Yes: useState (local state)
  → No: Is it shared by parent-child (2-3 levels)?
    → Yes: Prop drilling or composition
    → No: Is it shared across distant components?
      → Yes: Context or state library
      → No: Is it server data?
        → Yes: React Query / SWR / TanStack Query
        → No: Is it URL-derived?
          → Yes: URL params / search params
          → No: Global store (Zustand / Jotai)
```

**State categories**:

| Category | Tool | Example |
|----------|------|---------|
| UI state | useState | Modal open, accordion expanded |
| Form state | react-hook-form + zod | Input values, validation |
| Server state | TanStack Query | API data, cache, mutations |
| URL state | nuqs / search params | Filters, pagination, sort |
| Global state | Zustand / Jotai | Theme, auth, feature flags |

**Anti-patterns to avoid**:
- Storing derived state (calculate from source instead)
- Syncing state between sources (single source of truth)
- Putting everything in global state (keep state as local as possible)
- Managing server state manually (use a server state library)

### Step 4: Data Fetching & Loading Patterns

**Loading states hierarchy**:

```
1. Skeleton screens (BEST) — Preserve layout, reduce perceived load time
2. Progressive loading — Show content as it arrives (streaming)
3. Spinner with context — "Loading your dashboard..." (contextual message)
4. Full-page spinner (WORST) — Only for initial app load
```

**Implementation pattern**:
```tsx
// Every data-dependent component needs 3 states
function UserProfile({ userId }) {
  const { data, isLoading, error } = useQuery(['user', userId]);

  if (isLoading) return <UserProfileSkeleton />;
  if (error) return <ErrorState error={error} retry={refetch} />;
  if (!data) return <EmptyState message="User not found" />;

  return <UserProfileContent user={data} />;
}
```

**Optimistic updates** (for mutations):
- Show success immediately, rollback on error
- Use for: likes, toggles, status changes, simple edits
- Don't use for: payments, deletions, complex operations

### Step 5: CSS Architecture

**Recommended: Tailwind CSS + CVA (Class Variance Authority)**:

```tsx
import { cva, type VariantProps } from "class-variance-authority";

const buttonVariants = cva(
  "inline-flex items-center justify-center rounded-md font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50",
  {
    variants: {
      variant: {
        primary: "bg-primary text-primary-foreground hover:bg-primary/90",
        secondary: "bg-secondary text-secondary-foreground hover:bg-secondary/80",
        ghost: "hover:bg-accent hover:text-accent-foreground",
        destructive: "bg-destructive text-destructive-foreground hover:bg-destructive/90",
      },
      size: {
        sm: "h-9 px-3 text-sm",
        md: "h-10 px-4",
        lg: "h-11 px-8 text-lg",
      },
    },
    defaultVariants: { variant: "primary", size: "md" },
  }
);
```

**CSS organization rules**:
1. Use design tokens via CSS custom properties or Tailwind config
2. Never use arbitrary values (`[23px]`) — extend the theme instead
3. Use `cn()` utility (clsx + twMerge) for conditional classes
4. Mobile-first: base styles for mobile, add complexity with breakpoints
5. Prefer `gap` over margin for spacing between siblings

### Step 6: Error Handling & Recovery

**Error boundary strategy**:
```
App-level ErrorBoundary
  └─ Route-level ErrorBoundary (per page)
      └─ Feature-level ErrorBoundary (per widget)
          └─ Component-level try/catch (per data fetch)
```

**Error display patterns**:

| Context | Pattern | Recovery |
|---------|---------|----------|
| Form field | Inline error below field | Fix and resubmit |
| API call | Toast notification | Retry button |
| Page load | Full error state with illustration | Retry or go home |
| Auth | Redirect to login | Re-authenticate |
| Network | Offline banner at top | Auto-retry on reconnect |
| Permission | 403 state with explanation | Request access CTA |

**Error messages must**:
- Say what happened (in plain language)
- Say what the user can do about it
- Never show stack traces, error codes, or technical jargon to end users

### Step 7: Performance Patterns

**Rendering optimization checklist**:
- [ ] Images: Use `next/image` or `<img loading="lazy">`, serve WebP/AVIF
- [ ] Lists: Virtualize with TanStack Virtual for 100+ items
- [ ] Code splitting: Dynamic imports for routes and heavy components
- [ ] Memoization: `React.memo` only when measured, not preventively
- [ ] Bundle: Analyze with bundleanalyzer, tree-shake unused imports
- [ ] Fonts: Preload critical fonts, use `font-display: swap`
- [ ] Third-party scripts: Load async/defer, use Partytown for analytics

**Core Web Vitals targets**:
- LCP (Largest Contentful Paint): < 2.5s
- INP (Interaction to Next Paint): < 200ms
- CLS (Cumulative Layout Shift): < 0.1

## Quality Checklist

Before completing any frontend task:

- [ ] Component has TypeScript types for all props
- [ ] Loading, error, and empty states handled
- [ ] Responsive from 320px to 2560px
- [ ] Keyboard navigable (tab, enter, escape)
- [ ] No prop drilling beyond 2 levels
- [ ] Server state uses TanStack Query or equivalent
- [ ] No inline styles or arbitrary Tailwind values
- [ ] Error boundaries at appropriate levels
- [ ] Images optimized and lazy-loaded
- [ ] Bundle impact assessed for new dependencies

## Common Pitfalls

- **Prop drilling** → Use composition, context, or state library
- **useEffect for derived state** → Use useMemo or compute inline
- **Missing loading states** → Every async operation needs a loading UI
- **Client-side only** → Use SSR/SSG where SEO or performance matters
- **Monster components** → Split at 200 lines. Extract hooks for logic
- **Ignoring error states** → Users WILL encounter errors. Design for them

---

**This skill ensures frontend architecture decisions produce clean, performant, and maintainable interfaces following modern best practices and Anthropic's design philosophy.**
