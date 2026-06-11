---
name: header-footer-design-rules
description: "Authoritative rules for mobile-app headers and footers. Header sticky/scroll-aware behavior, footer 5-slot layout with labels and center FAB, in-page tab navigators (filter chips, segmented tabs) MUST actually filter the list. Apply to every Vue mobile app built with this design DNA. Read whenever building, auditing, or refactoring a header/footer/tab pattern."
type: rules
tier: 1
phase: 0-foundation
priority: SUPREME
model_hint: codex-gpt-5.3
applies_to: ["claude", "claude-code", "codex-gpt-5.3", "antigravity"]
authored_by: claude-opus-4-7
authored_for: "shared cross-AI use"
requires: ["../MOBILE_APP_DESIGN_RECIPE.md", "../0_apex/USER_DNA.md", "DESIGN_SOP.md", "../0_apex/SOVEREIGN_BLUEPRINT_PROTOCOL.md"]
related: ["UI_DNA_MASTER.md", "INDUSTRIAL_INTERACTION_LIBRARY.md", "DESIGN_PSYCHOLOGY_2026.yaml", "../archive/wrider_design_senses.md"]
reference_implementation: "c:/Users/user/Desktop/insurance-CRM/template/src/components/BottomNav.vue"
companion_files: ["BLUEPRINT.md", "DESIGN.md"]
version: 1.0
date: 2026-05-07
status: authoritative
triggers:
  - "header design"
  - "footer design"
  - "bottom nav"
  - "tab navigator"
  - "filter chips"
  - "scroll-aware header"
  - "fix header"
  - "fix footer"
  - "header rules"
  - "footer rules"
---

# 📱 HEADER & FOOTER DESIGN RULES (v1.0)

> Mobile-app top-bar and bottom-bar are the two most-touched elements. They make or break perceived quality. These are **MUST FOLLOW** rules for every Vue mobile app built in this design DNA — codified from the 2026-05-07 wallet-template build session and cross-referenced against [USER_DNA](../0_apex/USER_DNA.md), [DESIGN_SOP](DESIGN_SOP.md), [UI_DNA_MASTER](UI_DNA_MASTER.md), and [DESIGN_PSYCHOLOGY_2026](DESIGN_PSYCHOLOGY_2026.yaml).

---

## 0. Gemini 3 Flash reading notes

- All rules use `MUST` / `MUST NOT` / `SHOULD` voice.
- **Compliance over creativity** — these aren't suggestions.
- Read this file BEFORE editing any `BottomNav.vue` or any `<header>` block.
- Every rule cites the source design principle (User DNA, native iOS/Android, etc.).

---

## 1. HEADER RULES (sticky / fixed / scroll-aware)

### 1.1 Hard rules (apply to every app, every page)

| # | Rule | Why |
|---|---|---|
| H1 | Header height MUST be ≤ **90 px** total (incl. padding) | iOS native nav bars are 44-50 px; Material AppBar is 56 px. 90 px is the absolute ceiling for one-line headers. Anything taller wastes mobile real estate. |
| H2 | Top padding `pt-6` (24 px) — NOT `pt-12` | The 412 px desktop frame has no notch. `pt-12` (48 px) reads as wasted space. |
| H3 | Header MUST be `sticky top-0 z-30` (default) | Standard mobile nav pattern. The header should follow scroll, not disappear. |
| H4 | Background uses **pure `bg-white`** for the fixed always-visible header AND for the hidden fixed header in Variant B | The page body is `bg-snow` (#f7f7f7), the header is `bg-white` (#ffffff). The 1-shade contrast separates header from content cleanly without needing a border. **Never use `bg-snow/95 backdrop-blur-md`** — translucent headers look noisy on patterned backgrounds. |
| H4b | Headers MUST add `.shadow-header` (shallow downward shadow) | The 1-shade lift between snow body and white header is too subtle on its own. A `box-shadow: 0 4px 16px -8px rgba(16,23,28,0.07), 0 1px 0 rgba(16,23,28,0.04)` defines the boundary cleanly without looking heavy. Mirror of the BottomNav's `.shadow-nav` (which points up). |
| H10 | Brand logo MUST be loaded via Vite import (`import logoUrl from "../assets/<file>.png"`), then used as `<img :src="logoUrl">` | Direct `/path/to/asset` strings break in production builds because Vite doesn't hash them. Imports get content-hashed automatically. The `:size-9 rounded-2xl object-cover shadow-sm` shape matches the iOS app-icon convention. |
| H11 | Every flex item in a header MUST have `shrink-0` and text MUST have `leading-none` | The header is a tight horizontal layout — without `shrink-0` images can compress when the title is long; without `leading-none` text vertical-centers off-axis because line-height adds invisible padding. Both are required for pixel-clean alignment. |
| H4a | Header icon buttons use `bg-mint/30 text-ink` (no border) | On a pure-white header, white-on-white buttons disappear. Soft mint (the brand accent at 30 % opacity) gives subtle definition + ties to theme + no border needed. |
| H5 | Title is `text-[18px] font-bold` for sub-pages, `text-[24px] font-bold` for main tabs | Sub-page titles are smaller (less visual noise during navigation). Main-tab titles are bolder/larger because they anchor identity. |
| H6 | Left slot: back button (sub-pages) OR menu (main tabs) | Always reachable with thumb. Never empty. |
| H7 | Right slot: contextual action (search / share / more / +) | Never decorative. If no action exists, find one (toast, modal, navigation). |
| H8 | Both icon-buttons MUST be `size-11 rounded-full bg-mint/30 grid place-items-center text-ink` (no border) | Touch target ≥ 44 px (Apple HIG). Soft mint tint stands out on the pure-white header without competing for attention. |
| H9 | Header text MUST be `text-ink` on light bg, `text-white` on dark bg | High contrast. Never use `text-slate-400` or lighter on a `bg-snow` header — fails WCAG AA. |

### 1.2 Three header behavior variants — `position: fixed` is non-negotiable

The AI MUST choose ONE of these three patterns per page. **Headers MUST use `position: fixed`, NOT `position: sticky`.** Fixed is locked to the viewport at the top, edge-to-edge, never scrolls. Sticky has too many failure modes (broken by `overflow: hidden` ancestors, transforms, undefined parent height).

| Variant | When to use | DOM structure |
|---|---|---|
| **A · Always-visible fixed header** (default for sub-pages) | Sub-pages, forms, lists, settings, all main tabs that are NOT decorative dashboards | One `<header>` element, `position: fixed`, always opaque. Page content gets top padding to clear it. |
| **B · Hidden fixed header + in-flow greeting** (Home / Dashboard) | Home page where the top is decorative content (greeting, avatar, stats) | TWO elements: (1) in-flow greeting that scrolls with the page, (2) a **separate** fixed header that is INVISIBLE by default and fades in only after scrollY passes a threshold (40-80 px). |
| **C · Dark hero header (rounded bottom)** | Stat / report pages where the hero IS the header | `bg-ink text-white px-6 pt-6 pb-9 rounded-b-[40px]` in normal flow with mint/gold blob accents. No fixed companion. |

### 1.2.1 Variant A — fixed always-visible (My Cards, Settings, every sub-page)

```
SCROLL POSITION 0                    SCROLL POSITION 200px
┌───────────────────────────┐        ┌───────────────────────────┐
│ ◀     My Cards         ⚙ │ ← FIXED │ ◀     My Cards         ⚙ │ ← STILL FIXED
│   bg-snow/95 + blur       │        │   bg-snow/95 + blur       │   (locked to viewport top,
├───────────────────────────┤        ├───────────────────────────┤    page content scrolled
│ Credit Card 1   ··· ···   │        │ Credit Card 3   ··· ···   │    UNDER it)
│ $120,000.00               │        │ $320,000.00               │
└───────────────────────────┘        └───────────────────────────┘
```

**CSS**: `fixed top-0 left-0 right-0 z-30 max-w-[412px] mx-auto bg-snow/95 backdrop-blur-md`
**Page content wrapper**: must have `pt-[80px]` (or whatever the header height is) so content isn't hidden under the header on initial render.

### 1.2.2 Variant B — hidden fixed header + in-flow greeting (Home only)

```
SCROLL POSITION 0                    SCROLL POSITION > ~80px
┌───────────────────────────┐        ┌───────────────────────────┐
│                           │        │  👤 Anna K.        🔔     │ ← FIXED HEADER
│  👤 Good morning  🔍 🔔  │ ← IN-   │   appears, fades in       │   (was invisible,
│     Anna K.               │   FLOW │   bg-snow/95 + blur       │    now revealed
│                           │        ├───────────────────────────┤    by scrollY > 80)
│   ······· dot pattern     │        │ Visa wallet card          │
│  Your wallet              │        │ $8,630.25                 │
│  ┌─────────────────────┐  │        │ ┌─────────────────────┐   │ ← in-flow greeting
│  │ Visa wallet card    │  │        │ │  scrolled away      │   │   has scrolled OFF
│  │ $8,630.25           │  │        │ │  out of view        │   │   the screen
└───────────────────────────┘        └───────────────────────────┘
```

**The fixed header is NEVER visible at scroll = 0**. It only appears once the in-flow greeting has scrolled out. The greeting itself is just regular page content (no special positioning).

### 1.2.3 Decision matrix — which variant per page type

| Page archetype | Variant | Why |
|---|---|---|
| Home / Dashboard with decorative greeting | **B** | Top is meant to feel "open" / immersive. Fixed bar would clutter the first impression. |
| Cards / Wallet / Analytics / Profile (main tab, content from pixel one) | **A** | Header info matters from first pixel. |
| Sub-page with back button (Detail / Edit / Settings / History / Calendar / etc.) | **A** | Information bar — must be readable always. |
| Stat / Report / Onboarding / Login | **C** | Hero IS the header. |
| Camera / scanner / full-bleed | _absolute over content_ | Translucent buttons over content layer. |

### 1.2.2 Decision matrix — which variant per page type

| Page archetype | Variant | Why |
|---|---|---|
| Home / Dashboard with decorative top (greeting + pattern) | **B** | Top is meant to feel "open" / immersive at first glance |
| Wallet / Cards / Analytics / Profile (main tab, content starts immediately) | **A** | Header info matters from the first pixel; transparency would clash with title/pill |
| Sub-page with back button (Detail / Edit / Settings / History / Calendar / etc.) | **A** | Information bar — must be readable always |
| Stat / Report / Onboarding / Login | **C** | Hero IS the header — no separate floating bar |
| Camera / scanner / full-bleed | _absolute over content_ | Special; use translucent buttons over the content layer |

### 1.3 Variant A implementation (fixed always-visible)

```vue
<template>
  <!-- Fixed header — locked to viewport top, edge-to-edge inside the 412px container -->
  <header
    class="fixed top-0 left-0 right-0 z-30 max-w-[412px] mx-auto px-6 pt-6 pb-3 flex items-center justify-between bg-white"
  >
    <!-- Back: pops the page-stack in App.vue -->
    <button
      @click="$emit('back')"
      class="size-11 rounded-full bg-mint/30 grid place-items-center text-ink"
    >
      <span class="material-symbols-outlined text-[22px]">arrow_back</span>
    </button>
    <h1 class="text-[18px] font-bold">Page title</h1>
    <button class="size-11 rounded-full bg-mint/30 grid place-items-center text-ink">
      <span class="material-symbols-outlined text-[22px]">tune</span>
    </button>
  </header>

  <!-- Page wrapper — top padding clears the fixed header (~80 px) -->
  <div class="w-full min-h-screen bg-snow pt-[80px] pb-24">
    <!-- page sections -->
  </div>
</template>
```

The `max-w-[412px] mx-auto` keeps the fixed bar inside the desktop frame. Without it, on a desktop browser window the bar would stretch the entire viewport width.

### 1.4 Variant B implementation (hidden fixed header + in-flow greeting)

```vue
<script setup lang="ts">
import { ref, onMounted, onUnmounted } from "vue";

// Listen to BOTH <main> and window — depending on wrapper height,
// either becomes the scroll container. Taking the max handles both cases.
const scrolled = ref(false);
let mainEl: HTMLElement | null = null;

const onScroll = () => {
  const mainY = mainEl?.scrollTop ?? 0;
  const winY = window.scrollY || document.documentElement.scrollTop || 0;
  scrolled.value = Math.max(mainY, winY) > 80;
};
onMounted(() => {
  mainEl = document.querySelector("main");
  mainEl?.addEventListener("scroll", onScroll, { passive: true });
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll(); // run once in case page loads pre-scrolled
});
onUnmounted(() => {
  mainEl?.removeEventListener("scroll", onScroll);
  window.removeEventListener("scroll", onScroll);
});
</script>

<template>
  <!-- Hidden fixed header — invisible at top, appears after scrollY > 80 -->
  <header
    class="fixed top-0 left-0 right-0 z-30 max-w-[412px] mx-auto px-6 pt-6 pb-3 flex items-center justify-between bg-white transition-all duration-300"
    :class="scrolled ? 'opacity-100 translate-y-0 pointer-events-auto' : 'opacity-0 -translate-y-2 pointer-events-none'"
  >
    <!-- compact: avatar + condensed title + action -->
    <img src="..." class="size-9 rounded-full" />
    <h1 class="text-[16px] font-bold">Anna K.</h1>
    <button class="size-9 rounded-full bg-mint/30 grid place-items-center text-ink">
      <span class="material-symbols-outlined text-[20px]">notifications</span>
    </button>
  </header>

  <!-- Page wrapper — NO top padding needed, greeting is in normal flow -->
  <div class="w-full min-h-screen bg-snow pb-24">

    <!-- IN-FLOW greeting — scrolls away, NOT a header -->
    <section class="px-6 pt-12 flex items-center justify-between">
      <div class="flex items-center gap-3">
        <img src="..." class="size-12 rounded-full" />
        <div>
          <p class="text-[12px] text-slate-500">Good morning</p>
          <p class="text-[18px] font-bold">Anna K.</p>
        </div>
      </div>
      <button class="size-11 rounded-full bg-white border border-slate-100 grid place-items-center">
        <span class="material-symbols-outlined text-[22px]">notifications</span>
      </button>
    </section>

    <!-- rest of page content -->
  </div>
</template>
```

Key points:
- The fixed header has `opacity-0 pointer-events-none` at scrollY = 0. Invisible AND non-interactable.
- `transition-all duration-300` makes the appearance smooth (fades + slides 8 px from top).
- The in-flow greeting is just a regular `<section>` — it scrolls with the page and disappears when user scrolls past it.
- **Listen to BOTH `<main>` AND `window` scroll events** — the App wrapper uses `min-h-screen` so depending on content length, EITHER `<main>` (when overflow-y-auto activates) OR `document.body` becomes the actual scroll container. Taking the max of both `scrollTop`s handles both cases without guessing.
- Run `onScroll()` once inside `onMounted` so the state is correct on initial render (in case the page loads pre-scrolled).
- Threshold of **80 px** is the rule: roughly the height of one greeting block.

### 1.5 Header color choice rules (revised 2026-05-07)

- **Light page (default)**: header `bg-white` (pure, no opacity, no blur). Page body is `bg-snow` (#f7f7f7) so the 1-shade lift cleanly separates header from content.
- **Header icon buttons (light page)**: `bg-mint/30 text-ink`, no border. Mint at 30 % opacity is a soft brand-accent tint that's visible on white but doesn't compete with the title.
- **Dark hero block (Report / Onboarding / Login / Scan)**: header `bg-ink` solid OR transparent over the dark area. Icon buttons inside use `bg-white/10 backdrop-blur` for translucency.
- **Variant B hidden header**: also `bg-white` (matches Variant A). The fade-in animation IS the visual feedback — the bg doesn't need to fade between transparent and translucent.

### 1.5 Header height ladder

| Use case | Height | Composition |
|---|---|---|
| Sub-page header | ~64 px | `pt-6 pb-3` + 44 px icon button row |
| Main tab header (with title) | ~72 px | `pt-6 pb-4` + 44 px icon button row + title |
| Dark hero header | ≤ 90 px | `pt-6 pb-9` + buttons + title |

Never exceed 90 px. If the design needs more (giant balance hero), use a separate `<section>` BELOW the header — don't bloat the header itself.

---

## 2. FOOTER (BOTTOM NAV) RULES

### 2.1 Hard rules

| # | Rule | Why |
|---|---|---|
| F1 | Footer height MUST be ≤ **90 px** (typical 64-72 px) | Same screen-real-estate logic as headers. |
| F2 | Footer MUST be `fixed bottom-0 left-0 right-0 z-40 max-w-[412px] mx-auto` | Always visible. The `max-w-[412px]` clamp matches the viewport mandate. |
| F3 | Footer MUST have `shadow-nav` — shallow upward shadow | Defines the boundary against scrolling content. |
| F4 | All non-center buttons MUST have **equal width** (`flex-1`) | Predictable thumb targets. No visually dominant one over another (the FAB is the exception). |
| F5 | Every non-center button MUST include **icon + text label** | Per 2026-05-07 user requirement. Icons alone fail accessibility and confuse new users. |
| F6 | Text label is `text-[10px] font-semibold` below the icon | Small enough to fit, bold enough to read. |
| F7 | Active tab: `text-ink` icon with `.fill-1` variant + `text-ink` label | Clear "you are here" signal. |
| F8 | Inactive tab: `text-slate-400` (NEVER `text-slate-300` — fails WCAG on `bg-snow`) | Contrast ratio ≥ 3:1 for icon-as-decorative. |
| F9 | Center button: special FAB, takes its own equal slot, raised above the bar via `-translate-y-5` wrapper | Differentiates the primary action without breaking the equal-width grid. |
| F10 | Center FAB: `size-16 rounded-full bg-ink text-white` solid — NO border, NO outline | Border-4 around FAB looks dated; pure ink on snow with shadow is cleaner. |
| F11 | Center FAB icon: simple universal symbol (`add` / `qr_code_scanner` / `bolt`). Avoid two-letter glyphs | Should be readable at glance. |
| F12 | Center FAB has subtle `.fab-float` keyframe (≤ 10 px translateY, ≥ 2 s cycle, infinite) | Draws eye to the primary action. |
| F13 | Center FAB has NO text label | Its size + raised position + animation are enough signal. |

### 2.2 Reference implementation

```vue
<template>
  <nav class="fixed bottom-0 left-0 right-0 z-40 max-w-[412px] mx-auto bg-snow shadow-nav">
    <div class="flex items-center h-[72px]">
      <!-- Tab 1 -->
      <button class="flex-1 h-full flex flex-col items-center justify-center gap-0.5"
        :class="active === 'home' ? 'text-ink' : 'text-slate-400'">
        <span class="material-symbols-outlined text-[24px]"
              :class="active === 'home' ? 'fill-1' : ''">home</span>
        <span class="text-[10px] font-semibold">Home</span>
      </button>

      <!-- Tab 2 -->
      <button class="flex-1 ...">...</button>

      <!-- Center FAB slot -->
      <div class="flex-1 h-full grid place-items-center">
        <div class="-translate-y-5">
          <button class="fab-float size-16 rounded-full bg-ink text-white grid place-items-center
                         shadow-[0_10px_24px_rgba(16,23,28,0.32)] active:scale-95">
            <span class="material-symbols-outlined text-[30px]">add</span>
          </button>
        </div>
      </div>

      <!-- Tab 3 / Tab 4 -->
    </div>
  </nav>
</template>
```

### 2.3 Required CSS in `style.css`

```css
@keyframes float-fab {
  0%, 100% { transform: translateY(0); }
  50%      { transform: translateY(6px); }
}
.fab-float { animation: float-fab 2.6s ease-in-out infinite; }

.shadow-nav {
  box-shadow:
    0 -4px 16px -8px rgba(16, 23, 28, 0.08),
    0 -1px 0 rgba(16, 23, 28, 0.04);
}
```

### 2.4 Footer label vocabulary

Choose terse, single-word labels (max 8 chars):

| Tab role | Acceptable labels |
|---|---|
| Home | Home / Feed / Hub |
| Cards | Cards / Wallet / Pay |
| Stats / Analytics | Stats / Insights / Reports |
| Profile | Profile / Account / Me |
| Search | Search / Find / Discover |
| Activity | Activity / Inbox / Feed |

Never use phrases like "My Profile" or "Bank Cards" — too long for 10 px text under 24 px icon.

### 2.5 Pages that MUST NOT show the footer

The BottomNav whitelist in `App.vue` is:

```ts
const main = ["home", "cards", "wallet", "analytics", "profile"];
const showBottomNav = () => main.includes(currentPage.value);
```

NEVER show BottomNav on:
- Auth flow (Onboarding, Login, Signup, OTP, ForgotPassword, Terms)
- Sub-pages with sticky bottom action bars (ProfileEdit, SendMoney, Terms with Accept footer)
- Full-screen camera / scanner (Scan)
- Detail pages (TransactionDetail, MemberDetail)

If a sub-page needs nav access, use a back button OR a sticky bottom action bar — NOT a half-covered BottomNav.

---

## 3. IN-PAGE TAB NAVIGATORS (filter chips + segmented tabs)

### 3.1 Hard rules

| # | Rule | Why |
|---|---|---|
| T1 | Every tab MUST have a working `@click` handler that updates a `ref<string>` | Decorative tabs are a UX bug. Per 2026-05-07 user mandate. |
| T2 | The `activeTab` / `activeFilter` MUST be a `ref` (not a `const`) | Reactivity is required. |
| T3 | The list rendered below MUST `computed` from the active filter | "Click and active hide and show for item list" — direct user quote. |
| T4 | Empty states (filter returns 0 items) MUST render a friendly message | Silent empty list = bug. |
| T5 | Active state styling MUST be visible: `bg-ink text-white` for primary, `bg-white text-primary shadow-sm` for segmented | One glance must reveal which tab is active. |

### 3.2 Reference: filter chip row (HistoryView pattern)

```vue
<script setup lang="ts">
import { ref, computed } from "vue";

const filters = ["All", "Income", "Expense", "Transfer"];
const activeFilter = ref<string>("All");

const filteredGroups = computed(() => {
  if (activeFilter.value === "All") return groups;
  return groups.map((g) => ({
    ...g,
    items: g.items.filter((t) => t.category === activeFilter.value),
  })).filter((g) => g.items.length > 0);
});
</script>

<template>
  <div class="flex gap-2 overflow-x-auto no-scrollbar">
    <button v-for="f in filters" :key="f"
      @click="activeFilter = f"
      class="shrink-0 px-4 py-1.5 rounded-full text-[12px] font-semibold transition"
      :class="activeFilter === f ? 'bg-ink text-white' : 'bg-white border border-slate-100 text-slate-600'">
      {{ f }}
    </button>
  </div>

  <div v-if="filteredGroups.length === 0" class="text-center py-8 text-slate-500 text-[12px]">
    No transactions match this filter.
  </div>
</template>
```

### 3.3 Reference: segmented tabs (NotificationsView pattern)

```vue
<script setup lang="ts">
const tabs = ["All", "Unread", "Promo"];
const activeTab = ref<string>("All");

const filteredItems = computed(() => {
  if (activeTab.value === "Unread") return items.filter((i) => i.unread);
  if (activeTab.value === "Promo") return items.filter((i) => i.type === "promo");
  return items;
});
</script>
```

Same principle: tab click updates a `ref`, list comes from `computed`.

---

## 4. BUTTON FUNCTION-COMPLETION RULES (the "no silent button" mandate)

### 4.1 Hard rules

| # | Rule |
|---|---|
| B1 | EVERY button MUST do something on click — no silent buttons. |
| B2 | The action MUST be one of: navigate / toast / open modal / dropdown / toggle state / fire form submit / open URL / open native share / call native API. |
| B3 | If the action isn't built yet, fire a contextual `toast.info("Feature name", "Coming soon")` — the button is still wired. |
| B4 | Button labels and icons MUST hint at the action (no `more_horiz` without an action behind it). |

### 4.2 Action mapping per icon

If you see these icons unwired anywhere, fix immediately:

| Icon | Default action |
|---|---|
| `arrow_back` | `$emit('back')` |
| `tune` / `filter_list` | open filter modal / toast "Filters" |
| `more_horiz` / `more_vert` | open action sheet / toast "More actions" |
| `share` | call `navigator.share()` if available, else copy + toast |
| `search` | open search modal / focus search input |
| `add` / `+` | open creation form modal / navigate to create page |
| `notifications` | navigate to NotificationsView |
| `settings` | navigate to SettingsView |
| `edit` | navigate to EditView |
| `done_all` | mark-all-read action + toast |
| `download` | trigger blob download + toast |
| `qr_code_scanner` | navigate to ScanView |

---

## 5. EXAMPLES (where to look)

| Pattern | Reference file |
|---|---|
| Sub-page header with back + title + action | [TransactionDetailView.vue](c:/Users/user/Desktop/insurance-CRM/template/src/views/TransactionDetailView.vue) |
| Main tab header (transparent → solid scroll-aware) | [HomeView.vue](c:/Users/user/Desktop/insurance-CRM/template/src/views/HomeView.vue) |
| Dark hero header with rounded bottom | [ReportView.vue](c:/Users/user/Desktop/insurance-CRM/template/src/views/ReportView.vue) |
| Footer with 5 equal slots + center FAB + labels | [BottomNav.vue](c:/Users/user/Desktop/insurance-CRM/template/src/components/BottomNav.vue) |
| Filter-chip tab navigator with working filter | [HistoryView.vue](c:/Users/user/Desktop/insurance-CRM/template/src/views/HistoryView.vue) |
| Segmented tabs with working filter | [NotificationsView.vue](c:/Users/user/Desktop/insurance-CRM/template/src/views/NotificationsView.vue) |

---

## 6. Verification checklist (run before declaring `[🟢 STATUS: CRYSTAL]`)

- [ ] Every header height ≤ 90 px
- [ ] Every header `sticky top-0 z-30` (default) OR scroll-aware OR dark hero variant
- [ ] Every header has a working back/menu button on the left
- [ ] Every header right-side button does something (no silent buttons)
- [ ] Footer has equal-width slots (`flex-1` each)
- [ ] Footer non-center buttons all have icon + text label
- [ ] Center FAB has no border, has shadow, is solid `bg-ink`, has `.fab-float` animation
- [ ] No `text-slate-300` for icons (fails contrast on snow) — replaced with `text-slate-400`
- [ ] Every in-page tab navigator filters its list (no decorative tabs)
- [ ] Every button has a working `@click` handler
- [ ] BottomNav not shown on auth / sub-pages with sticky action bars / camera

---

## 6.5 SIZE STANDARDS — canonical Tailwind classes (NEVER arbitrary `[Npx]` unless documented)

> **Rule:** every `width`, `height`, `padding`, `margin`, `gap`, `font-size`, and `border-radius` MUST use a canonical Tailwind utility OR a custom token defined in `tailwind.config.js`. Arbitrary `[Npx]` / `[Nrem]` values are FORBIDDEN except for the 3 exceptions below.
>
> **Why:** AI grep + manipulation needs canonical names. `text-2xl` and `h-35` are searchable, replaceable, and globally tunable; `text-[24px]` and `h-[140px]` are opaque pixel literals that fight the design system.

### 6.5.1 Reserved arbitrary values (the only `[Npx]` that may stay)

1. **`max-w-103`** ↔ `[412px]` — the CLAUDE.md viewport mandate value (use canonical `max-w-103` going forward; `[412px]` only allowed as a literal in the inline `<style>` of `index.html` for the `#app` rule).
2. **Wave SVG `viewBox` numbers** — pixel-precise math, must stay numeric.
3. **One-off display headlines** like `text-[40px]` for splash typography that doesn't fit any custom token.

Everything else MUST be canonical.

### 6.5.2 Custom font-size tokens (added to all 3 projects' `tailwind.config.js`)

```js
fontSize: {
  "3xs":   ["9px",  { lineHeight: "12px" }],   // micro eyebrow
  "2xs":   ["10px", { lineHeight: "14px" }],   // standard eyebrow / KPI label
  "mid":   ["13px", { lineHeight: "1.5" }],    // dense body
  "lead":  ["15px", { lineHeight: "1.4" }],    // sub-headline
  "2.5xl": ["26px", { lineHeight: "1.2" }],    // KPI value (agent)
  "3.5xl": ["34px", { lineHeight: "1.1" }],    // hero balance
  "4.5xl": ["44px", { lineHeight: "1.05" }],   // total balance
  "5.5xl": ["56px", { lineHeight: "1.05" }],   // splash amount
}
```

Standard Tailwind text scale (always available): `text-xs` 12 · `text-sm` 14 · `text-base` 16 · `text-lg` 18 · `text-xl` 20 · `text-2xl` 24 · `text-3xl` 30 · `text-4xl` 36 · `text-5xl` 48 · `text-6xl` 60.

### 6.5.3 Canonical mapping table — replace ALL old arbitrary values

| Old `[Npx]` | New canonical | Notes |
|---|---|---|
| **Spacing/sizing** (every multiple-of-4 px is canonical in Tailwind 4) |
| `[412px]` | `103` | container max-width |
| `[420px]` | `105` | atmospheric blob size |
| `[280px]` | `70` | onboarding card width |
| `[230px]` | `57.5` | onboarding back card |
| `[220px]` | `55` | analytics donut |
| `[200px]` | `50` | wallet card height |
| `[180px]` | `45` | gold credit card |
| `[170px]` | `42.5` | onboarding front card height |
| `[150px]` | `37.5` | dark/mint credit cards |
| `[140px]` | `35` | KPI card height (insurance) |
| `[120px]` | `30` | KPI card height (compact) |
| `[110px]` | `27.5` | template water-flow card |
| `[80px]` | `20` | page wrapper top-pad (clears fixed header) |
| `[76px]` | `19` | bottom-nav SVG curve |
| `[72px]` | `18` | BottomNav height |
| `[60px]` | `15` | mini card preview |
| **Typography** (use Tailwind canonical OR custom tokens above) |
| `[9px]` | `text-3xs` | custom |
| `[10px]` | `text-2xs` | custom |
| `[11px]` | `text-xs` (12, +1) OR `text-[11px]` if precision required |
| `[12px]` | `text-xs` | canonical |
| `[13px]` | `text-mid` | custom |
| `[14px]` | `text-sm` | canonical |
| `[15px]` | `text-lead` | custom |
| `[16px]` | `text-base` | canonical |
| `[18px]` | `text-lg` | canonical |
| `[20px]` | `text-xl` | canonical |
| `[22px]` | `text-[22px]` keep OR add `text-1.5xl` | Tailwind has no 22 |
| `[24px]` | `text-2xl` | canonical |
| `[26px]` | `text-2.5xl` | custom |
| `[28px]` | `text-[28px]` keep OR add custom | Tailwind has no 28 |
| `[30px]` | `text-3xl` | canonical |
| `[34px]` | `text-3.5xl` | custom |
| `[36px]` | `text-4xl` | canonical |
| `[40px]` | `text-[40px]` keep | one-off splash headline |
| `[44px]` | `text-4.5xl` | custom |
| `[48px]` | `text-5xl` | canonical |
| `[56px]` | `text-5.5xl` | custom |
| `[60px]` | `text-6xl` | canonical |
| **Border-radius** (uses xs/sm/md/lg/xl/2xl/3xl scale, NOT numbers) |
| `rounded-[16px]` | `rounded-2xl` | |
| `rounded-[24px]` | `rounded-3xl` | |
| `rounded-[32px]` | `rounded-4xl` (custom in this project) | |
| `rounded-[40px]` | `rounded-[40px]` keep OR add `rounded-5xl` (custom) | |

### 6.5.4 The original SIZE STANDARDS reference table

| Element | Class / value | Rem | Pixels @ 100% root | Pixels @ 90% root | Notes |
|---|---|---|---|---|---|
| **Container max-width** | `#app` `max-width: 412px` | — | 412 px | 412 px | **Fixed pixel** — won't scale (preserves CLAUDE.md viewport mandate) |
| **Header height** | `pt-6 pb-3` + `size-11` button | 1.5 + 0.75 + 2.75 | ~80 px | ~72 px | Scales with root |
| **BottomNav height** | `h-[72px]` | — | 72 px | 72 px | Fixed pixel — UI chrome stays predictable |
| **Page wrapper top-pad** | `pt-[80px]` | — | 80 px | 80 px | Fixed — clears the fixed header |
| **Touch target (icon button)** | `size-11` | 2.75 | 44 px | 39.6 px | Apple HIG min 44 — at 90% root drops below; on 360 px screens this is acceptable |
| **Icon button (compact)** | `size-9` | 2.25 | 36 px | 32.4 px | Used in compact contexts |
| **FAB (BottomNav center)** | `size-16` | 4 | 64 px | 57.6 px | |
| **Icon coin in headers** | `size-10 / size-11` | 2.5 / 2.75 | 40 / 44 px | 36 / 39.6 px | |
| **Card radius** | `rounded-2xl` | 1 | 16 px | 14.4 px | |
| **Hero card radius** | `rounded-3xl` | 1.5 | 24 px | 21.6 px | |
| **Card padding** | `p-3` / `p-4` / `p-5` | 0.75 / 1 / 1.25 | 12 / 16 / 20 px | 10.8 / 14.4 / 18 px | |
| **Section gap** | `gap-3` / `gap-4` | 0.75 / 1 | 12 / 16 px | 10.8 / 14.4 px | |
| **Body text** | `text-base` | 1 | 16 px | 14.4 px | |
| **Sub-text** | `text-sm` | 0.875 | 14 px | 12.6 px | |
| **Eyebrow / label** | `text-xs` | 0.75 | 12 px | 10.8 px | |
| **Heading h1 page title** | `text-[24px]` arbitrary | — | 24 px | 24 px | Fixed pixel — heading-scale stays consistent |
| **KPI value** | `text-[22-26px]` arbitrary | — | 22-26 px | 22-26 px | Fixed |
| **KPI label** | `text-[10px]` arbitrary | — | 10 px | 10 px | Fixed |
| **Progress bar height** | `h-1.5` (USER_DNA mandate) | 0.375 | 6 px | 5.4 px | |

### 6.5.1 How to scale all sizes globally

The **only** safe knob is `html { font-size: <%>; }` in the project's `style.css`. Everything rem-based scales with it; everything in arbitrary `[Npx]` form does not.

| Goal | `html` font-size | Effective scale |
|---|---|---|
| Default | `100%` (or unset) | 1.0× |
| **Compact (10% smaller)** | `90%` | 0.9× ← **canonical for tighter mobile feel** |
| Compact (15% smaller) | `85%` | 0.85× |
| Larger | `110%` | 1.1× |

The 90% scale is what all 3 reference projects (template + 2 insurance apps) ship with as of 2026-05-07.

### 6.5.2 Why arbitrary `[Npx]` values stay fixed (not a bug)

Some tokens are deliberately pixel-locked, NOT rem-based:

- **Container `412px`** — pinned to CLAUDE.md viewport mandate
- **BottomNav height `72px`** — pinned so the touch zone stays consistent across font-size scales
- **Page wrapper `pt-[80px]`** — must match the fixed header height regardless of font-size
- **KPI card height `h-[140px]`** — pinned so the wave + content composition stays balanced
- **`text-[10px]` micro-eyebrow labels** — at 10 px these are minimum-legible; if scaled down they'd become illegible
- **Wave SVG dimensions** — `viewBox` math is pixel-precise

This is intentional: rem scales the *content*, fixed pixels lock the *chrome*.

---

## 7. When this file applies

- Every new mobile app built per [MOBILE_APP_DESIGN_RECIPE.md](../MOBILE_APP_DESIGN_RECIPE.md).
- Every refactor / audit of header or footer in any existing project.
- Every BLUEPRINT.md / DESIGN.md should reference these rules in §5 (Design DNA) and §9 (compliance).

---

_Reference template that fully implements these rules: [c:/Users/user/Desktop/insurance-CRM/template/](c:/Users/user/Desktop/insurance-CRM/template/) — see its [BLUEPRINT.md §4 App Shell](c:/Users/user/Desktop/insurance-CRM/template/BLUEPRINT.md) for the live spec._
