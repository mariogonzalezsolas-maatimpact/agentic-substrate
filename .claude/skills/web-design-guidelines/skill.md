---
name: web-design-guidelines
description: Visual web design fundamentals covering typography, color theory, spacing systems, visual hierarchy, Gestalt principles, responsive grids, whitespace, contrast, alignment, and consistency. Claude invokes this when making visual design decisions for web interfaces.
auto_invoke: true
tags: [design, typography, color, spacing, hierarchy, gestalt, grid, visual-design]
---

# Web Design Guidelines Skill

This skill provides a systematic methodology for making visual design decisions that produce clean, professional, and effective web interfaces.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- Making visual design decisions (colors, typography, spacing, layout)
- Building landing pages, marketing sites, or product interfaces
- Choosing color palettes, font pairings, or spacing scales
- User asks about design principles, visual hierarchy, or layout composition
- @theme-reviewer or @responsive-reviewer need design context

**Do NOT invoke when:**
- Task is purely functional/backend with no visual output
- Task is component API design (use frontend-design skill)
- Task is accessibility-specific (use web-accessibility skill)

## Core Principles

1. **Hierarchy guides the eye** — The most important element should be the most prominent
2. **Consistency builds trust** — Repeat patterns, don't reinvent for each screen
3. **Whitespace is not empty** — It's the most powerful design tool you have
4. **Constraints enable creativity** — A strict system produces better results than ad-hoc decisions
5. **Less, but better** — Remove elements until it breaks, then add one back

## Visual Hierarchy Protocol

### The Hierarchy Stack (Top = Most Prominent)

```
1. SIZE         — Larger elements draw attention first
2. COLOR        — High-contrast and saturated colors stand out
3. WEIGHT       — Bold text over regular text
4. POSITION     — Top-left (LTR) and center get seen first
5. WHITESPACE   — Isolated elements with more space feel more important
6. PROXIMITY    — Grouped elements are perceived as related
```

### Creating Hierarchy

**3-level text hierarchy** (sufficient for most interfaces):

| Level | Role | Example Treatment |
|-------|------|-------------------|
| **Primary** | Page title, hero text | 36-48px, bold, high contrast |
| **Secondary** | Section headings, card titles | 20-24px, semibold, medium contrast |
| **Tertiary** | Body text, descriptions | 14-16px, regular, lower contrast |

**Action hierarchy** (for buttons/CTAs):

| Level | When | Style |
|-------|------|-------|
| **Primary** | One per page/section. The main action | Solid fill, brand color, largest |
| **Secondary** | Supporting action | Outlined or muted fill |
| **Tertiary** | Least important, optional | Text-only or ghost button |

**Rule**: If everything is bold, nothing is bold. Hierarchy requires contrast between levels.

## Typography System

### Font Selection Rules

1. **Max 2 font families** — One for headings (can be display/serif), one for body (sans-serif)
2. **System font stack for performance** — `font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif`
3. **Popular safe pairings**:
   - Inter (body) + Inter (headings) — Clean, modern, one-font system
   - Inter (body) + Cal Sans (headings) — Tech/SaaS aesthetic
   - System UI (body) + System UI (headings) — Maximum performance

### Type Scale

**Use a modular scale** (ratio 1.250 — Major Third):

```
12px → 14px → 16px → 20px → 24px → 30px → 36px → 48px → 60px
```

**Rules**:
- Body text: 16px minimum (never smaller for primary content)
- Line height: 1.5 for body, 1.2 for headings
- Line length: 45-75 characters (optimal readability)
- Letter spacing: Tighten for large headings (-0.02em), normal for body
- Paragraph spacing: 1.5x the body line height

### Font Weight Usage

| Weight | Name | Use |
|--------|------|-----|
| 400 | Regular | Body text, descriptions |
| 500 | Medium | Labels, UI elements, emphasis |
| 600 | Semibold | Card titles, section headings |
| 700 | Bold | Page titles, primary headings |

**Rule**: Using more than 3 weights on a page creates visual noise.

## Color System

### Building a Color Palette

**Step 1: Brand color** — One primary hue (e.g., blue-600)
**Step 2: Neutral scale** — 10-step gray from white to near-black
**Step 3: Semantic colors** — Success (green), Warning (amber), Error (red), Info (blue)
**Step 4: Extended palette** — 10 shades per color (50-950)

```
Primary:    50  100  200  300  400  500  600  700  800  900  950
Neutral:    50  100  200  300  400  500  600  700  800  900  950
Success:    50  100  200  300  400  500  600  700  800  900
Warning:    50  100  200  300  400  500  600  700  800  900
Error:      50  100  200  300  400  500  600  700  800  900
```

### Color Usage Rules

| Surface | Light Mode | Dark Mode |
|---------|-----------|-----------|
| Page background | neutral-50 or white | neutral-900 or neutral-950 |
| Card/surface | white | neutral-800 |
| Primary text | neutral-900 | neutral-50 |
| Secondary text | neutral-600 | neutral-400 |
| Borders | neutral-200 | neutral-700 |
| Primary action | brand-600 | brand-500 |
| Hover state | brand-700 | brand-400 |

**The 60-30-10 Rule**:
- **60%** — Dominant color (background, large surfaces)
- **30%** — Secondary color (cards, secondary surfaces)
- **10%** — Accent color (CTAs, highlights, brand moments)

**Never**:
- Use pure black (#000000) for text — use neutral-900 (softer)
- Use more than 3 hues on a single screen
- Rely on color alone to convey meaning (add text or icons)

## Spacing System

### 4px Base Grid

All spacing is a multiple of 4px:

```
4   8   12  16  20  24  32  40  48  64  80  96  128
```

**When to use each**:

| Space | Use |
|-------|-----|
| 4px | Tight: between icon and label, between badge elements |
| 8px | Compact: between related form fields, between list items |
| 12px | Standard: padding inside buttons, between related elements |
| 16px | Default: padding inside cards, between form sections |
| 24px | Spacious: between content sections, card padding |
| 32px | Generous: between major sections |
| 48-64px | Dramatic: between page sections, hero padding |
| 80-128px | Page-level: top/bottom page padding, section breaks |

### Spacing Rules

1. **Related items close, unrelated items far** — Proximity implies relationship
2. **Consistent internal padding** — A card should have the same padding on all sides
3. **Use gap, not margin** — `gap` on flex/grid containers is cleaner than margins on children
4. **Never use arbitrary values** — If 16px isn't enough and 24px is too much, use 20px (next step in scale)

## Gestalt Principles for Web Design

| Principle | Application |
|-----------|------------|
| **Proximity** | Group related items with less space between them |
| **Similarity** | Same style = same type (all links blue, all buttons rounded) |
| **Continuity** | Align elements to create visual flow (grid alignment) |
| **Closure** | Users complete partial shapes (cards don't need full borders) |
| **Figure/Ground** | Use elevation (shadows) to separate layers |
| **Common Region** | A shared background or border groups elements (cards) |

## Layout & Grid

### Responsive Grid System

```
Mobile (< 640px):   1 column, 16px gutter, 16px margin
Tablet (640-1023px): 2-column, 24px gutter, 24px margin
Desktop (1024px+):   12-column, 24px gutter, 32px margin
Wide (1280px+):      12-column, 32px gutter, max-width container
```

### Common Layout Compositions

**Marketing page**:
```
[Full-width hero with CTA]
[3-column feature grid]
[Split: image left + text right]
[Testimonial carousel]
[Full-width CTA banner]
[Footer]
```

**Dashboard**:
```
[Top nav bar - fixed]
[Sidebar nav - fixed | Main content - scrollable]
  Main content:
  [KPI cards row]
  [Chart + Chart (2-col)]
  [Full-width data table]
```

**Settings page**:
```
[Sidebar nav | Content area]
  Content area:
  [Section heading]
  [Form group with save button]
  [Divider]
  [Section heading]
  [Form group with save button]
```

## Whitespace

**Whitespace is design**:

- **Micro whitespace** (4-8px): Between characters, within components
- **Macro whitespace** (24-128px): Between sections, around page content
- **Active whitespace** (intentional): Drawing attention to content by surrounding it with space
- **Passive whitespace** (natural): Line height, paragraph spacing, margins

**Rule**: When a design feels cluttered, the answer is usually more whitespace, not reorganization.

**Dense vs. Spacious**:
- Dashboards/tools: Denser spacing (less whitespace, more information density)
- Marketing/content: Spacious (generous whitespace, focus on messaging)
- Mobile: Adapt — touch targets need space, but screen is limited

## Visual Polish Checklist

### Elevation & Shadows

```
Level 0: Flat (no shadow) — background elements
Level 1: shadow-sm — cards, inputs on focus
Level 2: shadow-md — dropdowns, popovers
Level 3: shadow-lg — modals, dialogs
Level 4: shadow-xl — notifications, floating action buttons
```

**Rule**: Higher elements cast larger shadows. Don't skip levels.

### Border Radius

```
none:  0    — Tables, full-width sections
sm:    4px  — Input fields, badges
md:    8px  — Cards, buttons
lg:    12px — Modals, large cards
xl:    16px — Marketing cards, hero sections
full:  9999px — Avatars, pills, round buttons
```

**Rule**: Pick 2-3 radius values and use them consistently. Don't mix rounded corners arbitrarily.

## Quality Checklist

Before completing any visual design task:

- [ ] Typography uses the scale (no arbitrary sizes)
- [ ] Spacing uses the 4px grid (no arbitrary values)
- [ ] Color palette has clear primary, neutral, and semantic colors
- [ ] Visual hierarchy is clear (primary, secondary, tertiary levels)
- [ ] Maximum 2 font families used
- [ ] Maximum 3 font weights per page
- [ ] Whitespace is intentional and consistent
- [ ] Elements align to a grid
- [ ] Dark mode has proper color mappings
- [ ] Contrast ratios meet WCAG AA minimums
- [ ] Consistent border radius across similar components
- [ ] Shadow elevation system is coherent
- [ ] 60-30-10 color ratio approximately followed
- [ ] Line length is 45-75 characters for body text

## Common Pitfalls

- **Too many colors** → Stick to 1 brand hue + neutrals + 3 semantic colors
- **Inconsistent spacing** → Use the scale, never eyeball
- **No visual hierarchy** → If everything looks the same importance, nothing stands out
- **Tight line height** → Body text needs 1.5 line-height for readability
- **Pure black on pure white** → Too harsh. Use neutral-900 on white or neutral-50
- **Centering everything** → Left-align body text. Center only short headings and CTAs

---

**This skill ensures all visual design decisions follow proven principles of typography, color, spacing, and hierarchy — producing professional, readable, and visually coherent interfaces.**
