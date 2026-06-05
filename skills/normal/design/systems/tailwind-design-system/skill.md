---
name: tailwind-design-system
description: "Build scalable design systems with Tailwind CSS, design tokens, component libraries, and responsive patterns. Use when creating component libraries, implementing design systems, or standardizing UI..."
triggers: ["tailwind design system", "tailwind-design-system"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
risk: "unknown"
source: "community"
date_added: "2026-02-27"
_inner_frontmatter: |-
  name: tailwind-design-system
  description: "Build scalable design systems with Tailwind CSS, design tokens, component libraries, and responsive patterns. Use when creating component libraries, implementing design systems, or standardizing UI..."
  risk: unknown
  source: community
  date_added: "2026-02-27"
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: SKILL
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# Tailwind Design System

Build production-ready design systems with Tailwind CSS, including design tokens, component variants, responsive patterns, and accessibility.

## Use this skill when

- Creating a component library with Tailwind
- Implementing design tokens and theming
- Building responsive and accessible components
- Standardizing UI patterns across a codebase
- Migrating to or extending Tailwind CSS
- Setting up dark mode and color schemes

## Do not use this skill when

- The task is unrelated to tailwind design system
- You need a different domain or tool outside this scope

## Instructions

- Clarify goals, constraints, and required inputs.
- Apply relevant best practices and validate outcomes.
- Provide actionable steps and verification.
- If detailed examples are required, open `resources/implementation-playbook.yaml`.

## Resources

- `resources/implementation-playbook.yaml` for detailed patterns and examples.

## Mobile Form-Component Pattern Library (carMVP feedback, 2026-05-08)

When building mobile-first templates with Tailwind v4 + Vue 3, the **9-component stack** below replaces all third-party UI libraries. Use Headless UI Vue (`@headlessui/vue`) for primitives + `class-variance-authority` (CVA) for variant typing.

### Stack
- `@headlessui/vue` 1.7+ — Listbox (select), RadioGroup, Switch
- `class-variance-authority` ~0.7 — typed variant tables
- `@vueuse/core` 11+ — only when needed (debounce, IntersectionObserver, etc.)
- `@internationalized/date` 3+ — only when free-form date is required (booking 7-day chip-grid does NOT need it)

### The 9 components

#### `AppButton` (CVA primary pattern)
```ts
const button = cva(
  'inline-flex items-center justify-center font-bold transition-all duration-150 active:scale-[0.98] disabled:opacity-50 select-none gap-2 whitespace-nowrap',
  {
    variants: {
      variant: {
        primary:   'bg-(--color-primary) text-(--color-ink) shadow-card active:bg-(--color-primary-pressed)',
        red:       'bg-(--color-accent-red) text-white active:bg-(--color-accent-red-dark)',
        secondary: 'bg-white border border-(--color-border) text-(--color-ink) active:bg-(--color-snow)',
        ghost:     'bg-transparent text-(--color-ink) active:bg-(--color-snow)',
        dark:      'bg-(--color-ink) text-white active:bg-(--color-ink-soft)',
        link:      'bg-transparent text-(--color-trust-fg) underline-offset-2 active:underline',
      },
      size: {
        sm:    'h-9 px-4 text-[13px] rounded-full',
        md:    'h-11 px-5 text-[14px] rounded-full',
        lg:    'h-12 px-6 text-[15px] rounded-full',
        block: 'h-12 w-full text-[15px] rounded-full',
        icon:  'size-11 rounded-full',
      },
    },
    defaultVariants: { variant: 'primary', size: 'md' },
  },
)
```

#### `AppInput` shape
- 48px-tall pill `rounded-2xl` with leading material-symbol icon + trailing icon slot.
- `border-(--color-border)` default → `border-(--color-primary)` on focus → `border-(--color-error) bg-red-50` on error.
- `tabular-nums` (`tnum`) class on monetary inputs.

#### `AppSelect`
- Headless `Listbox` underneath.
- Trigger: 48px button with optional leading icon + truncate label + chevron.
- Panel: `absolute z-30 max-h-72 overflow-auto rounded-2xl bg-white shadow-card-hover` with selected row in `text-(--color-accent-red) font-bold`.

#### `AppDatePicker` (7-day chip grid)
- Renders next N days (default 7) as `aspect-square rounded-xl` chips.
- Today marked with `ring-2 ring-(--color-accent-red)/40`.
- Selected: `bg-(--color-primary) text-(--color-ink) font-bold shadow-card`.
- Skip date libraries entirely for booking flows.

#### `AppCheckbox`
- 5×5 `rounded-md` border-2 box; on-state `bg-(--color-primary) border-(--color-primary)` with hand-drawn svg polyline tick.
- ALWAYS wrap with `<div>` + `@click.stop` (NOT `<label>`) when paired with inline T&C links.

#### `AppSwitch`
- 11×6 `rounded-full`; on `bg-(--color-success)`, off `bg-(--color-border-strong)`.
- Thumb: `size-5 rounded-full bg-white shadow` translating `left-0.5` ↔ `left-5`.

#### `AppRangeSlider`
- Native `<input type="range">` overlaid `opacity-0` on top of a styled track.
- Track: `h-1.5 rounded-full bg-(--color-border)` + filled portion `bg-(--color-primary)`.
- Thumb: `size-5 rounded-full bg-white shadow border-2 border-(--color-primary)` positioned via `style="left: calc(N% - 10px)"`.

#### `AppChip`
- Three variants × two sizes. Active state drives a `computed`, never decorative.
- Default active: `bg-(--color-ink) text-white`; yellow active: `bg-(--color-primary) text-(--color-ink)`; red active: `bg-(--color-accent-red) text-white`.

#### `AppImage`
- `<img>` wrapped with `loading="lazy" decoding="async"` + `@error` handler swapping to inline-SVG fallback.
- NO raw `<img>` allowed in views.

### Reference implementation
[`c:/Users/user/Desktop/carMVP/template/src/components/`](c:/Users/user/Desktop/carMVP/template/src/components/) — 9 files, all <200 lines, zero external UI library imports beyond Headless UI Vue.

### Hard rules
- ❌ Don't use Element Plus / Naive UI / Vant 4 alongside this stack.
- ❌ Don't put hex codes in components — go through `@theme` CSS variables.
- ❌ Don't use `<label>` wrapping for inline-link checkboxes.
- ❌ Don't ship raw `<img>` — always `<AppImage>`.

