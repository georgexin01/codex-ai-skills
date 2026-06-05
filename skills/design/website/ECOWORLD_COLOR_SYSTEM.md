---
name: ecoworld-color-system
description: "Category-coded color palette and visual treatment for EcoWorld-style property discovery sites. Captures the 2026-05-11 redesign decision to swap minimalist book.ecoworld.my chrome for vibrant lifestyle category colors layered over the EcoWorld green identity."
type: reference
tier: 2
phase: design
applies_to: ["claude", "claude-code", "codex", "gemini"]
related: ["SKILL.md", "06-component-engineering/skill.md", "../TIER_0_PROTOCOL.md", "../../../knowledge/USER_DNA.md"]
version: 1.0
date: 2026-05-11
status: authoritative
triggers:
  - "ecoworld design"
  - "property discovery site"
  - "400 unit masonry"
  - "category color palette"
  - "lifestyle accent colors"
---

# 🎨 EcoWorld Color System — Lifestyle Category Palette

> Companion to `SKILL.md`. Use when the project is an EcoWorld-style **property discovery site with mixed lifestyle categories** (food / living / shopping / transport / leisure / residential / commercial). The minimalist grey/white of `book.ecoworld.my` is too sterile for a 400-unit discovery wall — viewers can't tell categories apart at a glance. This palette gives each lifestyle a recognizable color identity while keeping EcoWorld green as the brand anchor.

## 1. Reference

- Original site studied: `book.ecoworld.my/home` — minimalist grey/white chrome, image-led cards. Good *structure*, but **too monochrome** when 400 units need fast visual scanning.
- Live implementation: `c:\Users\user\Desktop\ecoworld\` (PHP/LAA-style structure).
- User taste anchor: [USER_DNA.md](../../../memories/0_apex/USER_DNA.md) — 700-weight headings, 6 px progress bars, glassmorphism, **zero gray-on-gray**, clickable cards over isolated buttons.

## 2. Anchor palette (preserved from original BLUEPRINT)

| Token | Hex | Role |
|---|---|---|
| `--eco-green-900` | `#063f24` | Brand-deep text, footer base |
| `--eco-green-800` | `#0b5a32` | Primary buttons |
| `--eco-green-700` | `#117a3d` | Eyebrow accent stroke |
| `--eco-green-600` | `#16843f` | Section underline |
| `--eco-green-500` | `#1c9a50` | "Living" / "Available" status |
| `--eco-gold-600`  | `#b88a2d` | Gold gradient anchor |
| `--eco-brown-700` | `#6d4b32` | Reserved status / brown surfaces |

## 3. Lifestyle category palette (the new layer)

Each category gets a **mid tone** (badges, dots, chip-active background) and a **soft tint** (meta-chip background, hover halo). Mid tones are tested against `--eco-white` (#fff) for AA contrast on white surfaces when used as 12 px label text on a 100-tint background. Always pair mid with a dark text token from the same hue family — **never** mid-on-soft-tint without checking contrast.

| Category | Mid | Soft tint | Dark text on tint | Mood |
|---|---|---|---|---|
| Food | `#e26a3c` | `#ffe6d9` | `#803519` | Warm sunset / dining |
| Living | `#1c9a50` | `#dff1e4` | `#063f24` | EcoWorld green / homes |
| Shopping | `#7c4fde` | `#ece2ff` | `#3d2189` | Royal violet / retail |
| Transport | `#2780d9` | `#d8eaff` | `#133e7c` | Sky blue / mobility |
| Leisure | `#d4a017` | `#fbeebd` | `#6b4f08` | Gold / parks |
| Residential | `#0f8e8e` | `#cdebeb` | `#054747` | Teal / high-rise |
| Commercial | `#9a704b` | `#efe1cf` | `#3a281b` | Warm brown / shop office |

CSS variables live at the top of `css/style.css`:

```css
--cat-food: #e26a3c;            --cat-food-100: #ffe6d9;
--cat-living: #1c9a50;          --cat-living-100: #dff1e4;
--cat-shopping: #7c4fde;        --cat-shopping-100: #ece2ff;
--cat-transport: #2780d9;       --cat-transport-100: #d8eaff;
--cat-leisure: #d4a017;         --cat-leisure-100: #fbeebd;
--cat-residential: #0f8e8e;     --cat-residential-100: #cdebeb;
--cat-commercial: #9a704b;      --cat-commercial-100: #efe1cf;
```

## 4. Themed gradients

```css
--grad-eco:   linear-gradient(135deg, #063f24 0%, #0b5a32 38%, #16843f 75%, #1c9a50 100%);
--grad-gold:  linear-gradient(135deg, #b88a2d 0%, #d4a017 50%, #ead29a 100%);
--grad-soft:  radial-gradient(120% 80% at 10% 10%, rgba(28,154,80,0.18), transparent 55%),
              radial-gradient(80% 60% at 90% 0%, rgba(212,160,23,0.16), transparent 60%);
```

- `--grad-eco` → footer accent, stat-number gradient text, hero deep band.
- `--grad-gold` → section kicker underline (6 px bar — USER_DNA mandate), footer border-image, secondary CTA `.button--gold`.
- `--grad-soft` → hero backdrop (white surface with green/gold corner glow blobs).

## 5. Application rules

1. **Status badges are colorful, not monochrome.** `Available`→green, `Limited`→gold, `New Launch`→food-orange, `Reserved`→shopping-violet, `Sold Out`→gray-850. Each ships with a `box-shadow: 0 6px 18px rgba(21,21,21,0.18)` lift.
2. **Card eyebrow gets a category dot.** `[data-category="X"] .eyebrow::before` swaps to the mid token. Eyebrow text stays `--eco-gray-700` for contrast.
3. **Filter chips colorize when active.** `.chip[data-filter="X"].is-active` → category mid background. Inactive chips stay neutral.
4. **Tactile lift.** All cards get `transform: translateY(-4px)` + `--shadow-lift` on hover, `scale(0.99)` on active — per TIER_0 "active:scale-95" mandate.
5. **Sovereign Punctuation.** Headings end with a gold "." (`h1::after`, `h2::after { content: "."; color: var(--cat-leisure); }`).
6. **Section kicker = dot + uppercase label + 6 px gold bar.** Mirrors USER_DNA's 6 px precision rule, applied to underline instead of progress bar.
7. **Footer = gradient top stripe.** `border-top: 4px solid; border-image: var(--grad-gold) 1;` over the gray-950 footer base.
8. **Stat numbers = gradient text.** `background: var(--grad-eco); -webkit-background-clip: text; color: transparent;` — colorful spectacle without weighing down the rest of the UI.

## 6. SVG card art (when no real image yet)

When `uploads/generated/masonry/unit-XXX.jpg` is missing, `lib/components.php::eco_unit_art()` renders a **category-aware SVG illustration** (sky gradient + foreground silhouette varied per category):

| Category | Silhouette |
|---|---|
| Food | dining canopy + lantern |
| Living | terrace home + tree |
| Shopping | retail row with three awnings |
| Transport | road perspective + horizon dashes |
| Leisure | park trees + ground |
| Residential | three high-rise towers + window grid |
| Commercial | shop office row with three storefronts |

Sun/cloud placement varies on `id % 4` so 400 cards don't look identical. The SVG receives the category palette via `eco_category_palette()`. When codex's real image lands at the expected path, `eco_unit_media()` switches to `<img>` automatically.

## 7. Image-gen contract (for codex / image-generator AIs)

- Hero slot: `uploads/generated/hero/eco-township-arrival.jpg` (16:9).
- Slideshow: `uploads/generated/slideshow/<key>.jpg` for each `data/visuals.php['slideshow']` key (16:9).
- Unit masonry: `uploads/generated/masonry/unit-001.jpg` through `unit-400.jpg` (4:3). Prompts derived from `api/database.php::eco_category_image_prompt($category, $region)`.
- Blueprint: `uploads/generated/blueprint/unit-XXX-blueprint.jpg`.
- **Locale anchor:** Johor Bahru / Iskandar Puteri (Eco Botanic, Eco Galleria, Eco Spring direction). Klang Valley region → Eco Ardence / Eco Majestic. Penang → Eco Horizon.
- **No text, no logo** in any generated image — branding is applied via CSS overlay (`.eco-watermark`).

## 8. Anti-patterns (do NOT do)

- ❌ Gray status badges. If a unit is "Available", show it in **living-green**, not gray. USER_DNA forbids gray-on-gray.
- ❌ Plain `#fff` hero background. Use `--grad-soft` + the green/gold corner blobs so the surface feels alive.
- ❌ Same color for all 400 cards. The whole point of the category palette is fast visual scanning.
- ❌ Reverting `width=device-width` to `width=412`. Per [CLAUDE.md](C:/Users/user/.claude/CLAUDE.md) 2026-05-11 update, viewport is responsive — `width=412` was deprecated because narrower phones clip.
- ❌ Replacing serif headings with sans-serif "to match book.ecoworld.my". The serif (Georgia stack) is what makes the project feel *editorial* vs sterile.
- ❌ Visible OS-native horizontal scrollbars on filter chip rows / feature sliders / tab lists. Always hide via `scrollbar-width:none` + `::-webkit-scrollbar{display:none}` and provide a fade-edge mask hint instead.
- ❌ Default-styled native `<select>` dropdowns. Always strip `appearance:none` and paint a custom green chevron SVG as `background-image`. The OS chrome breaks visual continuity with the rest of the pill-button system.

## 9. Modern polish layer (2026-05-11 update)

Applied on top of §1–7 to align with current ecoworld.my / book.ecoworld.my / M Tiara aesthetic:

| Element | Rule | Why |
|---|---|---|
| **Scrollbars** on `.chip-row`, `.feature-slider`, `.tab-list` | Invisible — `scrollbar-width:none`, `::-webkit-scrollbar{width:0;height:0;display:none}` | OS-native scrollbars look dated. Discoverability preserved via fade-edge mask. |
| **Edge fade** on `.chip-row` | `mask-image: linear-gradient(to right, transparent 0, #000 16px, #000 calc(100% - 24px), transparent 100%)` | Tells user content scrolls; replaces lost scrollbar affordance. |
| **Filter panel** | `border-radius: var(--radius-lg)` (28px), softer shadow `0 8px 24px rgba(6,63,36,0.06)`, transparent 96% white surface | Premium glassy feel without heavy backdrop blur. |
| **Chip** | 40 px min-height, `padding: 0 18px`, full-pill, transparent border, soft eco-green-100 hover | Modern pill control system shared with `.tab-list button`. |
| **Active chip / tab** | `box-shadow: 0 6px 16px rgba(11,90,50,0.28)` | Tactile elevation cue; replaces hard border. |
| **Search input** | Inline SVG magnifier as `background-image`, 42 px left padding, focus ring `0 0 0 3px rgba(28,154,80,0.18)` | Modern affordance — no extra DOM. |
| **Select** | `appearance: none`, custom green chevron SVG, 42 px right padding | Removes OS-specific dropdown chrome. |
| **Button hover** | `translateY(-2px)` + stronger shadow `0 10px 28px rgba(11,90,50,0.30)` | Tactile lift consistent with card hover. |
| **Unit card** | Lighter border `rgba(21,21,21,0.06)`, padding bumped to `20px 22px 22px` | Calmer surface, more breathing room. |

### Code snippet (drop-in)

```css
/* Invisible scrollbar pattern — apply to any horizontal-scroll strip */
.chip-row, .feature-slider, .tab-list {
  scrollbar-width: none;
  -ms-overflow-style: none;
}
.chip-row::-webkit-scrollbar,
.feature-slider::-webkit-scrollbar,
.tab-list::-webkit-scrollbar {
  width: 0; height: 0; display: none;
}

/* Custom select chevron (no JS, no library) */
select {
  appearance: none;
  -webkit-appearance: none;
  padding-right: 42px;
  background-image: url("data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='%23117a3d' stroke-width='2.4' stroke-linecap='round' stroke-linejoin='round'><path d='m6 9 6 6 6-6'/></svg>");
  background-repeat: no-repeat;
  background-position: right 14px center;
  background-size: 16px 16px;
}
```

Apply this layer to any EcoWorld-derived project. Cross-references:
- Implementation: `c:/Users/user/Desktop/ecoworld/css/style.css` (block starting "Modern polish pass — invisible scrollbars + filter refinement").
- Visual trigger that motivated the update: filter panel screenshot showing an unwanted horizontal scrollbar between the chip row and the region/type selects.

## 10. Unified-mint filter chip active state (2026-05-12 revision)

**Reverses §3 + §5 #3 for filter chips specifically.** Per-category mid colors on chip-active backgrounds proved visually noisy in real use — a filter row of 7 chips lighting up in 7 different hues (Food orange / Living green / Shopping violet / Transport blue / Leisure gold / Residential teal / Commercial brown) competed for attention with the masonry cards they were filtering. Users reported the panel "fights the wall."

**Rule:** every filter chip — *including* the "All" chip — uses **one shared mint** for both hover and active states:

```css
.chip:hover,
.chip.is-active,
.chip[data-filter="all"].is-active,
.chip[data-filter="Food"].is-active,
.chip[data-filter="Living"].is-active,
.chip[data-filter="Shopping"].is-active,
.chip[data-filter="Transport"].is-active,
.chip[data-filter="Leisure"].is-active,
.chip[data-filter="Residential"].is-active,
.chip[data-filter="Commercial"].is-active {
  background: var(--eco-green-100);     /* #d6fff8 */
  border-color: var(--eco-green-100);
  color: var(--eco-green-900);          /* #063f24 */
  box-shadow: 0 3px 8px rgba(0, 107, 91, 0.22);
}
```

**Why this works:** the chip row becomes one calm control surface, the category color identity is preserved on the *cards themselves* (where it actually does the visual-scanning work), and hover → active feels continuous instead of jumping between hue families.

**Where to still use category colors:** card eyebrow dots, card top borders, status badges, journey/zone step left-borders, region-card top stripes. Never on filter chips.

## 11. Image-led region/feature card pattern (2026-05-12)

When you have 3–4 region/family/category items to show side-by-side and want them to feel editorial rather than spec-sheet:

```html
<article class="region-card" style="--i:0">
  <div class="region-card__media">
    <img src="…" alt="…">
    <span class="region-card__badge">South · 5 townships</span>
  </div>
  <div class="region-card__body">
    <span class="region-card__label">Region · 01</span>
    <h3>Iskandar Malaysia.</h3>
    <p class="region-card__tagline">Johor Bahru garden-city living…</p>
    <ul class="region-card__chips">
      <li>Eco Botanic</li><li>Eco Spring</li>…
    </ul>
    <div class="region-card__meta">
      <span>5 townships</span><span>·</span><span>Reference set</span>
    </div>
  </div>
</article>
```

Visual rules:
- **16:9 cover image** with `transform: scale(1.05)` on hover (600 ms)
- Bottom-fade gradient over image so the badge stays readable
- **Frosted white pill badge** (`background: rgba(255,255,255,.95); backdrop-filter: blur(8px)`) bottom-left of image
- **5 px gradient top stripe** — green for first card, gold for second, transport→shopping for third (`background: var(--grad-eco) / --grad-gold / linear-gradient(135deg, var(--cat-transport), var(--cat-shopping))`)
- Body: kicker ("Region · 01") + serif h3 with gold "." Sovereign Punctuation + tagline + pill chip list + **dashed footer meta row** in uppercase 12 px green-700
- Card hover: `translateY(-4px)` + shadow ramp from `0 10px 28px` to `0 24px 48px`

This pattern displaces the older plain-text region card (which read like a CSV dump) and gives the "Crafted by EcoWorld" / region-family / project-family blocks a campaign feel.

## 12. "Powered by EcoWorld" frosted-glass caption (2026-05-12)

A reusable image caption block for any "Powered by X" / signature-mark moment. Replaces the older gold-pill badge with a Sovereign Punctuation composition:

```html
<figure class="powered-figure">
  <img src="…" alt="…">
  <figcaption class="powered-caption">
    <span class="powered-caption__kicker">
      <span class="powered-caption__dot"></span>
      Powered by
    </span>
    <strong class="powered-caption__brand">EcoWorld</strong>
    <span class="powered-caption__meta">Reference floor plan · Iskandar Puteri</span>
  </figcaption>
</figure>
```

Visual:
- 92% white frosted plate (`backdrop-filter: blur(10px)`), 18 px radius, max-width 340 px
- **4 px gold gradient bar pinned to plate bottom** (`background: var(--grad-gold)`)
- Line 1 — small green kicker dot + uppercase "POWERED BY" (11 px, eco-green-700, letter-spacing .12em)
- Line 2 — Georgia serif 22 px bold brand name with `::after { content: "."; color: var(--cat-leisure); }`
- Line 3 — muted meta in 11.5 px green-700, letter-spacing .04em
- Positioned bottom-left of the image (22 px inset)
- Image gets 32 px corner radius + outer shadow + 1 px inset white ring for editorial polish

Use this anywhere you'd put a "Powered by", "Verified by", "Curated by" attribution on an image. **Do not** use the older gold-pill badge — it reads as a coupon stamp.

---

*Created 2026-05-11 by Claude (Opus 4.7, 1M context) during EcoWorld redesign cooperation with codex (image generation). Validated against `c:/Users/user/Desktop/ecoworld/css/style.css` and `lib/components.php` actual implementation. Sections 10–12 added 2026-05-12 after second pass of UX corrections.*
