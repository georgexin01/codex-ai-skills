---
name: wrider-design-senses
description: "Distilled design principles for the wRider ecosystem — extracted from observed user edits + iterations. Single source of truth for aesthetic decisions any AI should respect when working on wRider."
triggers: ["wrider", "rider app", "admin app", "wrider design", "design senses", "design rules"]
phase: 1-foundation
version: 1.0.0
status: authoritative
date_authored: "2026-05-05"
project: "c:/Users/user/Desktop/wRider"
---

# 💎 wRider — Design Senses (V1)

> Source: observed user edits + spoken preferences across the wRider build sessions.
> Companion docs:
> - [`BLUEPRINT.md`](../../../Desktop/wRider/BLUEPRINT.md) — architectural manifest
> - [`wrider_chat_mining.md`](./wrider_chat_mining.md) — auto-evolution protocol that keeps this file fresh

This document encodes **why** the user's edits looked the way they did. Use it
to predict the right call **before** they have to ask. When in doubt, follow
these principles over generic web/mobile patterns.

---

## 🎯 SENSE 1 — Visual weight is for hierarchy, not decoration

**The rule:** Heavy weights are reserved for one or two anchor elements per
viewport. Default body text and even most card titles use weight **700**
(`font-bold`), not **900** (`font-black`).

**Observed migration in this project:**

| Element | First built as | User changed to | Why |
|---|---|---|---|
| `WRHeader` page title | `text-lg font-black` | `text-xl font-bold` | bigger size + lighter weight reads "premium", not "shouty" |
| Card primary title (driver name in lists) | `text-sm font-black text-ink` | `text-sm font-bold text-ink` | list rows shouldn't compete with hero numbers |
| Hero amount (Payroll) | `text-3xl font-black` | `text-3xl font-bold` | DM Sans 900 felt aggressive |
| Settled amount, transaction amount | `font-black text-income` | `font-bold text-income` | same |
| Income chart total | `font-black` | `font-bold` | display-only number reads fine at 700 |

**The shortcut:** when text feels "too bold" → don't drop the size, drop the
weight. When it feels "not enough impact" → don't bump weight first, bump
size. Size carries hierarchy more effectively than weight alone.

**Reserved for `font-black` (900):**
- KPI cell values inside boxed grids (`text-base font-black text-teal mt-1`) — boxed context absorbs the weight.
- Tiny accent labels under 12px (`text-[10px] font-black text-violet uppercase tracking-widest`) — small caps need the weight to render legibly.
- Single dominant currency / count number on a dashboard card (`balance` class).

**Forbidden:**
- `font-black` on any text that flows in a list, paragraph, or sentence.
- Anything above 800 weight when DM Sans is loading at large sizes.

---

## 🎯 SENSE 2 — DM Sans + greyscale smoothing, never raw Inter

**The rule:** Always import the optical-size variable cut of DM Sans. Always
declare antialiasing hints on `body`.

```css
@import url('https://fonts.googleapis.com/css2?family=DM+Sans:opsz,wght@9..40,400;9..40,500;9..40,600;9..40,700;9..40,800;9..40,900&display=swap');

@theme {
  --font-sans: "DM Sans", "SF Pro Display", "Inter", "Segoe UI", system-ui, -apple-system, sans-serif;
}

html, body {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-rendering: optimizeLegibility;
}
```

**Why DM Sans:** Inter's stems become harsh at 800–900. DM Sans rounds the
corner terminals, so heavy weights stay readable. The optical-size axis
(`opsz,wght@9..40,…`) lets tiny eyebrows and large display numbers each get
the right cut.

**Optional admin-only flair:** `font-feature-settings: 'ss01' on, 'cv11' on;`
gives the friendlier single-storey `a` and rounded `l` tail. Don't use on
rider unless asked.

---

## 🎯 SENSE 3 — Header is 70px, fixed, dark-violet hero gradient

**The rule:** `.wr-header` is a fixed 70-pixel band at the top of every
non-home page. Same gradient as the hero (`07061f → 17113d → 2f176e`),
white title (`text-xl font-bold`), translucent-white eyebrow.

```css
.wr-header {
  position: fixed; top: 0; left: 0; right: 0; height: 70px;
  background: radial-gradient(circle at 86% 22%, rgba(140,61,244,.72), transparent 150px),
              radial-gradient(circle at 8% 10%, rgba(9,129,120,.42), transparent 210px),
              linear-gradient(135deg, #07061f 0%, #17113d 52%, #2f176e 100%);
  z-index: 50;
}
```

**Then `.wr-content` margin-top: 70px.** No `position: sticky` — fixed only
so the header never disappears mid-scroll.

**Iterated path before settling:** glass-light header → dark gradient →
80px → **70px**. Don't propose lighter or taller variants without prompting.

---

## 🎯 SENSE 4 — Status by colour, applied consistently everywhere

**The mapping** (memorise; this is the cross-app spec):

| Verdict / state | Colour token | Meaning | Animation |
|---|---|---|---|
| `late` | `#ff1d25` (`--color-danger`) | past ETA | pulses |
| `on-track` | `#38bdf8` (sky / blue) | within ETA | static |
| `tight` | `#e8af24` (`--color-gold`) | ≤ 3 min slack | static |
| `proof` (uploading photo) | `#8c3df4` (`--color-violet`) | photo-gate | pulses |
| `idle` | `#06a65a` / `#098178` (mint/teal) | available | static |
| `offline` | `#94a3b8` (grey) | off-duty | static |

**Apply on:**
- Map pin colours
- Route polyline colours
- Badge variants (`wr-badge-pickup` / `wr-badge-transit` / etc.)
- Audit-verdict cards
- Progress-bar gradients on per-job timing cards
- Admin Rider Table right-column tone

**Forbidden:** introducing a new status colour without updating the table
above. If a new state needs colour, propose updating this doc first.

---

## 🎯 SENSE 5 — Card consolidation > card multiplication

**The rule:** Related information lives in one larger card with internal
hairline dividers, not five small cards stacked.

**Pattern to use:** `.wr-divider { height: 1px; background: var(--color-line); margin: 16px -18px; }` — bleeds to card edges via negative horizontal margin.

**Reference: [JobDetailView](../../../Desktop/wRider/webApp-wRider-admin/src/views/JobDetailView.vue) was rebuilt from 6 cards → 3:**
1. Overview (audit verdict + KPI strip)
2. Mission brief (5-step timeline + notes)
3. Driver + timing (assigned driver + time tracking)

**Forbidden:**
- Wrapping every single section in its own `WRCard`. If the next card is
  small (< 80px tall), it probably belongs inside the previous one with a
  divider.
- More than 5 separate cards on a single scroll page.

---

## 🎯 SENSE 6 — KPI strips, not KPI tiles

**The rule:** When showing 2–4 numeric KPIs in a row, render them as a
**strip with vertical hairlines between cells**, not as individual rounded
chiclets.

```html
<div class="wr-kpi-grid">     <!-- grid-template-columns: repeat(N, minmax(0, 1fr)); -->
  <div class="wr-kpi"><p>CHARGE</p><strong>RM 45</strong></div>
  <div class="wr-kpi"><p>DISTANCE</p><strong>15 km</strong></div>
  <div class="wr-kpi"><p>ETA</p><strong>15 min</strong></div>
</div>
```

```css
.wr-kpi + .wr-kpi::before {
  content: ""; position: absolute; left: 0; top: 4px; bottom: 4px;
  width: 1px; background: var(--color-line);
}
```

Single continuous element, less visual noise than three `bg-app-bg rounded-xl` tiles.

---

## 🎯 SENSE 7 — Children pages have back button, no footer

**The rule:** Every route splits into one of three categories — login, top-level (footer tab), or **child page**. Children **always** ship `meta: { hideFooter: true }` AND their `<WRHeader>` carries `back`.

**Concrete map (admin):**
- Footer tabs: `/`, `/jobs`, `/map`, `/payroll`, `/settings`
- Children: `/drivers`, `/drivers/:id`, `/jobs/new`, `/jobs/:id`

**Concrete map (rider):**
- Footer tabs: `/`, `/wallet`, `/map`, `/profile`
- Children: `/task/:id`, `/proof/:id/:kind`

**Forbidden:** showing both back-button and footer on the same page; showing
neither on a sub-page (user gets stuck).

---

## 🎯 SENSE 8 — Native browser controls are off-limits

**The rule:** No raw `<select>`, no raw `<input type="file">` for proof
gates, no `<a target="_blank">` for image previews. Always wrap in a
design-system component:

| Native | Replace with |
|---|---|
| `<select>` for picking driver/job | Custom button + animated dropdown panel (`.wr-picker-trigger` / `.wr-picker-list`) |
| `<a target="_blank">` thumbnail | `<button>` opening `<WRImageLightbox>` (fullscreen with `‹›` chevron + keyboard) |
| Browser confirm dialog | Bottom-sheet drawer (`<WRQuickAssignDrawer>` pattern) |

**The picker contract** (used in `WRQuickAssignDrawer.vue` and
`JobDetailView.vue`):
- 60-px height trigger button
- 36-px violet gradient icon chip on the left
- Two-line value (strong + small)
- Chevron that rotates 180° when open
- Panel below with rounded items, 240-px max-height, internal scroll
- Selected row gets violet-soft background + violet check tick

---

## 🎯 SENSE 9 — Mobile sizing rules

**Viewport:** `<meta name="viewport" content="width=412, viewport-fit=cover" />` — keeps the 412px design canon (CLAUDE.md mandate) but **drops `initial-scale=1.0, maximum-scale=1.0, user-scalable=no`** so phones narrower than 412 auto-shrink instead of clipping.

**Overflow safety:** every shell element gets:
```css
html, body, #app, .wr-shell, .phone {
  max-width: 100vw;
  overflow-x: hidden;
}
```

**Grid columns inside cards:** `repeat(N, minmax(0, 1fr))` not `repeat(N, 1fr)` so columns can shrink below their content's min-width. Pair with `min-width: 0` on the cell.

**Floating elements** (e.g. `.wr-glow` on FlushFooter) must stay ≥ 10 px from each edge. Wrap inline `left:` values in `clamp(37px, …, calc(100% - 37px))` (37 px = half of 54-px orb + 10 px).

---

## 🎯 SENSE 10 — Real seed data first, hardcoded text never

**The rule:** Every visible label / number / status comes from the Pinia
store. Hardcoded display text is a code smell.

**Architecture:** [`api/`](../../../Desktop/wRider/api/) has the canonical
`schema.sql` + per-app PHP seeds. The Pinia stores
(`adminStore.ts` / `driverStore.ts`) mirror those tables. UI computeds derive
verdicts at read time:

```ts
function jobVerdict(job: Job): 'ontrack' | 'late' | 'tight' {
  const remaining = job.estimatedMin - usedMinOf(job)
  if (remaining < 0) return 'late'
  if (remaining <= 3) return 'tight'
  return 'ontrack'
}
```

**Reference patterns:**
- Dashboard's "Active job timing" list reads `adminStore.activeJobs`,
  computes verdict per job, paints colour tone accordingly.
- Driver Detail's income chart groups completed jobs by inferred category.
- Settings stats grid: `adminStore.drivers.length`, `completedToday`, `totalJobs`.

**Forbidden:** placing fixed strings like "5 drivers · 2 jobs done" when
the store can answer that question.

---

## 🎯 SENSE 11 — Map markers focus on riders, routes follow status

**Admin map** shows **only rider pinpoints**, colour-coded by verdict
(SENSE 4). Drop-off pins were removed deliberately — admin needs glanceable
rider state, not destination clutter. Tap a rider → route line draws
**(driver → drop)** in the verdict colour, real road routing via OSRM
`bike` profile, cached by 110-m grid cell to avoid rate-limit.

**Rider map** shows pickup → driver (live GPS) → drop, two-leg routed line
with the upcoming leg dimmed to 35 % opacity, active leg at 90 %.

**Forbidden:**
- Drawing routes for idle or offline drivers (no destination).
- Showing a fleet-wide route map on the rider side (they only own their
  one mission).

---

## 🎯 SENSE 12 — Iterate icons, don't theorise

**Observed:** the dashboard's Smart-match insight icon went `Sparkles` →
`Bike` (lucide bicycle) → custom motorbike SVG → `ShieldCheck`. The user
landed on ShieldCheck because the *meaning* is "vetted/protected match",
not "vehicle".

**Heuristic for icon picks:**
1. Pick the **semantic** match (what the action means) over the
   **literal** match (what the action's noun looks like).
2. Use `lucide-vue-next` first. Drop to inline SVG only if a meaningful
   glyph isn't in the lucide set (e.g. true motorbike doesn't exist —
   `Bike` is bicycle).
3. Standard size: `:size="18"`, `:stroke-width="2.5"` for action chips;
   `:size="24"` for hero / icon-coin spots; `:size="14"` for inline labels.
4. Strip white-corner highlights from icon-coins — the user explicitly
   removed `radial-gradient(circle at 30% 26%, #fff 0 8%, transparent 9%)`
   from `.insight-coin`.

---

## 🎯 SENSE 13 — Photo evidence = lightbox, not new tab

**The rule:** Every proof gallery in a job detail (pickup / drop-off) opens
[`WRImageLightbox.vue`](../../../Desktop/wRider/webApp-wRider-admin/src/components/WRImageLightbox.vue):
fullscreen, dark backdrop, prev/next chevrons, keyboard nav (← → Esc),
thumbnail strip, download button.

Thumbnail must be a `<button>` (not `<a>`), 56 × 56, `cursor: pointer`,
`:focus-visible` violet ring.

---

## 🎯 SENSE 14 — Information density rules

Every list row in admin views shows **at minimum**:
- Avatar / status indicator
- Primary identifier (name)
- Secondary signal (location, time delta, audit verdict)
- Right-column anchor (RM amount or status pill)

Driver row examples (real production copy):
- Idle: `"Idle · 0.3km from shop" · "RM 88 · Today earning"` (income tone)
- Busy on-track: `"In transit · 9min left" · "9min · Task left"`
- Busy late: `"Check needed · 13min over" · "Late · Admin tick"` (red tone)
- Uploading proof: `"Uploading pickup proof" · "Proof · Waiting"` (proof tone)

**Forbidden:** rows that are just a name + chevron. If you can't fill all
four slots with real signal, the row probably shouldn't exist as a row —
make it a card.

---

## 🎯 SENSE 15 — "Quick assign" pattern for any rider/job binding

When admin needs to bind a rider to a job (Dashboard Smart-match,
DriverDetail "Assign Job" button, JobDetail "Assign driver"), open
[`WRQuickAssignDrawer`](../../../Desktop/wRider/webApp-wRider-admin/src/components/WRQuickAssignDrawer.vue)
with the relevant side pre-filled.

**Drawer must include:**
- Rider picker (idle drivers only)
- Job picker — **first row is always "+ Create new job"** routing to
  `/jobs/new` with `?driver=…` carrying the picked driver
- Live haversine preview (`{km} km · {min} min` + RM reward chip) once
  both sides selected
- Disabled "Confirm assign" button until both picked

---

## 🛡️ FORBIDDEN PATTERNS (cross-cutting)

1. **No `font-black` for body text** (SENSE 1).
2. **No native `<select>` in any drawer or form** (SENSE 8).
3. **No new colour outside the 6-state palette without updating SENSE 4.**
4. **No card-in-card** — if the inner element has its own border + shadow
   inside a `WRCard`, refactor to a hairline-divider section.
5. **No raw hex** in views — go through tokens or scoped CSS classes.
6. **No `text-lg font-black` for page titles** — use `text-xl font-bold` (SENSE 1, 3).
7. **No `<img>` in views** — wrap in `<AppImage>` (CI-checkable rule from BLUEPRINT.md §10).
8. **No new top-level routes outside footer/children buckets** (SENSE 7).

---

## 🔧 Quick decision matrix

| Situation | Default decision |
|---|---|
| User says "too bold" | Drop weight to 700; if size feels small after, bump size class up one step. |
| User says "looks cluttered" | Merge adjacent cards via `.wr-divider`. Drop boxed KPI tiles for KPI strip (SENSE 6). |
| User says "feels too small on mobile" | Verify viewport meta drops `initial-scale=1.0` lock (SENSE 9). |
| User says "use real data" | Wire to existing Pinia store + computed verdict; don't hardcode (SENSE 10). |
| User says "icon doesn't fit" | Stop iterating literal icons; pick semantic icon (SENSE 12). |
| User says "should be like other page" | Find the canonical reference (`JobDetailView`, `WRHeader`) and copy its structure verbatim. |
| User says "popup not at right place" | The Vue component is probably being torn down/re-created on click. Use in-place mutators (`marker.setIcon`) instead of full rebuilds. |

---

**Authored:** 2026-05-05 · v1.0.0
**Maintain:** see [`wrider_chat_mining.md`](./wrider_chat_mining.md) — every
session, scan user edits, append to the relevant SENSE.
