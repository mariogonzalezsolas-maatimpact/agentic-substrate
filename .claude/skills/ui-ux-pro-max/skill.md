---
name: ui-ux-pro-max
description: Master UI/UX design methodology. Comprehensive design system architecture, layout patterns, component hierarchy, micro-interactions, design tokens, spacing systems, typography scales, color systems, motion design, form UX, and dashboard design. Claude invokes this when UI/UX design decisions are needed.
auto_invoke: true
tags: [ui, ux, design-system, layout, components, micro-interactions, design-tokens]
---

# UI/UX Pro MAX Skill

This skill provides an elite-level methodology for UI/UX design decisions. It covers the full spectrum of interface design — from atomic design tokens to complete design system architecture.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- `/do` involves UI component design, layout architecture, or design system work
- User explicitly requests UI/UX guidance or design decisions
- @ux-accessibility-reviewer, @responsive-reviewer, or @theme-reviewer need design context
- Task involves building new UI features, dashboards, or interactive components
- Design system creation or extension is needed

**Do NOT invoke when:**
- Task is backend-only with no UI impact
- Task is purely accessibility audit (use web-accessibility skill)
- Task is only about CSS theming (use theme-reviewer agent)

## Core Principles

1. **User intent first** — Every pixel serves a purpose. If it doesn't help the user accomplish their goal, remove it
2. **Progressive disclosure** — Show only what's needed now, reveal complexity on demand
3. **Consistency over novelty** — Reuse patterns before inventing new ones
4. **Accessible by default** — Design for the widest range of users from the start
5. **Performance is UX** — A beautiful interface that loads slowly is a bad interface

## Design System Architecture Protocol

### Step 1: Design Token Foundation (< 2 minutes)

**Establish the atomic layer**:

```
Design Tokens (Tier 1 - Primitive)
├── Colors: brand, neutral, semantic (success/warning/error/info)
├── Typography: font-family, font-size scale, font-weight, line-height
├── Spacing: 4px base unit → 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96
├── Border-radius: none, sm (4), md (8), lg (12), xl (16), full (9999)
├── Shadows: sm, md, lg, xl (elevation system)
├── Breakpoints: sm (640), md (768), lg (1024), xl (1280), 2xl (1536)
└── Motion: duration (fast 150ms, normal 200ms, slow 300ms), easing curves
```

**Semantic tokens (Tier 2 — Alias)**:
```
├── background-primary → neutral-50 (light) / neutral-900 (dark)
├── text-primary → neutral-900 (light) / neutral-50 (dark)
├── border-default → neutral-200 (light) / neutral-700 (dark)
├── interactive-primary → brand-600
├── interactive-hover → brand-700
├── interactive-active → brand-800
├── surface-elevated → white + shadow-md (light) / neutral-800 (dark)
└── focus-ring → brand-500 with 2px offset
```

### Step 2: Typography Scale

**Use a modular scale** (1.250 — Major Third recommended):

| Step | Size | Line-height | Use |
|------|------|-------------|-----|
| xs | 12px | 16px | Captions, badges |
| sm | 14px | 20px | Secondary text, labels |
| base | 16px | 24px | Body text (default) |
| lg | 18px | 28px | Lead paragraphs |
| xl | 20px | 28px | H4, card titles |
| 2xl | 24px | 32px | H3, section titles |
| 3xl | 30px | 36px | H2, page sections |
| 4xl | 36px | 40px | H1, page titles |
| 5xl | 48px | 48px | Hero, display |

**Rules**:
- Max 2 font families (one sans, one mono for code)
- Never use more than 3 font weights per page
- Body text: minimum 16px, line-height 1.5
- Headings: line-height 1.2-1.3

### Step 3: Component Hierarchy (Atomic Design)

```
Atoms → Molecules → Organisms → Templates → Pages

Atoms:       Button, Input, Badge, Avatar, Icon, Label, Spinner
Molecules:   SearchBar (Input + Button), FormField (Label + Input + Error),
             UserChip (Avatar + Name), StatCard (Icon + Value + Label)
Organisms:   Navbar, Sidebar, DataTable, Form, Card, Modal, CommandPalette
Templates:   DashboardLayout, AuthLayout, SettingsLayout, ListDetailLayout
Pages:       Dashboard, UserProfile, Settings, ProductList
```

### Step 4: Layout Patterns

**Container strategy**:
```css
/* Max-width container with responsive padding */
.container { max-width: 1280px; margin: 0 auto; padding: 0 16px; }
@media (min-width: 768px) { .container { padding: 0 24px; } }
@media (min-width: 1024px) { .container { padding: 0 32px; } }
```

**Common layout patterns**:

| Pattern | When to use | Structure |
|---------|------------|-----------|
| **Stack** | Vertical content flow | Flex column, gap-based spacing |
| **Cluster** | Horizontal wrapping items | Flex row wrap, gap-based |
| **Sidebar** | Fixed + fluid columns | Grid with minmax() |
| **Switcher** | Responsive column/row | Flexbox with wrap threshold |
| **Cover** | Vertically centered hero | Grid with min-height |
| **Center** | Horizontally centered block | Max-width + auto margins |
| **Holy Grail** | Header + sidebar + main + footer | CSS Grid areas |

### Step 5: Interaction Design

**State management for interactive elements**:

```
Default → Hover → Focus → Active → Disabled → Loading → Error → Success

Visual cues per state:
- Hover: subtle background change, cursor pointer
- Focus: visible focus ring (2px brand-500, 2px offset)
- Active: slight scale(0.98) or darker background
- Disabled: opacity 0.5, cursor not-allowed, no pointer events
- Loading: spinner or skeleton, preserve layout dimensions
- Error: red border, error icon, descriptive message below
- Success: green check, brief confirmation, auto-dismiss
```

**Micro-interactions** (use sparingly):
- Button press: scale(0.97) for 100ms
- Toggle: slide animation 200ms ease-out
- Accordion: height auto with 200ms ease
- Toast notifications: slide in from top-right, auto-dismiss 5s
- Page transitions: fade 150ms or slide 200ms
- Skeleton loading: pulse animation on neutral-200

### Step 6: Form UX

**Rules for excellent forms**:

1. **Labels always visible** — No placeholder-only labels
2. **Single-column layout** — Multi-column forms reduce completion rates by 47%
3. **Inline validation** — Validate on blur, not on every keystroke
4. **Clear error messages** — "Email format: name@example.com" not "Invalid input"
5. **Smart defaults** — Pre-fill what you can (country from locale, etc.)
6. **Progressive disclosure** — Optional fields behind "Show more" when possible
7. **Primary action right/bottom** — Consistent CTA placement
8. **Destructive actions require confirmation** — Delete needs double-confirm or undo

**Field ordering**: Most important / required fields first. Group related fields with fieldset.

### Step 7: Dashboard & Data Display

**Dashboard composition**:
```
┌─────────────────────────────────────────────┐
│  KPI Row (3-4 stat cards, equal width)       │
├─────────────────────┬───────────────────────┤
│  Primary Chart       │  Secondary Chart      │
│  (2/3 width)         │  (1/3 width)          │
├─────────────────────┴───────────────────────┤
│  Data Table (full width, sortable, filterable│
│  paginated, with bulk actions)               │
└─────────────────────────────────────────────┘
```

**Data table essentials**:
- Sticky header on scroll
- Sortable columns (click header)
- Row selection with checkbox
- Bulk actions toolbar (appears on selection)
- Pagination or virtual scroll for 100+ rows
- Empty state with illustration + CTA
- Loading skeleton preserving column widths

### Step 8: Responsive Strategy

**Mobile-first breakpoint system**:

```
Base (0-639px):     Single column, stacked layout, hamburger nav
sm (640px+):        Minor adjustments, wider cards
md (768px+):        Two-column layouts, sidebar appears
lg (1024px+):       Full layout, expanded navigation
xl (1280px+):       Max-width container, larger spacing
2xl (1536px+):      Wide layouts, multi-panel views
```

**Touch targets**: Minimum 44x44px (WCAG), recommended 48x48px.

## Quality Checklist

Before completing any UI/UX task, verify:

- [ ] Design tokens are consistent (no magic numbers)
- [ ] Typography scale followed (no arbitrary font sizes)
- [ ] Spacing uses the 4px grid system
- [ ] All interactive elements have hover, focus, active, disabled states
- [ ] Forms have visible labels, inline validation, clear errors
- [ ] Loading states exist (skeleton or spinner)
- [ ] Empty states exist (illustration + CTA)
- [ ] Error states exist (with recovery actions)
- [ ] Mobile layout works at 320px minimum width
- [ ] Touch targets are minimum 44x44px
- [ ] Color contrast meets WCAG AA (4.5:1 text, 3:1 UI)
- [ ] Focus order is logical (tab through the page)
- [ ] Animations respect prefers-reduced-motion

## Common Pitfalls

- **Inconsistent spacing** → Always use token values, never arbitrary px
- **Missing states** → Every component needs default, hover, focus, disabled, loading, error
- **Placeholder-only labels** → Labels must be visible, persistent
- **Tiny touch targets** → Minimum 44px, add padding not just visual size
- **No empty states** → Users will see empty lists, design for them
- **Overusing animation** → Motion is seasoning, not the main course

---

**This skill ensures all UI/UX decisions follow a systematic, token-based approach that produces consistent, accessible, and delightful interfaces.**
