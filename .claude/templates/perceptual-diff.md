# Perceptual Diff Pattern

Visual verification for UI changes. Agents can't catch 2px misalignments from code alone — feed them the diffs.

---

## The Problem

Multimodal agents can see screenshots, but they won't catch subtle visual regressions unless you:
1. Show them the **before/after diff**
2. Let them **zoom in** to specific regions
3. Run a **locality test** to verify no unintended side-effects

## Perceptual Diff Workflow

```bash
# 1. Take baseline screenshots
npx playwright test --update-snapshots

# 2. Make changes...

# 3. Run tests and collect diffs
npx playwright test

# 4. Find changed screenshots
git diff --name-only -- "*.png"

# 5. Feed diffs to the agent for review
# Multimodal models are more accurate at higher zoom levels
```

## Locality Test

Verifies that changes happened **only** where intended:

1. Agent declares the CSS selector of the expected change
2. Take **pre** and **post** screenshots
3. Mask the declared area → `pre_masked`, `post_masked`
4. Assert:
   - `pre ≠ post` (change happened)
   - `pre_masked == post_masked` (no unintended side-effects)
5. Feed perceptual diff + DOM diff to agent on failure

## System Prompt Addition

Add to CLAUDE.md or agent instructions when working on UI:

```
When modifying UI components:
1. Take a screenshot before changes
2. Make your changes
3. Take a screenshot after changes
4. Compare: verify only the intended area changed
5. If unintended changes detected, rollback and retry
```

## Which Agents Use This

- `@responsive-reviewer` - Cross-device layout verification
- `@theme-reviewer` - Color contrast and mode switching verification
- `@ux-accessibility-reviewer` - Visual accessibility verification
- `@programmer` - When implementing UI features

---

**Source**: Alejandro Vidal, "Agentic Engineering" (Perceptual Diffs + Locality Test) - HACKNIGHT Valencia 2026
**Updated**: 2026-03-10 | **Version**: 7.1.0
