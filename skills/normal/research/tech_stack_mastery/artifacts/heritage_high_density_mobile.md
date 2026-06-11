---
name: heritage-high-density-mobile
description: "🥢 Heritage High-Density Mobile Blueprint"
triggers: ["heritage high density mobile", "heritage_high_density_mobile", "heritage high density"]
phase: reference
model_hint: gpt-5.3-codex
version: 42.0
_ohdy_wrapper: |-
  # OHDY COMPRESSED NODE (V42.0)
  <dna_node>
  v: 42.0
  n: heritage_high_density_mobile
  graph:
    req: []
    rel: []
  l: |-
  </dna_node>
---

# 🥢 Heritage High-Density Mobile Blueprint

This blueprint defines the "Wider Mobile" design language for premium Chinese heritage applications. It prioritizes maximizing screen real estate (high density) while maintaining a prestigious, traditional aesthetic.

## 🎨 Visual Identity (Tokens)

| Category | Token | Value / Logic |
| :--- | :--- | :--- |
| Primary | Heritage Red | `#9c1c2f` (Main), `#d6324a` (Light), `#8c192a` (Dark) |
| Accent | Imperial Gold | `#c8963e` |
| Background | Rice Beige | `#F5F5DC` |
| Typography | Sans Pair | `Plus Jakarta Sans`, `Noto Sans SC` |
| Typography | Serif Pair | `Noto Serif SC` (Used for headers/italic emphasis) |
| Corner Radius| Standard | `rounded-2xl` (16px) |
| Shadows | Subtle | `shadow-sm` for cards, `shadow-xl` for primary buttons |

## 📐 Layout Architecture

### 1. The "100% Flush" Mobile Rule
- Desktop: Max-width of `540px` centered with `mx-auto`.
- Mobile: The root container must have zero horizontal margins and zero horizontal padding. Content must touch the screen edges (375px/390px/412px).
- View-Level Padding: Standardize on `px-2` or `px-3` for all main view wrappers. Avoid `px-4` or `px-6` as they waste too much space on small devices.

### 2. High-Density Typography Overrides
- Global Shift: Reduce all Tailwind font sizes > 14px by exactly 1px.
    - `text-base` (16px) -> 15px
    - `text-lg` (18px) -> 17px
    - `text-xl` (20px) -> 19px
- Micro-Labels: Use `text-[7px]` or `text-[8px]` with `font-black` and `tracking-widest` for dashboard stats and category indicators.

### 3. Catalog & Grid Specs
- Sidebar: Remove fixed width. Allow width to be determined by button content padding (`px-2`).
- Content Gutters: Use `px-5` for the main product grid container.
- Grid Gap: Standardize on `gap-[8px]` (2-column layout).
- Card Padding: Use `p-3` for content areas, but `p-0` for the image container to keep it flush.

## ⚡ Interaction & Animation

- Preloader: Center card animation restricted to `w-40 h-40`.
- Gestures: Use `active:scale-95` on all buttons and cards for tactile feedback.
- Transitions: 200ms-300ms durations with `ease-out`.

## 📦 Persistence Pattern

- Auth Store: Always include an optional `email` field in the `User` interface.
- LocalStorage: Sync `user` object on every profile save (`JSON.stringify` to 'user').
- Header/Footer: Fixed heights (`h-56` header, `h-80` footer with safe area).

---
*Created from fu-huo-lao-app (2026-04-03) — The Golden Standard for High-Density Mobile Heritage Apps.*

