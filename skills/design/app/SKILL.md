---
name: premium-app-design
description: "V1.1 Sovereign Premium App Design Protocol — 9-step framework for building tactile, high-density mobile web applications (Vue 3 + Capacitor)."
triggers: ["app design", "premium mobile ui", "new app project", "rider app design", "admin app design", "design only app"]
version: 1.1
status: authoritative
---

# 📱 Sovereign App Design — THE MASTER INTRODUCTION

> [!IMPORTANT]
> **MANDATORY PROTOCOL**: This document is the Tier-0 entry point for all mobile app design tasks. AI must read this introduction **line-by-line** before accessing individual step skills. These rules are absolute and override any conflicting chat instructions.

---

## 🎯 Purpose
To transform logistical requirements into "Premium & Tactile" mobile applications. We build high-density, one-handed mobile-first interfaces using Vue 3 and Capacitor.

---

## 🧬 Tier-0 Design Contract (MUST FOLLOW — Added 2026-05-18)

> **If `DESIGN.md` exists at project root, it is the SOLE source of truth for design tokens.**
> Tailwind config, CSS variables, Pinia design stores, and component styles MUST derive from it.
> On conflict: `DESIGN.md` wins; downstream code is regenerated.
> Spec + examples + lint: [`../_spec/SKILL.md`](../_spec/SKILL.md)
> Reference exemplars: [`atmospheric-glass`](../_spec/examples/atmospheric-glass/) (frosted glass elevation), [`paws-and-paths`](../_spec/examples/paws-and-paths/) (playful warm mobile), [`totality-festival`](../_spec/examples/totality-festival/) (cinematic dark).

## 🧬 Tier-0 App Principles (MUST FOLLOW)

| Principle | Rule | Implementation |
|---|---|---|
| **One-Handed UI** | Focus on the "Thumb Zone". | Prioritize bottom action buttons and fixed footers (78px). |
| **Absolute Overlay** | Curved Hero Skirt. | `.content` MUST be absolutely positioned (`inset: 102px 14px 0`) over curved `.hero`. |
| **Precision Scaling** | 6px Sleekness. | All progress bars and status lines MUST be exactly 6px height. |
| **Glass Overlays** | Materiality. | Use `backdrop-filter: blur(16px)` for bottom nav, modals, and toasts. |
| **Contrast Mandate** | Human Readability. | **MANDATORY**: No gray-on-gray. (e.g., Avoid light-gray buttons on gray footers). Use high-contrast tokens only. |
| **Weight Authority** | 700 is the Law. | Use 700 (Bold) for titles and labels. 900 is for KPI numbers ONLY. |
| **Safety Viewport** | Adapts to Real Hardware. | MUST use `width=device-width` in `index.html`. `width=412` is FORBIDDEN. |

### 🛡️ Viewport Safety Mandate
**Canonical viewport for all mobile web apps + PWAs:**
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, viewport-fit=cover" />
```
- **Forbidden**: `width=412`, `maximum-scale=1.0`, `user-scalable=no`.

### 🌐 SPA Routing Fallback (404 Refresh Fix)
Every build MUST include a fallback to `index.html` in the `public/` folder.
- **Apache/Cpanel**: `.htaccess` with mod_rewrite to `index.html`.
- **Vercel/Netlify**: `vercel.json` or `_redirects` mapping `/*` to `/index.html`.

---

## 🧭 The 9-Step Industrial Routing
*Follow these steps in strict sequential order (01 → 09).*

### Phase 1: Vision & Assets
1.  **[01-Handshake-Genesis](01-handshake-genesis/skill.md)**: Mission alignment and project blueprint sync. **MUST produce `DESIGN.md` at project root as the first artifact** — see [`../_spec/SKILL.md`](../_spec/SKILL.md) for format and [`../_spec/LINT_CHECKLIST.md`](../_spec/LINT_CHECKLIST.md) for the 7-rule validation gate before Step 02.
2.  **[02-Asset-Orchestration](02-asset-orchestration/skill.md)**: Generate high-density app icons (38px) and HSL tokens.

### Phase 2: Core Scaffolding
3.  **[03-Config-Hardening](03-config-hardening/skill.md)**: Vite/Tailwind setup + SPA 404 Routing Fix (`.htaccess`).
4.  **[04-Mock-State-Foundry](04-mock-state-foundry/skill.md)**: Create reactive Pinia stores for local simulation.

### Phase 3: UI & Interaction
5.  **[05-UI-Standardization](05-ui-standardization/skill.md)**: Apply the Stitch Protocol (Card = Button) and Tier-0 colors.
6.  **[06-View-Scaffolding](06-view-scaffolding/skill.md)**: Build high-density list/detail views with absolute overlays.
7.  **[07-Interaction-Polish](07-interaction-polish/skill.md)**: Micro-animations, GSAP flows, and tactile feedback.
8.  **[08-Asset-Orchestration](08-asset-orchestration/skill.md)**: Icon standardization, photography, and path resolution.
9.  **[09-Interactive-Routing](09-interactive-routing/skill.md)**: Smooth page transitions and mobile navigation logic.

---

## 🛡️ Sovereign Guardrails
- **DESIGN-FIRST**: Currently configured for Design-First (No API/Supabase). Use reactive `ref` variables.
- **TIER-0 CONTRAST**: Absolute mandate for high-contrast. No gray-on-gray text or buttons (e.g., light-gray on gray background).
- **SPA SAFETY**: Every build MUST include the `.htaccess` fallback in `public/`.

---
*Reference: [Global Tier-0 Protocol](../TIER_0_PROTOCOL.md)*

## Free Visual Asset Fallback

When an app design asks for generated images but no image-generation tool/API billing is working, read:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Use free stock imagery, Material Symbols/lucide icons, SVG, and CSS visuals to fill the app. Store downloaded prototype assets in `public/images/`, `src/assets/`, or `uploads/generated/`, and keep source/license notes. For avatars, use deterministic generated-avatar services or local SVG initials instead of broken image placeholders.
