---
name: design-md-export-guide
description: Recipes for deriving tailwind.config.js, CSS variables, Vue/Vite tokens, and DTCG JSON from a DESIGN.md.
triggers: ["export design tokens", "tailwind from design.md", "css variables from design.md", "dtcg export"]
version: 1.0
---

# DESIGN.md → Code Export Guide

Single source. Multiple targets. Re-run anytime tokens change.

## Targets (priority order)

1. **`tailwind.config.js`** — primary target for Vue/React/static-HTML projects
2. **CSS variables (`:root` in `app.css` or `tokens.css`)** — for PHP/vanilla websites, dark-mode swaps
3. **`design_tokens.json`** (DTCG format) — interoperability with Figma/Style Dictionary
4. **Vue 3 composable / Pinia module** — runtime access in app projects
5. **PHP constants (`config/design.php`)** — server-rendered website projects

## 1. Tailwind v3 (CommonJS)

Map every frontmatter group → tailwind `theme.extend` key:

| DESIGN.md key | tailwind.config.js key |
|---|---|
| `colors.*` | `theme.extend.colors` |
| `typography.*.fontSize` + `lineHeight` + `fontWeight` + `letterSpacing` | `theme.extend.fontSize` (3-tuple form) |
| `typography.*.fontFamily` | `theme.extend.fontFamily` |
| `rounded.*` | `theme.extend.borderRadius` |
| `spacing.*` | `theme.extend.spacing` |
| `components.*` | **skip** — Tailwind composes from primitives |

**Why skip components?** Tailwind's utility-first model expresses component tokens as classes (`bg-primary text-on-primary rounded-lg`). Component blocks live in Vue/PHP templates, not config.

Working example: [examples/atmospheric-glass/tailwind.config.js](examples/atmospheric-glass/tailwind.config.js).

### Tailwind v4 (CSS-first)

Use `@theme` block in your main CSS:
```css
@theme {
  --color-primary: #1a1c1e;
  --color-on-primary: #ffffff;
  --font-display-lg: "Inter", sans-serif;
  --text-display-lg: 84px;
  --text-display-lg--line-height: 90px;
  --text-display-lg--letter-spacing: -0.04em;
  --text-display-lg--font-weight: 700;
  --radius-lg: 1rem;
  --spacing-gutter: 16px;
}
```

## 2. CSS variables (vanilla / PHP)

For PHP/HTML projects (your `website` skill), emit a single `css/tokens.css` mirroring frontmatter:

```css
:root {
  /* colors */
  --color-primary: #1a1c1e;
  --color-on-primary: #ffffff;
  --color-surface: #0b1326;
  /* typography */
  --font-headline-lg: "Inter", sans-serif;
  --text-headline-lg: 32px;
  --text-headline-lg-line-height: 40px;
  --text-headline-lg-weight: 600;
  /* radii */
  --radius-lg: 1rem;
  --radius-xl: 1.5rem;
  /* spacing */
  --space-gutter: 16px;
  --space-section-margin: 40px;
}

/* dark mode swap (optional) — same keys, different palette */
[data-theme="dark"] {
  --color-primary: #ffffff;
  --color-surface: #121318;
}
```

Then in component CSS:
```css
.btn-primary {
  background: var(--color-primary);
  color: var(--color-on-primary);
  border-radius: var(--radius-lg);
  padding: 0 var(--space-md);
  font-family: var(--font-label-md);
  font-size: var(--text-label-md);
}
```

## 3. DTCG JSON

Already produced as `design_tokens.json` in every example folder. Use directly with:
- Style Dictionary (`style-dictionary build`)
- Figma Tokens plugin (import)
- Tokens Studio

Each token wraps `$type` + `$value`:
```json
"primary": {
  "$type": "color",
  "$value": { "colorSpace": "srgb", "components": [0.1, 0.11, 0.12], "hex": "#1a1c1e" }
}
```

## 4. Vue 3 composable

```js
// src/composables/useDesignTokens.js
import tokens from '@/../DESIGN.md?frontmatter'  // or import JSON

export function useDesignTokens() {
  return {
    color: (path) => resolveRef(tokens.colors, path),
    space: (key) => tokens.spacing[key],
    radius: (key) => tokens.rounded[key],
  }
}
```

Use a Vite plugin like `vite-plugin-markdown` with `mode: ['toc', 'frontmatter']` to parse YAML at build time.

## 5. PHP constants

```php
<?php // config/design.php — generated from DESIGN.md
return [
  'colors' => [
    'primary' => '#1a1c1e',
    'on-primary' => '#ffffff',
    // ...
  ],
  'spacing' => ['gutter' => '16px', 'section-margin' => '40px'],
];
```

Include in `lib/head.php` to emit `<style>:root{...}</style>` server-side.

## Regeneration workflow

1. Edit `DESIGN.md` (single file).
2. Run `LINT_CHECKLIST.md` 7 rules.
3. Regenerate every downstream target above that the project uses.
4. Commit `DESIGN.md` + every regenerated file in one commit. Never hand-edit downstream files.

## Anti-patterns ❌

- Editing `tailwind.config.js` without updating `DESIGN.md` → token drift
- Hardcoding hex values in Vue/PHP templates → not portable to dark mode
- Inventing new token names in component CSS → orphans the design system
- Skipping `on-X` text colors when adding a `X` background → accessibility regression

## See also

- [LINT_CHECKLIST.md](LINT_CHECKLIST.md) — validate before exporting
- [examples/atmospheric-glass/](examples/atmospheric-glass/) — full DESIGN.md → tailwind.config.js → DTCG roundtrip
