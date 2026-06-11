---
name: lifestyle-detail-pure-display
description: "Property/product detail page pattern that ditches tabs in favour of pure-display: every lifestyle category card is visible at once. Built for EcoWorld unit detail page 2026-05-12 — the buyer reads Food / Living / Shopping / Transport / Leisure in a single scroll. No click-to-reveal, no hidden content."
type: skill
tier: 2
phase: 06-component-engineering
priority: HIGH
applies_to: ["claude", "claude-code", "codex", "gpt-5.4-mini"]
related:
  - "SKILL.md"
  - "ECOWORLD_COLOR_SYSTEM.md"
  - "06-component-engineering/skill.md"
version: 1.0
date: 2026-05-12
status: authoritative
triggers:
  - "unit detail page"
  - "property detail"
  - "lifestyle tabs"
  - "no tabs design"
  - "pure display content"
  - "all sections visible"
  - "remove tab navigation"
---

# Property Detail — Pure Display (no tabs) Pattern

> When a property/product/unit detail page has 5+ category sub-sections (Food, Living, Shopping, Transport, Leisure, etc.), **do not hide them behind tabs**. Show every section at once on a single scroll. Validated 2026-05-12 against the EcoWorld 400-unit prototype after the user explicitly rejected the prior tabbed UI.

## 1. Why this beats tabs

| Tabs (old pattern) | Pure display (new pattern) |
|---|---|
| Buyer has to discover what's hidden | Everything visible at first paint |
| Tab content is invisible to Cmd-F | Browser search finds it all |
| Mobile users tap-tap-tap each tab | One scroll reads the neighbourhood |
| Print/share looks broken (only active tab shows) | Print captures full page |
| Adds JS state, focus management, ARIA roles | Zero JS, zero accessibility tax |
| Easy to forget content exists | Hard to miss |

The trade is **vertical length** — the page gets longer. That is the right trade for property/lifestyle content, where buyers *want* to read everything and the page is already image-led. It is the *wrong* trade for high-frequency dashboards where users repeat the same lookup; keep tabs there.

## 2. Page composition (top → bottom)

1. **Unit Introduction** — kicker (e.g. "Unit Introduction") + serif h2 + lead paragraph + descriptive paragraph. NOT "Unit facts" — the word *Introduction* prompts the writer to add real prose, not a dict-style label list.
2. **Horizontal spec strip** — single row of 5 mini-facts (Status, Region, Category, Type, Area). Each cell has a 4 px gold gradient bar on top, uppercase label, serif value. White card with 22 px radius, divided by 1 px right borders.
3. **Lifestyle grid** — auto-fit grid of category cards (300 px min column). One card per lifestyle layer.
4. **Disclaimer note** — small italic line at the bottom about prototype data.

## 3. Lifestyle card anatomy

```html
<article class="lifestyle-card" data-tone="food">
  <header class="lifestyle-card__head">
    <span class="lifestyle-card__icon">🍽️</span>
    <div>
      <span class="lifestyle-card__kicker">Food</span>
      <h3>Food nearby</h3>
      <p class="lifestyle-card__sub">Daily dining options within walking or short-drive reach.</p>
    </div>
  </header>
  <ul class="lifestyle-card__list">
    <li>Weekend market</li>
    <li>Grab-and-go grocers</li>
    <li>Neighbourhood cafes</li>
  </ul>
</article>
```

Visual rules per card:
- **Top border 6 px in category mid color** — `data-tone="food"` → `--cat-food`, etc.
- **Icon tile 52×52 / 16 px radius** filled with category-100 soft tint (`--cat-food-100`, etc.)
- **Kicker** 11.5 px uppercase 800-weight in eco-green-700
- **h3** 22 px serif 700 in eco-green-900
- **Sub-lead** 13.5 px muted under h3 — explains what the list covers
- **List items** are pill-style cards: paper background, 12 px radius, 14.5 px 700-weight green-900 text, **12 px category-mid dot** at left (`::before` with 6 px offset; for accessibility use `box-shadow: inset 0 0 0 3px var(--eco-white)` for a halo ring)
- Card hover: `translateY(-3px)` + shadow ramp

The 5 categories map to: 🍽️ Food, 🏡 Living, 🛍️ Shopping, 🚆 Transport, 🌳 Leisure.

## 4. Horizontal spec strip details

```css
.unit-intro__specs {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  background: var(--eco-white);
  border: 1px solid rgba(21, 21, 21, 0.06);
  border-radius: 22px;
  box-shadow: 0 10px 28px rgba(6, 63, 36, 0.06);
  overflow: hidden;
}
.unit-intro__spec {
  display: grid;
  gap: 6px;
  padding: 22px;
  border-right: 1px solid rgba(21, 21, 21, 0.06);
  position: relative;
}
.unit-intro__spec:last-child { border-right: none; }
.unit-intro__spec::before {
  content: "";
  position: absolute;
  left: 22px; top: 18px;
  width: 18px; height: 4px;
  border-radius: 4px;
  background: var(--grad-gold);
}
.unit-intro__spec strong {
  font-family: Georgia, "Times New Roman", serif;
  font-size: 19px;
  font-weight: 700;
  color: var(--eco-green-900);
}
@media (max-width: 767.98px) {
  .unit-intro__spec {
    border-right: none;
    border-bottom: 1px solid rgba(21, 21, 21, 0.06);
  }
  .unit-intro__spec:last-child { border-bottom: none; }
}
```

## 5. Anti-patterns

- ❌ Bringing tabs back "for compactness" — the page is for *reading*, not searching. Length is not a flaw here.
- ❌ Collapsing categories into accordions. Same problem as tabs — hides content.
- ❌ Using only icons without text labels. Buyers scan kickers, not pictograms.
- ❌ A single column of 5 cards stacked vertically. Use auto-fit grid (min 300 px) so it becomes 2-up or 3-up on desktop.
- ❌ Forgetting the sub-lead under each h3. The list alone reads like a bullet dump without context.
- ❌ Same accent color for all 5 cards. Category color identity is what makes the grid scannable.

## 6. When to *not* use this pattern

- High-frequency dashboards (CRM, admin, ops) — tabs win there.
- Pages with 10+ category subsections — use a left-rail nav with anchor scroll instead.
- Pages where category content is identical structure × 5 (then a single table beats cards).

---

*Authored 2026-05-12 by Claude during EcoWorld unit-page redesign. Triggered by user message: "no tag no hide and show... pure display all content inside the pages". Reference impl: `c:/Users/user/Desktop/ecoworld/template/unit.php` + `.unit-lifestyle-*` CSS block.*

