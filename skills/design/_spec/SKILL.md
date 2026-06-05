---
name: design-md-spec
description: "DESIGN.md format — single source-of-truth design contract per project. YAML token frontmatter + markdown rationale. Imported from google-labs-code/design.md (Apache-2.0)."
triggers: ["design.md", "design token contract", "design system file", "design tokens spec", "tailwind tokens", "design tokens json", "DTCG"]
version: 1.0
status: authoritative
upstream: "https://github.com/google-labs-code/design.md"
license: "Apache-2.0 — see UPSTREAM_LICENSE.txt"
---

# 🎨 DESIGN.md — The Contract Layer

> [!IMPORTANT]
> **TIER-0 RULE — when this file exists at project root, it is the SOLE source of truth for design tokens.**
> Tailwind config, CSS variables, PHP/HTML styles, and Vue component styles MUST derive from it.
> On conflict: `DESIGN.md` wins; code is regenerated from it.

This skill adds a **contract layer** on top of the existing procedural design playbooks:

- [`design/app/`](../app/SKILL.md) — 9-step app design execution
- [`design/website/`](../website/SKILL.md) — 13-step website design execution
- [`design/_spec/`](.) — **the contract** (this skill)

The execution skills consume the contract. The contract is portable across stacks (Vue, PHP, Tailwind v3/v4, DTCG).

## What is DESIGN.md?

One file at project root. Two layers:

1. **YAML frontmatter** — machine-readable tokens
   ```yaml
   ---
   version: alpha
   name: My App
   colors: { primary: "#1A1C1E", ... }
   typography: { display: { fontFamily: Inter, fontSize: 84px, ... } }
   rounded: { sm: 0.25rem, lg: 1rem, ... }
   spacing: { unit: 8px, gutter: 16px, ... }
   components:
     button-primary:
       backgroundColor: "{colors.primary}"
       textColor: "{colors.on-primary}"
       typography: "{typography.label-md}"
       rounded: "{rounded.lg}"
   ---
   ```

2. **Markdown body** — human-readable rationale in canonical section order:
   1. Overview (brand personality, emotional response)
   2. Colors (primary palette + additional palettes)
   3. Typography (font levels with semantic categories)
   4. Layout (grid + spacing strategy)
   5. Elevation & Depth (how hierarchy is created)
   6. Shapes (corner radius approach)
   7. Components (UI elements + variants)
   8. Do's and Don'ts (practical guidelines)

Token references use `{path.to.token}` dot-notation.

## Files in this skill

| File | Purpose |
|---|---|
| `SKILL.md` | This entry point — routing + Tier-0 rule |
| `UPSTREAM_SPEC.md` | Full upstream spec from google-labs-code/design.md (verbatim) |
| `UPSTREAM_LICENSE.txt` | Apache-2.0 license (upstream attribution) |
| `LINT_CHECKLIST.md` | 7 lint rules as a manual self-check (no CLI required) |
| `EXPORT_GUIDE.md` | Recipes — DESIGN.md → tailwind.config.js / CSS vars / Vue tokens |
| `examples/atmospheric-glass/` | Glassmorphism reference (dark, frosted, multi-blur elevation) |
| `examples/paws-and-paths/` | Playful mobile reference (warm amber + blue, friendly radii) |
| `examples/totality-festival/` | Bold cinematic reference (cosmic dark + gold + cyan glow) |

Each example folder contains `DESIGN.md` + `design_tokens.json` (DTCG) + `tailwind.config.js`.

## When to load

- New project handshake (app or website) → produce `DESIGN.md` BEFORE assets/config
- Refactor of token system → diff old vs new `DESIGN.md`
- Color palette / typography revision → edit only `DESIGN.md`, regenerate code
- Cross-stack handover (Vue ↔ PHP ↔ Figma) → `design_tokens.json` is the bridge

## Cross-references

- Procedural app flow: [../app/SKILL.md](../app/SKILL.md) → Step 01 Handshake-Genesis produces this file
- Procedural website flow: [../website/SKILL.md](../website/SKILL.md) → Step 03 Inventory-Mapping consumes tokens
- Tier-0 kernel: [../../../memories/0_apex/GROUND_KERNEL.md](../../../memories/0_apex/GROUND_KERNEL.md)

## Attribution

Format spec + example design systems imported from [google-labs-code/design.md](https://github.com/google-labs-code/design.md) (Apache-2.0). See `UPSTREAM_LICENSE.txt`.
