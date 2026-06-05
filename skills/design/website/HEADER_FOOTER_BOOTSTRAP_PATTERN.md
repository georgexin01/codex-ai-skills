---
name: header-footer-bootstrap-pattern
description: "Canonical pattern for responsive site headers and footers in PHP/HTML/CSS websites. Pairs Bootstrap 5.3 grid + utility classes with custom CSS overrides. Keeps the primary nav on ONE line at every breakpoint (min-width: max-content + flex-nowrap). Footer uses Bootstrap col-12 / col-md-6 / col-lg-3 stacking. Includes the exact 4-breakpoint media-query layer (1280 / 1024 / 768 / 560). Used in: ecoworld project 2026-05-11."
type: skill
tier: 2
phase: 04-php-modularization
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "04-php-modularization/skill.md"
  - "06-component-engineering/skill.md"
  - "ECOWORLD_COLOR_SYSTEM.md"
version: 1.0
date: 2026-05-11
status: authoritative
triggers:
  - "header design"
  - "footer design"
  - "responsive header"
  - "responsive footer"
  - "navigation on one line"
  - "bootstrap grid php"
  - "site nav breakpoint"
  - "footer col-12 col-md col-lg"
---

# Header & Footer — Bootstrap-Grid + Custom-CSS Pattern

> When the user wants modern, fast, multi-breakpoint responsive header and footer in a PHP/HTML website, follow this pattern. Bootstrap 5.3 supplies grid + utility classes; custom CSS in `css/style.css` supplies the brand visual layer. Project-validated in `ecoworld` 2026-05-11.

## 1. Loading order (critical)

In `lib/htmlHead.php` (or equivalent shared head), load Bootstrap CSS **before** your custom `style.css` so custom tokens always win:

```html
<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH"
      crossorigin="anonymous">
<link rel="stylesheet" href="/css/style.css">
```

**Do NOT** load Bootstrap JS unless you need its components (collapse/dropdown/modal). Keep the project's own JS for the mobile-nav toggle.

## 2. Header markup pattern

```php
<header class="site-header d-flex align-items-center justify-content-between gap-3" data-header>
  <a class="brand flex-shrink-0" href="/" aria-label="Brand home">
    <img src="/images/logo.jpg" alt="Brand logo">
  </a>
  <button class="nav-toggle d-lg-none" type="button" data-nav-toggle aria-label="Toggle navigation">
    <span></span><span></span><span></span>
  </button>
  <nav class="site-nav d-flex flex-nowrap align-items-center gap-1" data-site-nav aria-label="Primary navigation">
    <a class="text-nowrap<?= active('/') ?>" href="/">Discovery</a>
    <a class="text-nowrap<?= active('/available-units') ?>" href="/available-units">Available Units</a>
    <!-- ... -->
  </nav>
</header>
```

Bootstrap utilities doing real work:

| Class | Effect |
|---|---|
| `d-flex` on header + nav | enables flex layout |
| `align-items-center` | vertical centering |
| `justify-content-between` | logo left, nav right |
| `gap-3` | 1rem gap between brand + nav |
| `flex-shrink-0` on brand | logo never shrinks under pressure |
| `flex-nowrap` on nav | prevents wrap to 2nd row |
| `text-nowrap` on each link | each label is one line; no word-break |
| `d-lg-none` on hamburger | shown only below `lg` (992 px) |

## 3. Footer markup pattern (Bootstrap grid)

```php
<footer class="site-footer" id="contact">
  <div class="container-fluid px-0">
    <div class="row g-4 g-lg-5">
      <section class="footer-brand col-12 col-lg-6">…</section>
      <section            class="col-6 col-md-4 col-lg-2">…</section>
      <section            class="col-6 col-md-4 col-lg-2">…</section>
      <section            class="col-12 col-md-4 col-lg-2">…</section>
    </div>
  </div>
  <div class="footer-bottom d-flex flex-wrap justify-content-between gap-3">…</div>
</footer>
```

Column math:

| Breakpoint | Brand | Quick links | Discovery | Contact | Total |
|---|---|---|---|---|---|
| `<576` (mobile) | 12 | 12 | 12 | 12 | stacked |
| `≥576` xs+ | 12 | 6 | 6 | 12 | (brand full, links pair, contact full) |
| `≥768` md | 12 | 4 | 4 | 4 | brand full, 3 thirds below |
| `≥992` lg | 6 | 2 | 2 | 2 | 6+2+2+2=12 single row |

Tweak the col splits per project — the **pattern** is "brand wide + N narrow link columns" using `col-{n} col-md-{n} col-lg-{n}`.

## 4. The 4-breakpoint custom CSS layer (drop-in)

Add to `css/style.css` after your base styles:

```css
/* Header — always single-line nav */
.site-header   { flex-wrap: nowrap; }
.site-nav      { flex-wrap: nowrap !important; white-space: nowrap; min-width: 0; }
.site-nav a    { white-space: nowrap; min-width: max-content; flex-shrink: 0; }

/* >=1280 — premium spacing */
@media (min-width: 1280px) {
  .site-header { padding: 18px clamp(32px, 4vw, 72px); gap: 32px; }
  .brand       { width: 240px; }
  .site-nav a  { padding: 11px 18px; font-size: 14.5px; }
}

/* 1024–1279 — tighter */
@media (min-width: 1024px) and (max-width: 1279.98px) {
  .site-header { padding: 14px clamp(20px, 3vw, 40px); gap: 20px; }
  .brand       { width: 200px; }
  .site-nav a  { padding: 9px 12px; font-size: 13.5px; }
}

/* 768–1023 — horizontal-scroll strip (invisible scrollbar) */
@media (min-width: 768px) and (max-width: 1023.98px) {
  .site-header { padding: 12px 20px; gap: 16px; }
  .brand       { width: 170px; }
  .site-nav    { overflow-x: auto; scrollbar-width: none; }
  .site-nav::-webkit-scrollbar { display: none; }
  .site-nav a  { padding: 8px 10px; font-size: 13px; }
}

/* 560–767 — compact horizontal nav, still no hamburger */
@media (min-width: 560px) and (max-width: 767.98px) {
  .site-header { padding: 10px 14px; gap: 12px; }
  .brand       { width: 140px; }
  .site-nav    { overflow-x: auto; scrollbar-width: none; flex: 1 1 auto; min-width: 0; }
  .site-nav::-webkit-scrollbar { display: none; }
  .site-nav a  { min-height: 36px; padding: 6px 10px; font-size: 12.5px; }
}

/* <560 — hamburger drawer */
@media (max-width: 559.98px) {
  .site-header { padding: 10px 14px; min-height: 64px; }
  .brand       { width: 130px; }
  .nav-toggle  { display: block; width: 40px; height: 40px; flex-shrink: 0; }
  .site-nav    { position: fixed; top: 64px; right: 12px; left: 12px;
                 flex-direction: column; padding: 12px;
                 border: 1px solid var(--line-soft); border-radius: var(--radius-md);
                 background: var(--eco-white); box-shadow: var(--shadow-soft);
                 opacity: 0; pointer-events: none; transform: translateY(-8px);
                 transition: opacity 180ms ease, transform 180ms ease; }
  .site-nav.is-open { opacity: 1; pointer-events: auto; transform: translateY(0); }
  .site-nav a       { width: 100%; padding: 12px 14px; font-size: 14px; }
}

/* Footer column-stack visual rules */
.site-footer            { margin-top: 48px; padding: clamp(40px, 6vw, 80px) clamp(16px, 4vw, 64px) 32px; }
.site-footer .row > section { padding: 0 8px; }
.site-footer ul.list-unstyled { display: grid; gap: 10px; }
.footer-bottom           { margin-top: 36px; padding-top: 18px; border-top: 1px solid rgba(255,255,255,0.14); }

/* Per-breakpoint footer typography */
@media (min-width: 1280px) { .site-footer h2 { font-size: 56px; } }
@media (min-width: 1024px) and (max-width: 1279.98px) { .site-footer h2 { font-size: 44px; } }
@media (min-width: 768px)  and (max-width: 1023.98px) { .site-footer h2 { font-size: 36px; } }
@media (min-width: 560px)  and (max-width: 767.98px)  { .site-footer h2 { font-size: 30px; } }
@media (max-width: 559.98px)                          { .site-footer h2 { font-size: 26px; line-height: 1.1; } .footer-bottom { flex-direction: column; align-items: flex-start; } }

/* Bootstrap conflict suppressors — keep custom typography winning */
body        { font-family: Inter, Arial, system-ui, sans-serif; }
h1, h2, h3  { font-family: Georgia, "Times New Roman", serif; }
a           { color: inherit; text-decoration: none; }
.site-footer .list-unstyled { padding-left: 0; margin-bottom: 0; }
```

## 5. Why `min-width: max-content` matters

Without it, when the viewport is narrow:

- `flex-shrink: 1` (default) lets the browser shrink each `<a>` element width below the natural text width
- Text inside the `<a>` then **wraps to two lines** (e.g. "Available" / "Units")
- Result: ragged nav, broken visual rhythm

With `min-width: max-content` + `text-nowrap` + `flex-shrink: 0`:

- Each link refuses to shrink narrower than the longest single line of its text content
- If the sum of widths exceeds container, the parent `.site-nav` becomes `overflow-x: auto` and the user scrolls
- Scrollbar is hidden via `scrollbar-width: none` for clean visuals

## 6. Why Bootstrap Grid here (and not 100% custom)

| Decision | Reason |
|---|---|
| Use Bootstrap **grid + utility classes** | Industry-standard column math (`col-12 col-md-6 col-lg-3`) that everyone reading the code recognizes. ~50 KB gzip. |
| Skip Bootstrap **components** (cards, modals, navbars) | They have opinionated visuals that conflict with the EcoWorld brand. Build those in custom CSS. |
| Skip Bootstrap **JS bundle** | Project already has its own mobile-nav toggle JS. No need for collapse/dropdown components. |
| Keep custom `style.css` as the **last** stylesheet | All overrides land naturally without `!important` (except 1 specific `flex-nowrap` override to defeat utility specificity). |

## 7. Sister-pattern hooks

- **Filter chip row scrollbar** — same `scrollbar-width: none` + `::-webkit-scrollbar { display: none }` technique. See [ECOWORLD_COLOR_SYSTEM.md §9](ECOWORLD_COLOR_SYSTEM.md#9-modern-polish-layer-2026-05-11-update).
- **Category color tokens** — used by header active-link state and footer brand stripe. See [ECOWORLD_COLOR_SYSTEM.md §3](ECOWORLD_COLOR_SYSTEM.md#3-lifestyle-category-palette-the-new-layer).
- **Free image generation** — hero/banner photos that sit below the header come from this pipeline. See [IMAGE_GENERATION_FREE.md](IMAGE_GENERATION_FREE.md).

## 8. Anti-patterns

- ❌ Loading Bootstrap **after** custom CSS — your overrides lose to Bootstrap's utilities.
- ❌ Letting nav links shrink/wrap to a second line — kills the editorial property feel.
- ❌ Showing the OS scrollbar on the horizontally scrolling nav (560–1023 px range).
- ❌ Replacing the serif heading font with Bootstrap's default system-ui — the brand identity dies.
- ❌ Skipping the `lib/htmlHead.php` preconnect to `cdn.jsdelivr.net` — slower TTFB on the very first visit.

## 9. Verification record

- 2026-05-11 — Applied to `ecoworld` project. Header tested at viewport widths 320, 412 (S20 Ultra), 560, 768, 1024, 1280, 1440, 1920. Nav stayed on one line at every breakpoint ≥560 px; collapsed to drawer at <560 px. Footer columns reflowed at md (≥768) and lg (≥992) per Bootstrap's native breakpoints.

---

*Created 2026-05-11 by Claude (Opus 4.7, 1M context) during EcoWorld project. Pairs with `ECOWORLD_COLOR_SYSTEM.md` (color tokens) and `IMAGE_GENERATION_FREE.md` (visuals).*

