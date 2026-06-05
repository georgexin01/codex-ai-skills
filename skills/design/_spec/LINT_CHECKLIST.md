---
name: design-md-lint-checklist
description: Seven manual lint rules to validate a DESIGN.md before declaring the design contract done. No CLI required.
triggers: ["lint design.md", "validate design tokens", "design audit", "wcag contrast check"]
version: 1.0
---

# DESIGN.md Lint Checklist

Run all seven before declaring a `DESIGN.md` complete. Each rule maps 1:1 to the upstream CLI in [google-labs-code/design.md](https://github.com/google-labs-code/design.md).

## 1. Section order ✅

Required sections, in this exact order:

1. Overview
2. Colors
3. Typography
4. Layout
5. Elevation & Depth
6. Shapes
7. Components
8. Do's and Don'ts

**Fail:** any section missing, duplicated, or out of order. **Fix:** reorder; never delete a required heading.

## 2. Missing primary ✅

`colors.primary` MUST exist and be a valid hex (`#RRGGBB` or `#RRGGBBAA`).

**Why:** every other component reference cascades from `{colors.primary}`. Missing it breaks export.

## 3. Missing typography ✅

At least one typography token MUST exist (typically `headline-lg`, `body-md`, `label-sm`).

Each typography object MUST have `fontFamily`, `fontSize`, `fontWeight`. `lineHeight` and `letterSpacing` are optional but recommended.

## 4. Broken references ✅

Every `{path.to.token}` reference MUST resolve to a real token.

**Check:** for each `{X.Y}` in `components:`, confirm `X.Y` exists in frontmatter.

Common breaks:
- `{colors.primary-container}` but only `primary` defined
- `{typography.label}` but token is named `label-md`
- `{spacing.lg}` but spacing uses `large`

## 5. Orphaned tokens ✅

Every token in `colors:` / `typography:` / `rounded:` / `spacing:` SHOULD be referenced somewhere (in `components:` or the markdown body).

**Warn (not fail)** on unreferenced tokens. They bloat the export.

## 6. WCAG contrast ratio ✅ (most-violated rule)

For every component with both `backgroundColor` and `textColor`:

- **Body text:** contrast ratio ≥ 4.5:1 (AA) — required
- **Large text (≥18px / ≥14px bold):** contrast ratio ≥ 3:1 (AA) — required
- **AAA target:** ≥ 7:1 for body, ≥ 4.5:1 for large

**Quick math:** use [webaim.org/resources/contrastchecker](https://webaim.org/resources/contrastchecker/) or any contrast calc.

**Tier-0 codex rule:** *no gray-on-gray.* If ratio < 4.5 between `surface-container` and `on-surface-variant` text, raise contrast.

## 7. Token summary ✅

Every `DESIGN.md` SHOULD end (or open in Overview) with a token count summary:

> 47 colors · 6 typography levels · 6 radii · 5 spacing scales · 9 components

**Why:** a glance tells reviewers the system size; sudden jumps in subsequent versions flag scope creep.

---

## Optional automated check

If `bun`/`npx` are available:
```bash
bunx @design-md/cli lint DESIGN.md
```
Returns same 7 rules as exit-coded errors. Not required — manual checklist is canonical for `.codex` workflows.

---

## Failure escalation

- **Hard fail** (rules 1–4, 6): block project from Step 02 (asset generation) until fixed.
- **Soft warn** (rules 5, 7): note in `BLUEPRINT.md` and continue.

See also: [EXPORT_GUIDE.md](EXPORT_GUIDE.md) for deriving tailwind config from a clean `DESIGN.md`.
