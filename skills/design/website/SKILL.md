---
name: premium-website-design
description: "V2.0 Sovereign Premium Website Design Protocol — 13-step framework for building beautiful, cinematic, and professional PHP/HTML/CSS websites."
triggers: ["website design", "premium ui", "new page design", "redesign section", "carnews design", "refit template", "blueprint study"]
version: 2.0
status: authoritative
---

# 🎨 Sovereign Website Design — THE MASTER INTRODUCTION

> [!IMPORTANT]
> **MANDATORY PROTOCOL**: This document is the Tier-0 entry point for all website design tasks. AI must read this introduction **line-by-line** before accessing individual step skills. These rules are absolute and override any conflicting chat instructions.

---

## 🎯 Purpose
To transform raw ideas into "WOW" factor websites using a disciplined, multi-phase design flow. We specialize in building **Cinematic, Industrial, and SEO-hardened** portals using PHP, HTML5, and Vanilla CSS.

---

## 🧬 Tier-0 Design Contract (MUST FOLLOW — Added 2026-05-18)

> **If `DESIGN.md` exists at project root, it is the SOLE source of truth for design tokens.**
> Tailwind config, `css/tokens.css`, PHP `config/design.php`, and component CSS MUST derive from it.
> On conflict: `DESIGN.md` wins; downstream code is regenerated.
> Spec + examples + lint: [`../_spec/SKILL.md`](../_spec/SKILL.md)
> Reference exemplars: [`atmospheric-glass`](../_spec/examples/atmospheric-glass/) (glass surfaces), [`paws-and-paths`](../_spec/examples/paws-and-paths/) (playful warm), [`totality-festival`](../_spec/examples/totality-festival/) (cinematic dark cosmic).

## 🧬 Tier-0 Website Principles (MUST FOLLOW)

| Principle | Rule | Implementation |
|---|---|---|
| **Sovereign Punctuation** | Heading Hierarchy. | Sub-label (0.8rem uppercase) + Bold Title (2.2rem) with a terminating dot (`.`). |
| **Tactile Texture** | Beyond Flat Color. | Use `linen` textures or `bg-1.jpg` patterns for warmth. No plain #fff sections. |
| **Gold Gradient Token** | Themed Accents. | Copper → Bronze → Cocoa (`#c08c50` → `#91602b` → `#2a1d0c`). |
| **8pt Spacing** | Mathematical Harmony. | All `padding`, `margin`, and `gap` must be multiples of 8. |
| **Tactile Response** | Physicality in UI. | Every button MUST have `active:scale-95` feedback. |
| **Masonry Stability** | Synthetic Layout. | Trigger `window.dispatchEvent(new Event('resize'))` after filtering masonry. |
| **Inventory Fidelity** | Structural Stability. | Always copy exact HTML classes/AOS attrs when refitting template sections. |

---

## 🧭 The 13-Step Industrial Routing
*Follow these steps in strict sequential order (01 → 13).*

### Phase 1: Foundation
1.  **[01-Handshake-Genesis](01-handshake-genesis/skill.md)**: Align mission, project DNA, and audience.
2.  **[02-Asset-Orchestration](02-asset-orchestration/skill.md)**: Generate high-res hero visuals and HSL tokens.

### Phase 2: Structural Mapping
3.  **[03-Inventory-Mapping](03-inventory-mapping/skill.md)**: Create the Reuse Map (Legacy Class -> Sovereign Role). **Consume `DESIGN.md` tokens** — derive `tailwind.config.js` + `css/tokens.css` per [`../_spec/EXPORT_GUIDE.md`](../_spec/EXPORT_GUIDE.md); never hand-write hex values when a token exists.
4.  **[04-PHP-Modularization](04-php-modularization/skill.md)**: Extract `lib/` components (header, footer, head).

### Phase 3: UI & Motion
5.  **[05-Hero-Cinematics](05-hero-cinematics/skill.md)**: Implement the V2.0 "No-Overlay" video-first hero.
6.  **[06-Component-Engineering](06-component-engineering/skill.md)**: Build 3D tactile cards and glass panels.
7.  **[07-Motion-Design](07-motion-design/skill.md)**: Apply GSAP ScrollTrigger and CSS micro-animations.

### Phase 4: Hydration & SEO
8.  **[08-Hydrogen-Hydration](08-hydrogen-hydration/skill.md)**: Map PHP `$Hydrogen` arrays to UI slots.
9.  **[09-SEO-Hardening](09-seo-hardening/skill.md)**: Metadata saturation and JSON-LD schema injection.
10. **[10-Responsive-Audit](10-responsive-audit/skill.md)**: Touch-first mobile refinement and viewport safety.

### Phase 5: Governance
11. **[11-Governance-Scan](11-governance-scan/skill.md)**: Verify **Hidden Content Policy** compliance.
12. **[12-Performance-Tuning](12-performance-tuning/skill.md)**: Minification, lazy loading, and speed audit.
13. **[13-Handover-Walkthrough](13-handover-walkthrough/skill.md)**: Final report and visual summary.

---

## 🛡️ Sovereign Guardrails
- **GOVERNANCE FIRST**: Never surface sensitive visa/influence goals in code or comments.
- **NO PLACEHOLDERS**: Use `generate_image` for any missing asset immediately.
- **STEP-BY-STEP ONLY**: Do not skip to Step 05 without completing Steps 01-04.

---
*Reference: [Global Tier-0 Protocol](../TIER_0_PROTOCOL.md)*

---

## Codex PHP Website Structure Addendum

When building PHP websites for this user, follow these mandatory structure and performance rules after the blueprint step:

1. Study reference website folders before coding when they are provided, especially `website-LAA-website` and `website-LAA-agent`.
2. Use the PHP website structure: `index.php` for route registration, `router.php` for clean routes, `template/` for page bodies, `lib/` for shared layout/components, and `api/database.php` for hardcoded dummy data when no real database is requested.
3. Keep assets in root-style website folders: `css/`, `js/`, `images/`, `uploads/`, and `favicon/` unless an existing project structure already requires another convention.
4. For image-heavy websites, create image slots and generation prompts before generating assets. Store generated outputs under `uploads/generated/<slot>/` and keep CSS-art fallbacks until real images exist.
5. For large masonry pages, never render all items immediately. Render a small first batch, lazy load images, append more cards on scroll or button click, and dispatch `window.dispatchEvent(new Event('resize'))` after each batch/filter refresh.
6. Every normal website must include complete navigation and a real footer with `ul/li` link groups, contact details, source/prototype notes, and responsive stacking.
7. Record project-specific structure decisions, routes, data source rules, image-generation slots, and validation results in `BLUEPRINT.md`.

## Free Visual Asset Fallback Addendum

When the user asks for generated images or a more graphical website but the active agent has no working image-generation tool/API billing, do not stop at placeholders. Read and apply:

`C:\Users\user\.codex\skills\normal\design\FREE_VISUAL_ASSET_SOURCING.md`

Mandatory behavior:

1. First try project-owned/client assets.
2. If no image API is available, use free stock-photo sourcing, Google Material Symbols, SVG, and CSS art as the visual-generation fallback.
3. For PHP websites, download/cache reusable images into `uploads/generated/<slot>/` when possible, and map them cyclically across large catalogs instead of requiring hundreds of unique images.
4. Keep source/license notes in `uploads/generated/IMAGE_SOURCES.md` or `BLUEPRINT.md`.
5. Never imply stock images are real client/project photos unless client-approved.
6. Keep removable HTML/CSS watermarks separate from the image file.

## Project-validated Companion Patterns (2026-05-12)

These four reference patterns are derived from the EcoWorld 400-unit prototype. They are **drop-in** — copy markup + CSS + (where needed) JS into a fresh project, swap the brand tokens, and ship. Each has its own dedicated skill file with anti-patterns and rationale:

| Pattern | File | When to apply |
|---|---|---|
| **Lifestyle detail page — pure display, no tabs** | [LIFESTYLE_DETAIL_PURE_DISPLAY.md](LIFESTYLE_DETAIL_PURE_DISPLAY.md) | Property / product / unit detail pages with 5+ category sub-sections (Food/Living/Shopping/Transport/Leisure or similar). Replaces tabbed UI with single-scroll display. |
| **Draggable slideshow + soft-gradient copy** | [DRAGGABLE_SLIDESHOW_PATTERN.md](DRAGGABLE_SLIDESHOW_PATTERN.md) | Full-bleed 60/40 detail hero. Pointer/touch drag, autoplay 5 s, dot nav, keyboard, prefers-reduced-motion. Zero JS deps. |
| **Scroll fade-in (with masonry-page exclusion)** | [SCROLL_FADEIN_PATTERN.md](SCROLL_FADEIN_PATTERN.md) | IntersectionObserver-based fade for content-led pages. Path-excludes masonry / lazy-load pages to avoid double-animation. Drop-in CSS + 25 lines of vanilla JS. |
| **Contact page — glass form + info stack + map** | [CONTACT_FORM_PATTERN.md](CONTACT_FORM_PATTERN.md) | Production-grade Contact page. Glass card with gold top stripe, mint focus halo, custom green chevron select, info-card stack with tinted icon tiles, neutral-white social card, rounded Google Maps iframe. Bootstrap grid w/ optional `order-lg-*` swap. |

Companion to the existing colour and layout patterns:

- [ECOWORLD_COLOR_SYSTEM.md](ECOWORLD_COLOR_SYSTEM.md) — palette, §9 modern polish, §10 unified-mint chip active, §11 image-led region cards, §12 "Powered by EcoWorld" frosted caption.
- [HEADER_FOOTER_BOOTSTRAP_PATTERN.md](HEADER_FOOTER_BOOTSTRAP_PATTERN.md) — Bootstrap 5.3 grid + 4-breakpoint custom CSS for nav and footer.
- [IMAGE_GENERATION_FREE.md](IMAGE_GENERATION_FREE.md) — Pollinations.ai image pipeline (no API key, no billing).

**Recommended read order for a fresh EcoWorld-derived project**: SKILL.md → ECOWORLD_COLOR_SYSTEM.md → HEADER_FOOTER_BOOTSTRAP_PATTERN.md → (page-specific) one of the four companion patterns above → IMAGE_GENERATION_FREE.md.
