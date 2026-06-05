---
name: mobile-app-design-recipe
description: "Step-by-step build guide for the user's preferred mobile app aesthetic (fintech / utility, 412 px viewport, mint+gold+ink, DM Sans, 23-view shape with toast system + animated FAB + Design Kit). Use as the canonical clone-template when the user asks for a new mobile app, sample app, dashboard prototype, or 'build me an app like the wallet template'."
type: procedure
tier: 2
phase: 1-execution
priority: HIGH
model_hint: codex-gpt-5.3
applies_to: ["claude", "claude-code", "codex-gpt-5.3", "antigravity"]
authored_by: claude-opus-4-7
authored_for: "shared cross-AI use"
requires: ["CLAUDE_BLUEPRINT_RECIPE.md", "0_apex/USER_DNA.md", "1_core/DESIGN_SOP.md", "0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md"]
unlocks: ["IMAGE_TO_MOBILE_APP_PIPELINE.md"]
related: ["1_core/UI_DNA_MASTER.md", "1_core/DESIGN_PSYCHOLOGY_2026.yaml", "1_core/INDUSTRIAL_INTERACTION_LIBRARY.md", "wrider_design_senses.md"]
reference_implementation: "c:/Users/user/Desktop/insurance-CRM/template/"
companion_blueprint: "BLUEPRINT.md"
companion_design: "DESIGN.md"
version: 2.0
date: 2026-05-07
status: authoritative
triggers:
  - "build me a mobile app"
  - "new mobile app"
  - "sample app like wallet"
  - "clone the template"
  - "fintech mobile app"
  - "scaffold a new app"
  - "mobile app starter"
---

## Gemini 3 Flash reading notes

- **Imperative voice everywhere**: this file is a command set, not a discussion.
- **Phases are sequential** — execute Phase 1 fully before Phase 2.
- **Code blocks are copy-paste ready** — no placeholder `<TODO>` unless explicitly marked.
- **Decompose** a phase into ≤ 3 sub-tasks per turn (per FLASH_HARDENING §4).
- **Verify** each phase's checklist before advancing (Chain-of-Verification mandate).
- **Permission boundaries**: writes confined to `<project_root>/`. Tier-0/1 `.codex/memories/` paths are read-only.


# 📱 MOBILE APP DESIGN RECIPE (v1.0)

> The canonical step-by-step for building a new mobile app in the user's preferred aesthetic. Reference implementation lives at [c:/Users/user/Desktop/insurance-CRM/template/](c:/Users/user/Desktop/insurance-CRM/template/) — this recipe is the **executable instruction set** to clone-and-rewire it for any new project.

## §0.5 TASTE COMPASS — read FIRST, commit BEFORE Phase A

> Distilled from [USER_DNA.md](0_apex/USER_DNA.md), [wrider_design_senses.md](archive/wrider_design_senses.md), and 5 iterations of carMVP feedback. **The AI MUST output a "Taste Commit" block before writing any code, restating these in the project's own words.**

**Precedence rule when sources conflict**:

> **Sample-image fidelity > User taste fingerprint > Generic mobile patterns.**
> If user-supplied sample images use yellow CTA but USER_DNA suggests violet/teal, the samples win. USER_DNA fills only what samples are silent on.

**The 7 reliable preferences** (apply unless samples explicitly contradict):

1. **Yellow primary CTA wins over navy/ink** for marketplace surfaces. Red `#F4364C` for prices/urgency. Ink `#10171c` is text + accent cards, never primary buttons.
2. **Lighter / paper backgrounds** (`#F5F5F7` snow) over dark or saturated. Dark surfaces = accent cards only.
3. **Colored brand logos > monochrome.** Default `https://cdn.simpleicons.org/{slug}` (no color suffix) — `/000000` was rejected as "too gray".
4. **Functional tags only.** Every chip / tab / quick-action / sub-tab MUST drive content. Tabs MUST swap the panel below, not just the underline. **Decorative chips are defects.**
5. **`font-bold` (700) by default.** `font-black` (900) **only** for hero RM prices. Default body text is 14px / 700.
6. **Glass for overlays only** — modals, toasts, sticky bottom bars. NEVER for full headers — pure `bg-white` with `.shadow-header` instead.
7. **Content-dense cards** — list rows must carry 4 signals (icon, primary text, secondary meta, anchor value). Empty rows = wrong abstraction. Pages should be content-rich, not "quite empty".

**The Taste Commit block** (skill MUST output this before Phase A):

```markdown
## Taste Commit (carMVP-style)
- CTA: <yellow #FFCC00 / navy / amber / etc — derived from samples + Taste Compass>
- Bg: <light wash / pure white / cream — derived from samples>
- Tabs: every active tab will swap content via `v-if="activeTab === 'X'"`, not just underline
- Chips: every clickable surface drives router/store/toast — verified via grep before declaring complete
- Brand marks: SimpleIcons CDN with allow-list, no color suffix → official brand color
- Toast cadence: 1500ms default, 140/120ms transitions
```

If the AI does NOT commit this block before code, the build will round-trip 5x for taste corrections.

## When to invoke

Trigger on any of these (or paraphrases):

- "build me a [thing] mobile app"
- "scaffold a new mobile app"
- "I want a sample app for X"
- "make me an app that looks like the template"
- "clone the wallet template into [new project]"

If the user provides reference design images, follow [CLAUDE_BLUEPRINT_RECIPE.md](CLAUDE_BLUEPRINT_RECIPE.md) for image analysis first, then return here for the build steps.

## Outputs (what this recipe produces)

A working mobile app at `<project_root>/` with:

1. Vue 3 + TS + Vite 8 + Tailwind 4 fully configured
2. **20 views** across 4 categories: Auth (6), Main tabs (5), Account (4), Sub-pages (5)
3. Toast/alert system wired into every form + CTA
4. BLUEPRINT.md at the root (per APEX 5)
5. `npm run dev` works on port 5175+ (auto-shifts if busy)

---

## Build Phases (execution playbook)

> **See [`skills/design/app/SKILL.md`](../skills/design/app/SKILL.md)** for the full 9-13 step execution playbook — scaffold, design tokens, app shell, auth, tabs, sub-pages, verification.
>
> Reference implementation: [`c:/Users/user/Desktop/insurance-CRM/template/`](c:/Users/user/Desktop/insurance-CRM/template/) (canonical clone target).
> carMVP variant: [`c:/Users/user/Desktop/carMVP/template/`](c:/Users/user/Desktop/carMVP/template/) (sample-image-driven marketplace).
>
> Stack: Vue 3 + TS + Vite 8 + Tailwind 4 · 20 views · Toast/alert system · BLUEPRINT.md · `npm run dev` port 5175+
>
> **Tailwind v4 note**: prefer `@theme { ... }` inline in `src/assets/global.css` over `tailwind.config.ts`. See §N.3 below.

---

## Verification Checklist

After all views are written, run `npm run dev` and verify:

- [ ] Onboarding loads as default page
- [ ] Onboarding `→` arrow navigates to Login
- [ ] Login submit with empty fields → red toast
- [ ] Login submit with anything filled → green toast → Home loads
- [ ] BottomNav shows on Home/Cards/Wallet/Analytics/Profile only
- [ ] BottomNav 4 tabs each switch active state with `fill-1` icon variation
- [ ] Profile menu items each navigate to their target page
- [ ] Each sub-page has a working back button that returns to previous main tab
- [ ] Settings → Logout fires info toast and routes to Login
- [ ] Wallet → Pay bill button fires green toast
- [ ] Home → Activate cashback fires green toast
- [ ] Invite → Copy code fires green toast
- [ ] Report → Export PDF fires green toast
- [ ] OTP boxes auto-advance focus, Backspace jumps back
- [ ] OTP countdown ticks down from 45
- [ ] All amounts use `.tnum` (no width shifting)
- [ ] All Material Symbols use `wght 300` by default; active states use `.fill-1`
- [ ] Container respects `max-width: 412px` on desktop
- [ ] No horizontal scrollbar
- [ ] Sticky bottom bars don't overlap last list item (use `pb-24` or `pb-32` on parent)

---

## Reusable primitives library (copy-paste)

### Sub-page header
```html
<header class="px-6 pt-12 flex items-center justify-between">
  <button @click="$emit('back')" class="size-11 rounded-full bg-white border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[22px]">arrow_back</span>
  </button>
  <h1 class="text-[18px] font-bold">{{ title }}</h1>
  <button class="size-11 rounded-full bg-white border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[22px]">{{ rightIcon }}</span>
  </button>
</header>
```

### Card list row
```html
<li class="rounded-2xl bg-white border border-slate-100 p-3 flex items-center gap-3 active:scale-[0.99] transition cursor-pointer">
  <span class="size-11 rounded-full bg-snow border border-slate-100 grid place-items-center">
    <span class="material-symbols-outlined text-[20px]">{{ icon }}</span>
  </span>
  <div class="flex-1">
    <p class="text-[14px] font-semibold">{{ title }}</p>
    <p class="text-[11px] text-slate-400">{{ sub }}</p>
  </div>
  <p class="text-[14px] font-bold tnum">{{ amount }}</p>
</li>
```

### Stacked progress bar
```html
<div class="flex h-2.5 rounded-full overflow-hidden">
  <div v-for="c in cats" :key="c.label" :class="c.color" :style="{ width: c.pct + '%' }"></div>
</div>
```

### Form input (with leading icon)
```html
<label class="text-[12px] font-semibold text-slate-500">{{ label }}</label>
<div class="mt-1.5 rounded-2xl bg-white border border-slate-100 px-4 py-3 flex items-center gap-2">
  <span class="material-symbols-outlined text-[20px] text-slate-400">{{ icon }}</span>
  <input v-model="value" :type="type" :placeholder="placeholder"
    class="flex-1 bg-transparent outline-none text-[14px] placeholder:text-slate-300" />
</div>
```

### Featured dark card with blobs
```html
<div class="rounded-3xl bg-ink text-white p-5 relative overflow-hidden shadow-card">
  <div class="absolute -right-12 -top-12 size-44 rounded-full bg-mint/15 blur-2xl"></div>
  <div class="absolute -left-6 -bottom-12 size-40 rounded-full bg-gold/15 blur-2xl"></div>
  <div class="relative">
    <!-- content -->
  </div>
</div>
```

### Toast trigger
```ts
import { useToast } from "../composables/useToast";
const toast = useToast();
toast.success("Title", "Optional message");
```

### Sticky bottom action bar
```html
<div class="fixed bottom-0 left-0 right-0 max-w-[412px] mx-auto bg-snow/90 backdrop-blur-md border-t border-slate-100 px-6 py-4">
  <button class="w-full py-3.5 rounded-full bg-ink text-white text-[14px] font-bold active:scale-[0.99] transition shadow-soft">
    {{ ctaLabel }}
  </button>
</div>
```

Add `pb-24` or `pb-32` on the parent so the last list item isn't covered.

---

## Style rules (reminders)

- ✅ **Always** use `width=device-width, initial-scale=1.0, viewport-fit=cover` viewport. Never hardcode `width=412`.
- ❌ **Never** use `font-black` on text that flows in a list or paragraph (per [wrider_design_senses](wrider_design_senses.md)).
- ❌ **Never** introduce a 3rd accent color beyond mint+gold. One warm + one cool + ink anchor only.
- ❌ **Never** add Pinia, vue-router, or other state libs to a template — keep it pure for clone-ability.
- ✅ **Always** use Material Symbols `wght 300` default + `.fill-1` for active states.
- ✅ **Always** add `.tnum` to monetary amounts.
- ✅ **Always** put hex values for colors in `tailwind.config.js`, never hardcode them in component classes.
- ✅ **Always** wire toast triggers on every form submit, every CTA, every payment-like action.
- ✅ **Always** include 2 blob accents (`-right-12 -top-12 size-44 rounded-full bg-X/15 blur-2xl`) on any dark card.
- ✅ **Always** write a BLUEPRINT.md at the project root (per APEX 5) following [CLAUDE_BLUEPRINT_RECIPE.md](CLAUDE_BLUEPRINT_RECIPE.md) shape.

---

## Permission boundaries

- **Writes confined to**: `<project_root>/` only (configs, src/, BLUEPRINT.md). Nothing in `.codex/` unless user explicitly authorizes a recipe update.
- **Tier-0/1 governance** (`.codex/memories/0_apex/`, `2_governance/`) is read-only without per-turn user authorization.

---

## §N. Sample-Image-Driven Build Recipe (carMVP lessons, 2026-05-08)

> Added after building [`c:/Users/user/Desktop/carMVP/template/`](c:/Users/user/Desktop/carMVP/template/) — Malaysian used-car dealer Vue 3 PWA. 19 reference screenshots in `../sample/` drove the design. **Sample-fidelity is the #1 driver when the user provides reference screenshots — USER_DNA rules apply only where samples are silent.**

### N.1 The 6-phase build order (proven, 22 ordered steps)

| Phase | Steps | Output |
|---|---|---|
| **A — Foundations** | 1. Genesis scaffold (Vite + Vue 3 + TS, viewport=412, mount #root) · 2. Tailwind v4 `@theme` block in `src/assets/global.css` · 3. Config funnel `src/config/{env,supabase,index}.ts` · 4. Types foundry `src/types/*` | Buildable empty shell |
| **B — Reusable systems** | 5. Toast + Modal + Login modal (FIRST) · 6. Form components (Tailwind + Headless UI + CVA) · 7. Layout shells (BottomNav, AppHeader) · 8. Stores skeleton + mock data | Complete UI primitives |
| **C — Views** | 9. Auth (Splash, Login) · 10. Main tabs (Home, List, Favorites, Profile) · 11. Sub-pages (Detail, Inspection, LoanCalc) · 12. Booking · 13. Profile sub-pages | All screens populated |
| **D — Routing** | 14. `vue-router` with auth guard + `document.title` injection · 15. `vue-i18n` with locale-default-from-user-clarification | Navigable |
| **E — Polish** | 16. Wire dead-end CTAs · 17. Skeleton loaders · 18. PWA manifest + sw.js · 19. Verify viewport=412 + browser smoke test | Shippable |
| **F — Knowledge feedback** | 20-22. Update knowledge / skills (gated by APEX 0 confirmation per file) | Recipe updated |

### N.2 Sample-image study protocol

When user provides ≥4 reference screenshots:
1. **Vision-pass each image individually** — extract page type, layout, colors (hex if guessable), typography, key components, design language, and which required-page it inspires.
2. **Synthesize a unified design language** — find the dominant style; flag outliers.
3. **Per-required-page mapping table** — every required page in `requirement.md` gets 1-3 sample filenames. Document in `blueprint.md §5.6`.
4. **Cross-sample layout signatures** — patterns recurring in 3+ samples become design rules (e.g. yellow search-pill, 5-col quick-action grid, 2-col cards with red price + strikethrough, sticky 5-button action bar, bottom-sheets with rounded-top + agent avatar).
5. **Token consensus** — colors that appear in ≥3 samples become the canonical palette, NOT the AI's invention.

### N.3 Tailwind v4 — prefer `@theme` block in CSS over `tailwind.config.ts`

Tailwind v4 introduced an inline `@theme { --color-primary: #FFCC00; }` block in CSS. Use that as the primary token surface. `tailwind.config.ts` becomes optional (often omitted). Reference all design tokens via `bg-(--color-primary)` arbitrary-value-from-CSS-var syntax — this collapses tokens + Tailwind into ONE place. Lessons:
- Drop `postcss.config.js` to a no-op `export default { plugins: {} }`.
- Use `@import 'tailwindcss';` at the top of `global.css`.
- Custom utilities (`.shadow-card`, `.glass-overlay`, `.tap`, `.skeleton`, `.h-scroll`, `.status-strip`, `.btn-yellow`, `.btn-red`, `.trust-card`) live in the same file as the `@theme` block.

### N.4 CVA + Headless UI Vue is the form-stack winner

Element Plus / Naive UI / Vant 4 are **rejected** for Tailwind-themed mobile apps:
- They ship their own theme variables that fight your `@theme` block.
- Mobile-tuned input behavior is achievable with native `<input>` + Tailwind in ~50 lines per component.
- Headless UI Vue (`Listbox`, `RadioGroup`, `Switch`) covers the keyboard / aria-rich primitives. CVA (`class-variance-authority`) gives variant typing.

**Canonical 9-component set** (build all of them at the start of Phase B):

`AppButton` (CVA: primary/red/secondary/ghost/dark/link × sm/md/lg/block/icon) · `AppInput` (leading icon + error/disabled) · `AppSelect` (Headless Listbox) · `AppDatePicker` (7-day chip grid for booking-style flows; date library only when needed) · `AppCheckbox` (custom svg tick — supports `<div>` wrap + `@click.stop` on inline link per IMAGE_TO_MOBILE_APP_PIPELINE §6.2) · `AppSwitch` (Headless or hand-rolled) · `AppRangeSlider` (native range overlay, custom thumb + fill — used for loan calc + price filter) · `AppChip` (active drives a `computed` — never decorative) · `AppImage` (fallback SVG on error, lazy-load).

### N.5 Page-stack back navigation

For mobile apps with chained sub-pages (Browse → Detail → Inspection → back to Browse), a single `previousPage` ref breaks. Use `pageStack: ref<string[]>([])` updated on every route change. The `AppHeader.back()` pops the stack, falling back to `/home` when empty. Implemented at [`c:/Users/user/Desktop/carMVP/template/src/components/AppHeader.vue`](c:/Users/user/Desktop/carMVP/template/src/components/AppHeader.vue) (uses `window.history.length` + fallback as MVP variant).

### N.6 Mock + Supabase seam pattern

Default `VITE_DATA_MODE=mock`. Stores ship hardcoded seed data (`mockData.ts` with 12 cars, 1 dealer). `src/config/supabase.ts` exposes `supabaseEnabled` flag for runtime swap; stores read from mock unless flag is true. This delivers a demo-able template in hours without a backend, while leaving a clean swap-in seam.

### N.7 Locale-default-from-user-clarification

If user-supplied references are in a non-English language (Chinese / Bahasa / etc.) AND the user does not explicitly state otherwise, **default the i18n locale to that language**, not English. The carMVP samples were Chinese → `zh.json` ships as default + fallback, with `en.json` and `ms.json` as switchable mirrors.

### N.8 Required artifacts for sample-driven mobile builds

A complete sample-driven build emits ALL of:
- `template/blueprint.md` with §0 user-request-verbatim block + §5.6 per-sample mapping table
- `template/README.md` with quick-start + page index
- `template/src/assets/global.css` with `@theme` tokens
- 7 stores + 9 components + ≥12 views + 16+ routes
- `public/site.webmanifest` + `public/sw.js` + `public/favicon.svg`
- All UI strings in user-default-locale; en/ms files as mirrors

---

### N.9 Tag / Chip / Subtab Wiring Mandate (carMVP iteration 2 lesson)

> Added 2026-05-08 after auditing the first carMVP build — discovered that ~60% of visible tags (subtabs, quick-action grid items, profile-services row) were rendered but **did nothing on click**. User explicitly flagged this as a defect.

**The mandate**: Every tappable surface (chip, pill, sub-tab, quick-action icon, services-row item, brand circle, filter chip, sort option, promo card) **MUST drive one of three side-effects**:
1. `router.push(...)` — navigation
2. A store mutation that visibly changes the displayed list (`cars.setFilters({...})`, `cars.setSort(...)`, `cars.resetFilters()` then push)
3. `useUiStore().addToast(...)` / open a modal / sheet — explicit feedback that the action was registered

**Forbidden**: A `@click` handler that only mutates a local `ref` for visual underline state without re-driving the displayed content. **A subtab that only changes its own underline is a defect, not a feature.**

**Practical patterns**:

```ts
// ❌ WRONG — subtab is purely decorative
const activeSubtab = ref(0)
// template just toggles activeSubtab; carousel below uses static computed

// ✅ RIGHT — subtab key drives the data slice
const activeSubtab = ref<SubtabKind>('recommend')
const featured = computed(() => {
  switch (activeSubtab.value) {
    case 'recommend': return all.slice(0, 6)
    case 'hot':       return [...all].sort((a, b) => b.priceMyr - a.priceMyr).slice(0, 6)
    case 'sales':     return [...all].sort((a, b) => a.mileageKm - b.mileageKm).slice(0, 6)
    case 'ev':        return all.filter((c) => c.fuelType === 'ev' || c.fuelType === 'hybrid')
  }
})
```

```ts
// ❌ WRONG — quickAction items all push to same generic route
{ key: 'rank', label: '排行榜', icon: 'leaderboard' /* and template @click="router.push('/cars')" */ }

// ✅ RIGHT — each item carries its own go() with the specific filter intent
interface QuickAction { key: string; label: string; icon: string; go: () => void }
const quickActions: QuickAction[] = [
  { key: 'rank', label: '排行榜', icon: 'leaderboard',
    go: () => { cars.resetFilters(); cars.setSort('priceDesc'); router.push('/cars') } },
  { key: 'new',  label: '新车上市', icon: 'fiber_new',
    go: () => { cars.resetFilters(); cars.setFilters({ yearMin: 2022 }); cars.setSort('yearDesc'); router.push('/cars') } },
  // ...
]
```

**URL-driven cross-navigation**: when a quickAction wants to land on a list page in a specific tab + drawer state, use query params (`/cars?filter=open`, `/cars?promo=discount`) and `onMounted` reads `route.query` to set `showFilter.value = true` or `activeTab.value = 'discount'`. This makes deep links shareable AND keeps Home → CarList intent expressive.

**Audit grep**: search every Vue file for `<button` and `<AppChip` — every match must have an `@click` handler, AND the handler must reference the router or a store. Pure local-ref toggles need a `computed` consumer downstream that re-renders content.

**Two-layer filter pattern**: when a list page has BOTH a filter drawer AND tab-strip, model them as composable layers:

```ts
// Layer 1: store-level filters (drawer)
const filteredCars = computed(() => cars.list.filter(applyFilters))   // store getter
// Layer 2: view-level tab refinement on top
const tabFilteredCars = computed(() => {
  const base = cars.filteredCars
  switch (activeTab.value) {
    case 'discount':  return base.filter((c) => c.originalPriceMyr && c.originalPriceMyr > c.priceMyr)
    case 'ev':        return base.filter((c) => c.fuelType === 'ev' || c.fuelType === 'hybrid')
    case 'available': return base.filter((c) => c.status === 'available')
    case 'all':       return base
  }
})
```

The view binds to `tabFilteredCars`, the FilterDrawer "查看 N 辆" count uses `cars.filteredCars.length` (pre-tab) — semantically correct for both surfaces.

### N.10 Brand-Logo 3-Tier Fallback Pattern

> Added 2026-05-08. carMVP user requested replacing letter-only brand circles with real logos. Naive approach (`<img src="https://cdn.simpleicons.org/{slug}">`) breaks for 3 reasons: (a) some brands have wrong-company collisions (e.g. SimpleIcons `proton` returns Proton **Mail** logo, not the Malaysian car maker Proton), (b) some major brands aren't on SimpleIcons (Mercedes-Benz, Lexus, BYD), (c) regional brands never make CDN catalogs (Proton, Perodua, etc).

**The pattern** — `BrandLogo.vue` component with a 3-tier ordered fallback:

```ts
// Tier 1: Explicit allow-list of SimpleIcons CDN slugs (NEVER auto-derive from `code`).
const cdnSlug: Record<string, string> = {
  toyota: 'toyota', honda: 'honda', bmw: 'bmw', mazda: 'mazda', nissan: 'nissan',
  audi: 'audi', subaru: 'subaru', volvo: 'volvo', ford: 'ford', kia: 'kia',
  hyundai: 'hyundai', porsche: 'porsche', volkswagen: 'volkswagen', tesla: 'tesla',
}
// Brands NOT on SimpleIcons OR with wrong-brand collisions are deliberately omitted.

// Tier 2: Hand-drawn inline SVG for known-missing brands.
const inlineSvg: Record<string, { paths: string; viewBox: string }> = {
  mercedes:  { viewBox: '0 0 64 64', paths: '<circle cx="32" cy="32" r="30" .../>...3-pointed star...' },
  lexus:     { viewBox: '0 0 64 64', paths: '<ellipse .../><path d="M22 20 L22 44 L42 44" .../>' },
  byd:       { viewBox: '0 0 64 64', paths: '<rect .../><text>BYD</text>' },
  proton:    { viewBox: '0 0 64 64', paths: '<circle .../><path d="M22 24..."/>...tiger emblem...' },
  perodua:   { viewBox: '0 0 64 64', paths: '<ellipse .../><path .../>' },
}

// Tier 3: Letter-circle fallback — first character of brand name.
// Also triggered by Tier-1 <img> @error handler (CDN 4xx/5xx, network blocked).
```

**CDN URL patterns** — pick one for your design:
- `https://cdn.simpleicons.org/{slug}` — **DEFAULT (recommended)** — auto-serves the brand's official color. Yields a vibrant, instantly-recognizable logo wall (Toyota red, BMW blue, Mercedes silver, etc).
- `https://cdn.simpleicons.org/{slug}/000000` — black tone, for monochrome card grids that prioritize layout consistency over brand recognition.
- `https://cdn.simpleicons.org/{slug}/{hex}` — any custom hex (no `#`). Useful for forcing a single brand-tone palette (e.g. all `FFCC00` to match the app's primary).

**For inline-SVG fallbacks (Tier 2)** — color the SVG with the brand's official palette, NOT `currentColor`. Mercedes uses silver-on-black 3-pointed star; BYD uses white wordmark on `#E60012` red; Proton uses tiger head with red `#E32227` background + gold `#FFD700` eye accents. Do not auto-derive these — paste the colors from the brand's press kit / Wikipedia infobox. (For carMVP, Proton + Perodua were drawn from the Malaysian Jalur Gemilang adjacent palette: red `#E32227`, blue `#003F87`, gold `#FFD700`.)

**User-flag from carMVP iteration**: monochrome (`/000000`) was rejected as "too gray". Color-by-default is the human-preferred direction — record this as the working convention unless the surrounding card grid is explicitly low-contrast (e.g. dark hero card with white text, where a single tone is clearer).

**Verification protocol** before adding a brand to the CDN allow-list:
1. `curl -s -o /dev/null -w "%{http_code} %{size_download}\n" https://cdn.simpleicons.org/{slug}` — must be 200 with non-zero bytes.
2. **Eyeball check**: open the URL in a browser and confirm it's the right company. SimpleIcons sometimes hosts logos for protocols/products with the same name (Proton Mail vs Proton cars; Tesla Inc vs other Teslas). If wrong → omit from `cdnSlug` and add inline SVG instead.
3. Region-locked brands (Proton, Perodua, GAC, Hongqi) almost never make global icon catalogs — go straight to Tier 2 (inline SVG) or Tier 3 (letter circle).

**Component shape** (full at [`c:/Users/user/Desktop/carMVP/template/src/components/BrandLogo.vue`](c:/Users/user/Desktop/carMVP/template/src/components/BrandLogo.vue)):
```vue
<script setup lang="ts">
const props = defineProps<{ code: string; name: string; size?: 'sm'|'md'|'lg' }>()
const errored = ref(false)
// DEFAULT: brand-true color (no suffix). User feedback: monochrome `/000000` was rejected as "too gray".
const cdnUrl = computed(() => cdnSlug[props.code] ? `https://cdn.simpleicons.org/${cdnSlug[props.code]}` : null)
const showCdn = computed(() => cdnUrl.value && !errored.value)
const showInline = computed(() => !cdnUrl.value && inlineSvg[props.code])
const showLetter = computed(() => !showCdn.value && !showInline.value)
</script>
```

**Why allow-list, not deny-list**: brands silently land on CDNs. New entries can be wrong-brand collisions. An allow-list forces the human-eyeball check; a deny-list assumes you remember to inspect everything.

**Bonus — offline / CSP-restricted environments**: ship pre-fetched SVGs to `public/brands/{code}.svg` and swap the URL constructor to a local path. The 3-tier structure is unchanged.

---

### N.11 Bug-hunt lessons — replace_all guardrail, null-safe route params, demo seeds

> Added 2026-05-08 (carMVP iteration 3). Three production bugs surfaced during the user's audit pass. Each is generalizable.

#### N.11.1 Replace-all guardrail — never rename a token that appears inside its own definition

**The bug** — During refactor I ran `replace_all` of `cars.filteredCars` → `tabFilteredCars` on `CarList.vue`. The replacement greedily corrupted the new computed's own body:
```ts
const tabFilteredCars = computed(() => {
  const base = tabFilteredCars   // ← was `cars.filteredCars`. Now self-referencing. Crash.
  switch (activeTab.value) { ... base.filter(...) }
})
```
Result: the `computed` returned itself (a `ComputedRef`), not an array, and `.filter()` produced `undefined`-elements that crashed `<CarCard :key="c.id">`.

**The mandate**:
1. **Before any `replace_all`**, grep first: does the OLD name appear ANYWHERE the NEW name will land? If yes, the rename is unsafe — switch to scoped per-occurrence Edits.
2. **Avoid name-shadowing patterns** — when the NEW name is a derived view of the OLD source, the OLD source MUST stay reachable inside the NEW definition's body. The instinct to rename "everything that says `cars.filteredCars`" is wrong when one of those usages IS the source feeding `tabFilteredCars`.
3. **Smoke-walk after refactor** — see §N.11.4 below.

#### N.11.2 Null-safe route params + AppEmpty not-found state

**The bug** — Detail pages used `cars.getById(route.params.id) ?? cars.list[0]` as a "graceful" fallback. Result: any wrong URL silently rendered the first car in the list, masking 404s and confusing users who deep-linked to a sold/deleted item.

**The fix**:
```ts
// ❌ WRONG — silent fallback masks the error
const car = computed(() => cars.getById(String(route.params.id)) ?? cars.list[0])

// ✅ RIGHT — return null and show AppEmpty
const car = computed(() => cars.getById(String(route.params.id)))
```
Template:
```vue
<div v-if="car"> ... full detail page ... </div>
<div v-else>
  <AppHeader title="车型详情" show-back />
  <div class="pt-[60px]">
    <AppEmpty
      icon="search_off"
      title="车型不存在"
      message="该车型可能已售出或链接有误。来看看其他在售车型吧"
      cta-label="返回选车"
      cta-icon="directions_car"
      @cta="router.push('/cars')"
    />
  </div>
</div>
```
**TypeScript follow-up** — handlers like `book()` / `inspect()` that read `car.value.id` must early-return on `!car.value` for type narrowing AND defensive coverage when called from the action bar (which should also be `v-if="car"` gated).

**Apply to every route with `:id` / `:carId` params** — Detail / Inspection / BookingForm / LoanCalculator. The list-page or modal that linked there may have stale data; the detail page is the last line of defense.

#### N.11.3 Demo-seed pattern — populate empty stores on first load

**The bug** — Favorites / MyLoans / MyBookings shipped empty on a first visit. The user could not visually grok what those pages would look like populated. Empty-state UI is correct, but for a TEMPLATE / DEMO, "empty on first load" undersells the feature.

**The pattern** — seed the store's `state()` initializer's `storageGet` fallback (NOT inside an `onMounted` — that races against view render):
```ts
const DEMO_FAVORITES: Favorite[] = [
  { carId: 'car-001', savedAt: '2026-05-07T10:00:00Z' },
  { carId: 'car-006', savedAt: '2026-05-07T14:30:00Z' },
]

state: (): FavoritesState => ({
  // localStorage hit → real user data; localStorage miss → DEMO_FAVORITES
  items: storageGet<Favorite[]>(KEY, DEMO_FAVORITES),
}),
```
Once the user toggles even one favorite, the persistence step writes to `localStorage` and the demo seed is naturally replaced by real state. **Self-erasing demo seeds**.

**Apply to every "user-data" store that ships with empty UX**: favorites, saved-calculations, recently-viewed, watchlists. Do NOT apply to `bookings` (those need an authenticated user — let the empty state stand) or `auth` (no demo phone numbers).

#### N.11.4 Smoke-walk every route after a refactor

After any cross-file refactor (rename, extract, replace_all), run a Vite-level smoke walk to catch SFC compile errors that HMR alone won't surface:
```bash
cd template
for f in $(find src/views -name '*.vue') src/App.vue src/components/*.vue; do
  status=$(curl -s -o /dev/null -w "%{http_code}" "http://localhost:3000/$f")
  [ "$status" != "200" ] && echo "FAIL [$status] $f"
done
```
A bad SFC returns 500 from Vite. Silent walks (no `FAIL` lines) prove every file at least parses. Combine with manual click-through for runtime issues like the self-referencing computed (which compiled fine but crashed at render time).

**Cadence**: smoke-walk after every `replace_all`, every batch of view edits, and immediately before declaring a phase complete.

---

### N.12 Iteration-Heavy Mobile App Patterns (carMVP iteration 5+, 2026-05-08)

> Added after a long iteration session — 12 patterns the user actively requested or validated. Each is generalizable to any sample-driven mobile template build.

#### N.12.1 Phone-OTP page split (Login → /login/otp)

A single combined login page (phone + OTP in one view) is acceptable for a barebones MVP, but the **2-step page split** is the user-preferred flow:

```
/login         — Phone-only step. T&C checkbox + send-OTP button.
/login/otp     — OTP-only step. 6-digit grid + 60s resend cooldown.
/signup        — Optional 3rd page when name collection / referral codes are needed.
```

Why split:
- Each step's CTA is unambiguous (`获取验证码` vs `验证并登录`).
- OTP page can `auto-submit` when 6 digits are filled — single-purpose pages do this cleanly.
- Resend cooldown lives in OTP page only — doesn't pollute the phone page when user hits "back".

Auth-store contract for the flow: `sendOtp(phone, intent: 'login' | 'signup', name?: string)` stores a `pendingIntent` + `pendingName` so the OTP page can render context-aware copy ("注册成功" vs "登录成功"). On verify success, route to `auth.pendingReturnTo ?? '/home'` and clear `pendingReturnTo`.

#### N.12.2 6-digit OTP grid input UX

Don't ship a single `<input maxlength="6">`. Use a 6-cell grid:

```vue
<input
  v-for="(_, i) in digits"
  :ref="(el) => setRef(el, i)"
  v-model="digits[i]"
  type="tel"
  inputmode="numeric"
  maxlength="1"
  autocomplete="one-time-code"
  @input="onInput(i, $event)"
  @keydown="onKeydown(i, $event)"
/>
```
Required behaviors:
- **Auto-advance** focus to next box on input.
- **Paste support** — when paste yields >1 char, fan it out across remaining cells and focus the last filled cell.
- **Backspace navigation** — empty cell + backspace → focus previous cell.
- **Auto-submit** when all 6 are filled (`watch(filled, (v) => { if (v) submit() })`).
- `autocomplete="one-time-code"` to invoke iOS / Android system OTP autofill.
- On verify failure: clear all digits + refocus first.

Visual: empty cell `bg-snow border-2 border-transparent`; filled cell `bg-(--color-primary)/10 border-2 border-(--color-primary)`. Square aspect ratio (`aspect-square`).

#### N.12.3 returnTo pattern for post-login navigation

Any guarded action that triggers login MUST capture where the user came from so they can resume after auth. Don't always punt to `/home`.

```ts
// In a guarded view's button handler:
function bookNow() {
  if (!auth.isLoggedIn) {
    auth.setReturnTo(`/booking/${car.value.id}`)
    router.push('/login')
    return
  }
  router.push(`/booking/${car.value.id}`)
}

// In OtpVerify on success:
const back = auth.pendingReturnTo
auth.setReturnTo(null)
router.replace(back ?? '/home')
```

Store the returnTo in the auth store (NOT route query) so it survives the login → otp navigation hop without having to pass it as a query param everywhere. Clear it as soon as it's consumed.

#### N.12.4 Themed logout button + ConfirmModal pairing

A logout button on Profile is more discoverable than burying it in Settings. Style it as a "destructive but safe" themed pill:

```vue
<button
  class="w-full h-12 rounded-2xl bg-white border border-(--color-error)/30
         text-(--color-error) font-bold flex items-center justify-center gap-2
         active:scale-[0.99] active:bg-(--color-error)/5 transition shadow-card"
>
  <span class="material-symbols-rounded text-[20px]">logout</span>
  退出登录
</button>
```
Pair with `ConfirmModal` (`danger` prop) so a tap doesn't immediately log out. Always toast on confirm. Always render BOTH the logout button (when authed) AND a 2-column "Login | Signup" CTA grid (when guest) — Profile is the natural home for both states.

#### N.12.5 Page vs Modal for auth — pick by trigger context

| Trigger | Use |
|---|---|
| Tap-favorite / tap-book / tap-contact while browsing | **Modal** (`LoginModal.vue`) — keeps user on page, less context loss |
| Profile "立即登录" / Settings "退出后登录" / explicit auth flow | **Page** (`/login`) — full-screen for serious onboarding moments |

Both can coexist. Page-based gets the multi-step OTP / Signup branches; modal-based stays simple (one form, one verify, dismiss).

#### N.12.6 Filter drawer live-preview count

A filter drawer that shows a count must drive the count from the **local form state**, not the committed store state. Otherwise toggling chips doesn't move the number — looks broken.

```ts
// Local refs for in-progress edits
const localBrand = ref<string[]>(...)
const localPriceMax = ref(PRICE_MAX)

// Live preview — runs same filter logic on local state
const previewCount = computed(() => cars.list.filter((c) => {
  if (localBrand.value.length && !localBrand.value.includes(c.make.toLowerCase())) return false
  if (localPriceMax.value < PRICE_MAX && c.priceMyr > localPriceMax.value) return false
  // ... rest of the predicates
  return true
}).length)
```

Apply button reads `查看 ${previewCount} 辆`. Reset button clears BOTH locals AND committed store filters (`cars.resetFilters()`) so underlying list shows everything. Use **`isDirty` computed** to disable Reset when nothing has been changed yet. Treat slider at upper-bound as `undefined` (no-limit), not the upper-bound value.

#### N.12.7 Tab strip MUST swap panels, not just the underline

Symptom of failure: clicking a tab moves the yellow underline but the content area stays identical. User flags it as "tag has no url page still coming soon."

Fix: each tab key maps to its own `<template v-if="activeTab === 'X'">` block with distinct content. For a Detail page (`基础信息 / 档案 / 车况 / 价格分析`), each tab brings its own data:
- 基础信息 → loan widget + description + compare CTA
- 档案 → ownership facts + service log timeline
- 车况 → photo gallery slider + 21-item check grid + warranty
- 价格分析 → market position bar + same-model comparison + trend hint

Generic data-derivation tip: each tab's content can be a `computed` off the source entity (e.g. `archiveFacts`, `priceAnalysis`) — keeps the script clean and the template declarative.

#### N.12.8 Map-icon → external maps deep-link

A `<map>` button in the header should NOT route to an in-app placeholder map page (huge effort, low value). Use the platform Maps URL scheme:

```ts
function openMap() {
  const addr = dealer.address
  window.open(`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(addr)}`, '_blank')
}
```

Same playbook for `tel:` (call) and `https://wa.me/<phone>?text=...` (WhatsApp). Native-feel without writing a single line of native.

#### N.12.9 Shared `DealerContactSheet` bottom-sheet

When 3+ surfaces (Home, Profile shortcut, ContactSheet on Detail) all want to expose phone / WhatsApp / email / map → factor into a single `<DealerContactSheet v-model:open="...">` component. The dealer info is in the `cars` store, so the sheet self-hydrates — every consumer just toggles open. Pair with `Teleport to="body"` + `<transition>` for the bottom-sheet animation.

#### N.12.10 Photo gallery — image-only horizontal slider, 3-per-view

For a "实拍细节" (real photos) section in a marketplace detail page:
- ✅ Horizontal scroll rail (`.h-scroll`) with `size-28` (112px) image tiles
- ✅ Pure images, **no labels** — labels were a misread of the requirement that asked for "实拍细节图" (real detail photos), not iconographic placeholders
- ✅ Tap any tile → opens the Lightbox at that index
- ❌ Don't ship a 6-cell grid with text under each — that's an iconography pattern, not a gallery
- ❌ Don't put status pills ("良好", "正常磨损") on photo tiles unless the photo IS that condition's evidence

Combine `car.photos` (the seeded shots) with a small array of stock detail-shot URLs to top up to 6+ photos when the car only has 1-2 hero shots:

```ts
const galleryPhotos = computed(() => {
  const seeded = car.value.photos
  const stock = STOCK_DETAIL_URLS.slice(0, Math.max(0, 6 - seeded.length))
  return [...seeded, ...stock]
})
```

#### N.12.11 Form-page family pattern

For "user submits info" pages (feedback / sell-my-car / free-estimate), follow this skeleton:
1. **AppHeader** with `show-back` (no bottom-nav).
2. **Optional dark hero promo card** at top — sells the page's value (e.g. "最快 1 小时报价").
3. **Body sections**: each form field group in its own `bg-white rounded-2xl shadow-card p-5` block. Don't cram everything into one giant card.
4. **Bottom CTA bar** `fixed bottom-0` with safe-area padding.
5. **All inputs use `<AppInput>` / `<AppSelect>` / `<AppRadioGroup>` / `<AppDatePicker>`** — never raw HTML elements (consistency with the design system).
6. **Submit handler**: validate field-by-field (`if (!brand.value) return ui.warn('请选择品牌')`), simulate network with `setTimeout`, toast success, `router.back()`.
7. **For computational pages** (estimator), put the result in a `bg-(--color-ink) text-white rounded-3xl` dark hero card so it visually pops vs the form.

#### N.12.12 Floating filter FAB on scroll

When a list page has a sticky-header filter button, users on long lists lose access once they scroll past it. Solution: a **floating filter FAB** that fades in once `scrollY > threshold`:

```vue
<transition name="fab-fade">
  <button
    v-if="showFloatingFilter"
    class="fixed top-[6px] right-[10px] z-40 size-[44px] rounded-full
           bg-(--color-primary) shadow-card-hover grid place-items-center"
    @click="showFilter = true"
  >
    <span class="material-symbols-rounded text-[24px] fill-1">tune</span>
    <span v-if="hasActiveFilters" class="absolute top-1 right-1 size-2.5
          rounded-full bg-(--color-accent-red) ring-2 ring-white" />
  </button>
</transition>

<style>
.fab-fade-enter-active, .fab-fade-leave-active {
  transition: opacity 220ms cubic-bezier(0.32, 0.72, 0, 1),
              transform 220ms cubic-bezier(0.32, 0.72, 0, 1);
}
.fab-fade-enter-from, .fab-fade-leave-to {
  opacity: 0;
  transform: scale(0.6) translateY(-12px);
}
</style>
```
Required behaviors:
- `window.addEventListener('scroll', onScroll, { passive: true })` on mount; remove on unmount.
- Threshold ~ height of sticky header + 1-2 chip rows (often 280px).
- **Active-filter dot** in the corner of the FAB if `hasActiveFilters` — at-a-glance state.
- Tap → opens the same `CarFilterDrawer` as the in-header button.

User feedback over iterations homed in on `top-[6px] right-[10px] size-[44px]` — closer to the corner and slightly smaller than the typical FAB. Record it.

#### N.12.13 Toast cadence

Default `addToast(msg, variant, duration = 1500)` — **not 2400ms**. Long toasts feel laggy on mobile. Pair with quick 140ms enter / 120ms leave transitions. The user feedback was explicit: "fade out quicker and display time will be shorter."

Any toast that conveys *unactionable* confirmation ("已加入收藏", "已保存") should use the default 1500ms. Reserve longer durations (2500-3000ms) for warnings / errors that the user must read. Never longer than 4000ms — at that point use a `ConfirmModal` instead.

#### N.12.14 Tailwind v4 `@theme` cascade gotcha

CSS custom utilities defined AFTER `@import 'tailwindcss';` (e.g. `.h-scroll { gap: 8px }`) WILL OVERRIDE Tailwind's same-class utility (`.gap-8`). When a Tailwind utility appears not to apply, check whether your global.css has a more specific or later-cascading rule on the same class. The fix is usually to move the utility from a parent container to each child element (e.g. `gap-8` on the flex parent → `px-4` on each button child).

---

_The reference template at [c:/Users/user/Desktop/insurance-CRM/template/](c:/Users/user/Desktop/insurance-CRM/template/) is the canonical implementation. The carMVP template at [c:/Users/user/Desktop/carMVP/template/](c:/Users/user/Desktop/carMVP/template/) is the canonical sample-image-driven mobile-marketplace implementation. Read these whenever this recipe is ambiguous._
