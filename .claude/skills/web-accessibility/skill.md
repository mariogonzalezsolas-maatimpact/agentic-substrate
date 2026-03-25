---
name: web-accessibility
description: Web accessibility methodology covering WCAG 2.2 compliance (A/AA/AAA), ARIA patterns, keyboard navigation, screen reader optimization, color contrast, focus management, semantic HTML, accessible forms, modals, and dynamic content. Claude invokes this when building accessible web interfaces.
auto_invoke: true
tags: [accessibility, wcag, aria, keyboard, screen-reader, a11y, inclusive-design]
---

# Web Accessibility Skill

This skill provides a systematic methodology for building accessible web interfaces that meet WCAG 2.2 standards and serve the widest range of users.

## When Claude Should Use This Skill

Claude will automatically invoke this skill when:
- `/do` involves building or modifying user-facing web interfaces
- User mentions accessibility, a11y, WCAG, ARIA, or screen readers
- @ux-accessibility-reviewer agent is spawned
- Building forms, modals, navigation, or interactive components
- Task involves color, contrast, or keyboard interaction decisions

**Do NOT invoke when:**
- Task is backend-only with no user interface
- Task is mobile-native (iOS/Android) — different guidelines apply
- Task is PDF accessibility (different standard)

## Core Principles

1. **Perceivable** — Information must be presentable in ways all users can perceive
2. **Operable** — Interface components must be operable by all users
3. **Understandable** — Information and operation must be understandable
4. **Robust** — Content must be robust enough for diverse user agents and assistive tech

## WCAG 2.2 Compliance Protocol

### Level A (Minimum — Mandatory)

| Criterion | Rule | Implementation |
|-----------|------|----------------|
| 1.1.1 Non-text Content | All images have alt text | `<img alt="descriptive text">`, decorative: `alt=""` |
| 1.3.1 Info & Relationships | Structure conveyed semantically | Use `<h1>`-`<h6>`, `<nav>`, `<main>`, `<aside>`, `<table>` |
| 1.3.2 Meaningful Sequence | Reading order matches visual order | DOM order = visual order, use CSS for visual changes |
| 2.1.1 Keyboard | All functionality via keyboard | Tab, Enter, Space, Escape, Arrow keys |
| 2.1.2 No Keyboard Trap | Users can always tab out | Focus never gets stuck, Escape closes modals |
| 2.4.1 Skip Links | Skip to main content | `<a href="#main" class="sr-only focus:not-sr-only">` |
| 2.4.2 Page Titled | Every page has descriptive title | `<title>Page Name — App Name</title>` |
| 3.1.1 Language | Page language declared | `<html lang="en">` |
| 4.1.2 Name, Role, Value | Custom controls have accessible names | ARIA labels, roles, and states |

### Level AA (Standard — Recommended Target)

| Criterion | Rule | Implementation |
|-----------|------|----------------|
| 1.4.3 Contrast | Text: 4.5:1, large text: 3:1 | Use contrast checker tools, design system tokens |
| 1.4.4 Resize Text | Usable at 200% zoom | Use rem/em units, test at 200% browser zoom |
| 1.4.11 Non-text Contrast | UI components: 3:1 against adjacent | Borders, icons, focus rings need sufficient contrast |
| 2.4.6 Headings & Labels | Descriptive headings | `<h2>User Settings</h2>` not `<h2>Section 2</h2>` |
| 2.4.7 Focus Visible | Focus indicator always visible | Never `outline: none` without replacement, use ring |
| 2.5.8 Target Size | Minimum 24x24px (AA) | Prefer 44x44px, add padding to small targets |
| 3.2.3 Consistent Navigation | Nav consistent across pages | Same order, same items, same location |
| 3.3.1 Error Identification | Errors described in text | "Email is required" not just red border |
| 3.3.2 Labels or Instructions | Inputs have visible labels | Always `<label>`, never placeholder-only |

### Level AAA (Enhanced — Aspirational)

| Criterion | Rule | Implementation |
|-----------|------|----------------|
| 1.4.6 Enhanced Contrast | Text: 7:1, large: 4.5:1 | High contrast mode support |
| 2.4.9 Link Purpose | Link text describes destination | "Read full article" not "Click here" |
| 2.5.5 Target Size Enhanced | Minimum 44x44px | Apply to all interactive elements |

## Semantic HTML Protocol

### Document Structure

```html
<body>
  <a href="#main" class="sr-only focus:not-sr-only">Skip to main content</a>

  <header role="banner">
    <nav aria-label="Main navigation">
      <ul>
        <li><a href="/" aria-current="page">Home</a></li>
        <li><a href="/about">About</a></li>
      </ul>
    </nav>
  </header>

  <main id="main">
    <h1>Page Title</h1>
    <article>
      <h2>Section Title</h2>
      <p>Content...</p>
    </article>
  </main>

  <aside aria-label="Related content">
    <!-- Sidebar -->
  </aside>

  <footer role="contentinfo">
    <!-- Footer -->
  </footer>
</body>
```

### Heading Hierarchy

```
✅ Correct:
h1 → h2 → h3 → h3 → h2 → h3

❌ Wrong (skipping levels):
h1 → h3 → h2 → h4
```

**Rule**: Never skip heading levels. Every page has exactly one `<h1>`.

## Keyboard Navigation Protocol

### Expected Keyboard Behaviors

| Element | Keys | Behavior |
|---------|------|----------|
| Links | Enter | Activate link |
| Buttons | Enter, Space | Activate button |
| Checkboxes | Space | Toggle checked |
| Radio buttons | Arrow keys | Move selection within group |
| Tabs | Arrow keys | Switch tab; Tab key moves to tab panel |
| Menus | Arrow keys | Navigate items; Enter activates; Escape closes |
| Modals | Tab (trapped) | Cycle focus within modal; Escape closes |
| Combobox | Arrow keys | Navigate options; Enter selects; Escape closes |
| Sliders | Arrow keys | Adjust value |

### Focus Management

**Focus trap for modals**:
```tsx
// When modal opens:
// 1. Save previously focused element
// 2. Move focus to first focusable element in modal
// 3. Trap Tab key within modal
// 4. On close: restore focus to previously focused element
```

**Focus ring styling**:
```css
/* Global focus style — NEVER remove outline without replacement */
:focus-visible {
  outline: 2px solid var(--ring);
  outline-offset: 2px;
}

/* Remove default only when custom focus is provided */
:focus:not(:focus-visible) {
  outline: none;
}
```

**Skip link**:
```html
<a href="#main" class="sr-only focus:absolute focus:z-50 focus:p-4 focus:bg-background focus:text-foreground">
  Skip to main content
</a>
```

## ARIA Patterns

### When to Use ARIA

```
Rule of ARIA:
1. If you can use native HTML, use native HTML
2. Don't change native semantics unless you must
3. All interactive ARIA controls must be keyboard accessible
4. Don't use role="presentation" or aria-hidden="true" on focusable elements
5. All interactive elements must have accessible names
```

### Common ARIA Patterns

**Accessible button (custom element)**:
```html
<!-- ✅ Prefer native -->
<button>Save</button>

<!-- If you must use a div (avoid this) -->
<div role="button" tabindex="0" onkeydown="handleKeyDown">Save</div>
```

**Icon-only button**:
```tsx
<button aria-label="Close dialog">
  <XIcon aria-hidden="true" />
</button>
```

**Live regions (dynamic content)**:
```html
<!-- For status messages that appear dynamically -->
<div role="status" aria-live="polite">
  3 results found
</div>

<!-- For urgent alerts -->
<div role="alert" aria-live="assertive">
  Error: Payment failed. Please try again.
</div>
```

**Disclosure (show/hide)**:
```html
<button aria-expanded="false" aria-controls="details-panel">
  Show details
</button>
<div id="details-panel" hidden>
  Details content...
</div>
```

**Tabs**:
```html
<div role="tablist" aria-label="Account settings">
  <button role="tab" aria-selected="true" aria-controls="panel-1" id="tab-1">Profile</button>
  <button role="tab" aria-selected="false" aria-controls="panel-2" id="tab-2">Security</button>
</div>
<div role="tabpanel" id="panel-1" aria-labelledby="tab-1">Profile content</div>
<div role="tabpanel" id="panel-2" aria-labelledby="tab-2" hidden>Security content</div>
```

## Accessible Forms

```html
<form aria-label="Contact form">
  <div>
    <label for="name">Full name <span aria-hidden="true">*</span></label>
    <input id="name" type="text" required aria-required="true"
           aria-describedby="name-hint" aria-invalid="false" />
    <p id="name-hint" class="text-muted-foreground text-sm">As shown on your ID</p>
  </div>

  <div>
    <label for="email">Email <span aria-hidden="true">*</span></label>
    <input id="email" type="email" required aria-required="true"
           aria-invalid="true" aria-describedby="email-error" />
    <p id="email-error" role="alert" class="text-destructive text-sm">
      Please enter a valid email address
    </p>
  </div>

  <fieldset>
    <legend>Preferred contact method</legend>
    <label><input type="radio" name="contact" value="email"> Email</label>
    <label><input type="radio" name="contact" value="phone"> Phone</label>
  </fieldset>

  <button type="submit">Send message</button>
</form>
```

**Form rules**:
- Every input has a `<label>` with matching `for`/`id`
- Required fields use `aria-required="true"` AND `required`
- Error messages linked via `aria-describedby`
- Invalid fields use `aria-invalid="true"`
- Error messages use `role="alert"` for screen reader announcement
- Group related inputs with `<fieldset>` + `<legend>`

## Color & Contrast

**Contrast requirements**:

| Element | AA Ratio | AAA Ratio |
|---------|----------|-----------|
| Normal text (< 24px) | 4.5:1 | 7:1 |
| Large text (>= 24px or bold >= 18.66px) | 3:1 | 4.5:1 |
| UI components & graphical objects | 3:1 | N/A |
| Focus indicators | 3:1 | N/A |

**Rules**:
- Never use color alone to convey information (add icons, text, or patterns)
- Ensure links are distinguishable from text (underline or 3:1 contrast + non-color indicator)
- Test with simulated color blindness (protanopia, deuteranopia, tritanopia)

**prefers-reduced-motion**:
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

## Testing Protocol

### Manual Testing Checklist

1. **Keyboard-only navigation**: Unplug your mouse. Tab through the entire page
2. **Screen reader**: Test with NVDA (Windows), VoiceOver (Mac), or TalkBack (Android)
3. **Zoom**: Set browser to 200% zoom, verify nothing breaks
4. **Color contrast**: Use browser DevTools accessibility panel
5. **Heading structure**: Use HeadingsMap extension to verify hierarchy
6. **Focus visibility**: Tab through and verify every focused element is visible

### Automated Testing

```bash
# axe-core in tests
npm install -D @axe-core/playwright  # or @axe-core/react

# In Playwright test:
import AxeBuilder from '@axe-core/playwright';
const results = await new AxeBuilder({ page }).analyze();
expect(results.violations).toEqual([]);
```

## Quality Checklist

Before completing any web interface task:

- [ ] All images have meaningful alt text (or alt="" for decorative)
- [ ] Heading hierarchy is correct (no skipped levels, one h1)
- [ ] All form inputs have visible labels (not just placeholders)
- [ ] Color contrast meets AA (4.5:1 text, 3:1 UI components)
- [ ] All functionality available via keyboard
- [ ] Focus indicator visible on every interactive element
- [ ] Skip link present and functional
- [ ] Page has descriptive `<title>`
- [ ] `<html lang>` is set correctly
- [ ] ARIA used correctly (not overriding native semantics)
- [ ] Dynamic content uses aria-live regions
- [ ] Modals trap focus and restore on close
- [ ] prefers-reduced-motion respected
- [ ] Error messages are descriptive and linked to inputs

## Common Pitfalls

- **`outline: none` globally** → Breaks keyboard navigation for all users
- **Placeholder as label** → Disappears on focus, fails WCAG 3.3.2
- **`div` as button** → Missing keyboard support, missing role, missing states
- **Color-only indicators** → Red/green for error/success excludes colorblind users
- **Auto-playing media** → Provide pause control, respect prefers-reduced-motion
- **Missing alt text** → Screen reader says "image" with no context
- **Nested interactive elements** → Button inside a link (or vice versa) breaks semantics

---

**This skill ensures every web interface built is perceivable, operable, understandable, and robust for the widest range of users, meeting WCAG 2.2 AA as the minimum standard.**
